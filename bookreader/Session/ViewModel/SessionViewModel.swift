//
//  SessionViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-23.
//

import Foundation

public class SessionViewModel: ObservableObject {
    
    //---- MARK: Properties
    @Published public var currentUser: User? = nil
    
    //---- MARK: Initialization
    init() {
        registerNotifications()
    }
    
    //---- MARK: Helper Methods
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserUpdated(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserUpdatedNotification),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserPurchasedBook(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification),
            object: nil
        )
    }
    
    private func handleBookPurchase(bookId: String, rentalData: (isRental: Bool, rentExpirationTimestamp: Int)) {
        if let userId = currentUser?.id {
            let bookInfo: [String: Any] = [
                "bookId": bookId,
                "isExpired": false,
                "rentExpirationTimestamp": rentalData.rentExpirationTimestamp,
                "progress": 0,
                "isCloudSynced": true,
                "isRented": rentalData.isRental
            ]
            let path: String = "/users/\(userId)/purchased_books/\(bookId)"
            FIRDatabaseManager.shared.setValueAtPath(path: path, value: bookInfo) {
                var updatedBook: Book = Book(id: bookId, name: "")
                updatedBook.isCloudSynced = true
                CoreDataManager.shared.updatePurchasedBook(book: updatedBook)
                print("Added Purchased Book")
            }
        }
    }
    
    private func retrieveUserPurchasedBookList() {
        if let userId = currentUser?.id {
            FIRDatabaseManager.shared.observeDataAtPathOnce(path: "/users/\(userId)/purchased_books") {
                [weak self]
                (snapshot) in
                if let self {
                    self.crossMatchPurchasedBookList(data: snapshot.exists() ? snapshot.value! : nil)
                }
            }
        }
    }
    
    private func crossMatchPurchasedBookList(data: Any?) {
        Task(priority: .userInitiated) {
            [weak self] in
            if let data,
               let dbBooksData: Data = try? JSONSerialization.data(withJSONObject: data),
               let dbBooksArray: [String: Any] = try? JSONSerialization.jsonObject(with: dbBooksData) as? [String: Any] {
                
                if let localBooksArray: [Book] = CoreDataManager.shared.fetchPurchasedBooks() {
                    //Cross reference book ids
                    let dbIds: [String] = dbBooksArray.keys.map {
                        $0
                    }
                    let localIds: [String] = localBooksArray.map {
                        $0.id
                    }
                    
                    if (localIds.count > dbIds.count) {
                        //When local books count is large than db books count
                        var outOfSyncBookIds: [String] = []
                        let dbIdSet: Set<String> = Set(dbIds)
                        for localId in localIds {
                            if (!dbIdSet.contains(localId)) {
                                outOfSyncBookIds.append(localId)
                            }
                        }
                        
                        var results: [String: Any] = [:]
                        var relevantLocalBooks: [Book] = []
                        
                        if let books = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "id IN %@", args: outOfSyncBookIds) {
                            for book in books {
                                if let self,
                                   let currentUser = self.currentUser {
                                    if (!book.isCloudSynced!) {
                                        results["/users/\(currentUser.id!)/purchased_books/\(book.id)"] = [
                                            "bookId": book.id,
                                            "isCloudSynced": true,
                                            "isRented": book.isRented!,
                                            "rentExpirationTimestamp": book.rentExpirationTimestamp ?? 0,
                                            "isExpired": false,
                                            "progress": book.progress!
                                        ]
                                        
                                        var updatedBook = book
                                        updatedBook.isCloudSynced = true
                                        relevantLocalBooks.append(updatedBook)
                                    }
                                }
                            }
                        }
                        
                        print("SessionViewModel: Will write \(results.count) out of sync books to db")
                        if let self {
                            await self.batchUpdatePurchasedBooks(children: results)
                            CoreDataManager.shared.batchUpdatePurchasedBooks(books: relevantLocalBooks)
                        }
                    } else if (localIds.count < dbIds.count) {
                        //When db books count is larger than local books count
                        var outOfSyncBookIds: [String] = []
                        let localIdSet: Set<String> = Set(localIds)
                        for dbId in dbIds {
                            if (!localIdSet.contains(dbId)) {
                                outOfSyncBookIds.append(dbId)
                            }
                        }
                        
                        var results: [Book] = []
                        await withTaskGroup(of: Book?.self) {
                            (taskGroup) in
                            
                            for id in outOfSyncBookIds {
                                taskGroup.addTask {
                                    [weak self] in
                                    var result: Book? = nil
                                    if let self {
                                        result = await self.fetchBookFromDB(bookData: dbBooksArray[id] as! [String: Any])
                                    }
                                    return result
                                }
                            }
                            
                            for await result in taskGroup {
                                if let result {
                                    results.append(result)
                                }
                            }
                        }
                        
                        print("SessionViewModel: Will add \(results.count) out of sync books to core data")
                        for item in results {
                            CoreDataManager.shared.saveBook(book: item)
                        }
                    } else {
                        print("SessionViewModel: DB and Local data are in sync")
                    }
                } else {
                    //Save
                    print("SessionViewModel: No Local Books")
                }
            } else {
                if let localBooksArray: [Book] = CoreDataManager.shared.fetchPurchasedBooks() {
                    var results: [String: Any] = [:]
                    var relevantLocalBooks: [Book] = []
                    for book in localBooksArray {
                        if let self,
                           let currentUser = self.currentUser {
                            if (!book.isCloudSynced!) {
                                results["/users/\(currentUser.id!)/purchased_books/\(book.id)"] = [
                                    "bookId": book.id,
                                    "isCloudSynced": true,
                                    "isRented": book.isRented!,
                                    "rentExpirationTimestamp": book.rentExpirationTimestamp ?? 0,
                                    "isExpired": false,
                                    "progress": book.progress!
                                ]
                                
                                var updatedBook = book
                                updatedBook.isCloudSynced = true
                                relevantLocalBooks.append(updatedBook)
                            }
                        }
                    }
                    
                    print("SessionViewModel: Will write \(results.count) out of sync books to db")
                    if let self {
                        await self.batchUpdatePurchasedBooks(children: results)
                        CoreDataManager.shared.batchUpdatePurchasedBooks(books: relevantLocalBooks)
                    }
                }
            }
            if let self {
                Task {
                    await self.checkForExpiredBooks()
                }
            }
        }
    }
    
    private func fetchBookFromDB(bookData: [String: Any]) async -> Book? {
        return await withCheckedContinuation {
            (continuation) in
            FIRDatabaseManager.shared.observeDataAtPathOnce(path: "/books/\(bookData["bookId"]!)") {
                (snapshot) in
                
                if let snapshotData: Any = snapshot.value,
                   let data: Data = try? JSONSerialization.data(withJSONObject: snapshotData),
                   var bookObj: Book = try? JSONDecoder().decode(Book.self, from: data) {
                    bookObj.isCloudSynced = (bookData["isCloudSynced"] as! Bool)
                    bookObj.isRented = (bookData["isRented"] as! Bool)
                    bookObj.progress = (bookData["progress"] as! Int)
                    bookObj.rentExpirationTimestamp = (bookData["rentExpirationTimestamp"] as! Int)
                    
                    continuation.resume(returning: bookObj)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func batchUpdatePurchasedBooks(children: [String: Any]) async {
        return await withCheckedContinuation {
            (continuation) in
            FIRDatabaseManager.shared.batchUpdateChildrens(children: children) {
                continuation.resume()
            }
        }
    }
    
    @objc private func sessionUserUpdated(notification: Notification) {
        let data: [AnyHashable: Any] = notification.userInfo!
        let newUser: User? = data["newUser"] as? User
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                self.currentUser = newUser
                self.retrieveUserPurchasedBookList()
            }
        }
    }
    
    @objc private func sessionUserPurchasedBook(notification: Notification) {
        let bookId: String = notification.userInfo!["bookId"] as! String
        let isRental: Bool = notification.userInfo!["isRental"] as! Bool
        let rentExpirationTimestamp: Int = notification.userInfo!["rentExpirationTimestamp"] as! Int
        handleBookPurchase(bookId: bookId, rentalData: (isRental, rentExpirationTimestamp))
    }
    
    private func checkForExpiredBooks() async {
        return await withCheckedContinuation {
            (continuation) in
            print("SessionViewModel: Checking for expired books")
            if let rentedBooks = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "isRented == YES AND isExpired == NO", args: NSNumber(value: Int64(Date().timeIntervalSince1970))) {
                let currentTimeStamp: Int = Int(Date().timeIntervalSince1970)
                var batchUpdatingChildren: [String: Any] = [:]
                let updatedBooks: [Book] = rentedBooks.filter {
                    return $0.rentExpirationTimestamp! < currentTimeStamp
                }.map {
                    var updatedBook: Book = Book(id: $0.id, name: $0.name)
                    updatedBook.description = $0.description
                    updatedBook.authorId = $0.authorId
                    updatedBook.authorName = $0.authorName
                    updatedBook.progress = $0.progress
                    updatedBook.isCloudSynced = $0.isCloudSynced
                    updatedBook.isRented = $0.isRented
                    updatedBook.priceTier = $0.priceTier
                    updatedBook.rentExpirationTimestamp = $0.rentExpirationTimestamp
                    updatedBook.isExpired = true
                    if let currentUser {
                        batchUpdatingChildren["/users/\(currentUser.id!)/purchased_books/\($0.id)/isExpired"] = true
                    }
                    return updatedBook
                }
                print("SessionViewModel: Deleting \(updatedBooks.count) rented books")
                CoreDataManager.shared.batchUpdatePurchasedBooks(books: updatedBooks)
                if let currentUser {
                    FIRDatabaseManager.shared.batchUpdateChildrens(children: batchUpdatingChildren) {
                        continuation.resume()
                    }
                } else {
                    continuation.resume()
                }
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserUpdatedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification), object: nil)
    }
}
