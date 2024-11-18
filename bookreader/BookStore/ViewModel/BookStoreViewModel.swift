//
//  BookStoreViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-14.
//

import Foundation
import StoreKit

public class BookStoreViewModel: NSObject, ObservableObject {
    //---- MARK: Properties
    @Published public var recentBooks: [Book] = []
    @Published public var selectedBook: Book? = nil
    @Published public var isAdditionalDetailsLoaded: Bool = false
    @Published var isCurrentSelectedBookAlreadyPurchased: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isRent7Purchasing: Bool = false
    @Published var isRent14Purchasing: Bool = false
    
    //---- MARK: Initialization
    override init() {
        super.init()
        registerNotifications()
        fetchRecentBookList()
    }
    
    //---- MARK: Action Methods
    public func fetchAdditionalBookDetails() {
        isAdditionalDetailsLoaded = false
        if let cachedBook: Book = CoreDataManager.shared.fetchCachedBookByQuery(query: "id = %@", args: selectedBook!.id) {
            DispatchQueue.main.async {
                [weak self] in
                if let self {
                    self.selectedBook = cachedBook
                    self.isAdditionalDetailsLoaded = true
                }
            }
            return
        }
        Utils.delayExecution(seconds: 1.0) {
            [weak self] in
            guard let self else {
                return
            }
            FIRDatabaseManager.shared.observeDataAtPathOnce(path: "\(NameSpaces.FirebasePaths.books)/\(self.selectedBook!.id)") {
                [weak self] (snapshot) in
                let bookDetailsObj: Book = try! JSONDecoder().decode(Book.self, from: JSONSerialization.data(withJSONObject: snapshot.value!))
                if let self {
                    var updatedBook: Book = Book(id: selectedBook!.id, name: selectedBook!.name)
                    updatedBook.authorId = bookDetailsObj.authorId
                    updatedBook.authorName = bookDetailsObj.authorName
                    updatedBook.priceTier = bookDetailsObj.priceTier
                    updatedBook.description = bookDetailsObj.description
                    CoreDataManager.shared.cacheBook(book: updatedBook)
                    DispatchQueue.main.async {
                        self.selectedBook = updatedBook
                        self.isAdditionalDetailsLoaded = true
                    }
                }
            }
        }
    }
    
    public func checkIfBookAlreadyPurchased() {
        if let selectedBooks: [Book] = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "id = %@", args: selectedBook!.id) {
            DispatchQueue.main.async {
                [weak self] in
                if let self {
                    self.isCurrentSelectedBookAlreadyPurchased = selectedBooks.filter {
                        $0.id == self.selectedBook!.id
                    }.count > 0
                }
            }
            return
        }
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                isCurrentSelectedBookAlreadyPurchased = false
            }
        }
    }
    
    public func purchaseCurrentSelectedBook() {
        isPurchasing = true
        selectedBook!.isRented = false
        InAppManager.shared.purchase(productId: InAppManager.shared.inAppProductsDictionary[selectedBook!.priceTier!]!)
    }
    
    public func rentCurrentSelectedBook(rentalOption: RentalOptions) {
        isRent7Purchasing = rentalOption == .Days7
        isRent14Purchasing = rentalOption == .Days14
        selectedBook!.isRented = true
        InAppManager.shared.purchase(productId: InAppManager.shared.inAppProductsDictionary[rentalOption.rawValue]!)
    }
    
    //---- MARK: Helper Methods
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(purchaseSuccess(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseSuccessNotification),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(purchaseFailed(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseFailedNotification),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStateChanged(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.networkStateChangedNotification),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localDataDidSave(notification:)),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
    }
    
    private func fetchRecentBookList() {
        FIRDatabaseManager.shared.observeDataAtPathOnce(path: NameSpaces.FirebasePaths.recentBooks) {
            snapshot in
            let booksObject: [String: Any] = snapshot.value as! [String: Any]
            let recentBooks: [Book] = booksObject.values.map({
                let bookData: Data = try! JSONSerialization.data(withJSONObject: $0)
                return try! JSONDecoder().decode(Book.self, from: bookData)
            })
            DispatchQueue.main.async {
                [weak self] in
                if let self {
                    self.recentBooks = recentBooks
                }
            }
        }
    }
    
    @objc private func purchaseSuccess(notification: Notification) {
        CoreDataManager.shared.saveBook(book: selectedBook!)
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification),
            object: nil,
            userInfo: [
                "bookId": selectedBook!.id,
                "isRental": isRent7Purchasing || isRent14Purchasing
            ]
        )
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                self.isPurchasing = false
                self.isRent7Purchasing = false
                self.isRent14Purchasing = false
            }
        }
    }
    
    @objc private func purchaseFailed(notification: Notification) {
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                self.isPurchasing = false
                self.isRent7Purchasing = false
                self.isRent14Purchasing = false
                self.selectedBook!.isRented = nil
            }
        }
    }
    
    @objc private func localDataDidSave(notification: Notification) {
        if selectedBook?.authorName != nil {
            checkIfBookAlreadyPurchased()
        }
    }
    
    @objc private func networkStateChanged(notification: Notification) {
        let networkState: NetworkState = notification.userInfo!["networkState"] as! NetworkState
        print("Network State Changed: \(networkState)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseSuccessNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseFailedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextDidSave, object: nil)
    }
}
