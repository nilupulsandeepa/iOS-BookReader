//
//  LocalCoreDataManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-05.
//

import Foundation
import CoreData

public class CoreDataManager {
    
    //---- MARK: Properties
    public static let shared: CoreDataManager = CoreDataManager()
    
    private var managedContext: NSManagedObjectContext? = nil
    
    //---- MARK: Initializer
    
    //---- MARK: Action Methods
    public func initializeCoreData(context: NSManagedObjectContext) {
        managedContext = context
    }
    
    public func saveBook(book: Book) {
        if let managedContext {
            if let books: [Book] = fetchPurchasedBooksByQuery(query: "id == %@", args: book.id), books.count > 0 {
                var newBook = book
                newBook.isCloudSynced = false
                newBook.progress = books[0].progress ?? 0
                batchUpdatePurchasedBooks(books: [newBook])
            } else {
                let newBook: DBBook = DBBook(context: managedContext)
                newBook.id = book.id
                newBook.name = book.name
                newBook.authorName = book.authorName
                newBook.authorId = book.authorId
                newBook.progress = 0
                newBook.isCloudSynced = false
                newBook.isRented = book.isRented!
                newBook.priceTier = book.priceTier
                newBook.rentExpirationTimestamp = Int64(book.rentExpirationTimestamp ?? 0)
                newBook.isExpired = book.isExpired ?? false
                
                do {
                    try managedContext.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    public func fetchPurchasedBooks() -> [Book]? {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        
        do {
            if let books: [DBBook] = try managedContext?.fetch(fetchRequest) {
                return books.map {
                    var convertedBook: Book = Book(id: $0.id!, name: $0.name!)
                    convertedBook.authorId = $0.authorId
                    convertedBook.authorName = $0.authorName
                    convertedBook.isCloudSynced = $0.isCloudSynced
                    convertedBook.progress = Int($0.progress)
                    convertedBook.isRented = $0.isRented
                    convertedBook.priceTier = $0.priceTier
                    convertedBook.rentExpirationTimestamp = Int($0.rentExpirationTimestamp)
                    convertedBook.isExpired = $0.isExpired
                    return convertedBook
                }
            }
        } catch { }
        return nil
    }
    
    public func fetchPurchasedBooksByQuery(query: String, args: any CVarArg...) -> [Book]? {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: query, args)
        
        do {
            if let books: [DBBook] = try managedContext?.fetch(fetchRequest) {
                return books.map {
                    var convertedBook = Book(id: $0.id!, name: $0.name!)
                    convertedBook.authorId = $0.authorId
                    convertedBook.authorName = $0.authorName
                    convertedBook.isCloudSynced = $0.isCloudSynced
                    convertedBook.progress = Int($0.progress)
                    convertedBook.isRented = $0.isRented
                    convertedBook.priceTier = $0.priceTier
                    convertedBook.rentExpirationTimestamp = Int($0.rentExpirationTimestamp)
                    convertedBook.isExpired = $0.isExpired
                    return convertedBook
                }
            }
        } catch { }
        return nil
    }
    
    public func updatePurchasedBook(book: Book) {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", book.id)
        
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                books[0].isCloudSynced = book.isCloudSynced!
                
                try managedContext?.save()
            }
        } catch {
            
        }
    }
    
    public func batchUpdatePurchasedBooks(books: [Book]) {
        let fetchRequest: NSFetchRequest = DBBook.fetchRequest()
        
        let bookIds: [String] = books.map {
            $0.id
        }
        let bookIdDictionary: [String: Book] = Dictionary(uniqueKeysWithValues: books.map { ($0.id, $0) })
        fetchRequest.predicate = NSPredicate(format: "id IN %@", bookIds)
        
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                for book in books {
                    book.isCloudSynced = bookIdDictionary[book.id!]!.isCloudSynced!
                    book.id = bookIdDictionary[book.id!]!.id
                    book.name = bookIdDictionary[book.id!]!.name
                    book.authorName = bookIdDictionary[book.id!]!.authorName
                    book.authorId = bookIdDictionary[book.id!]!.authorId
                    book.progress = Int16(bookIdDictionary[book.id!]!.progress!)
                    book.isRented = bookIdDictionary[book.id!]!.isRented!
                    book.priceTier = bookIdDictionary[book.id!]!.priceTier
                    book.rentExpirationTimestamp = Int64(bookIdDictionary[book.id!]!.rentExpirationTimestamp ?? 0)
                    book.isExpired = bookIdDictionary[book.id!]!.isExpired!
                }
            }
            try managedContext?.save()
        } catch { }
    }
    
    public func cacheBook(book: Book) {
        if let managedContext {
            let dbCacheBook: DBCacheBook = DBCacheBook(context: managedContext)
            dbCacheBook.id = book.id
            dbCacheBook.name = book.name
            dbCacheBook.descriptionString = book.description
            dbCacheBook.authorId = book.authorId
            dbCacheBook.authorName = book.authorName
            dbCacheBook.priceTier = book.priceTier
            
            do {
                try managedContext.save()
            } catch { }
        }
    }
    
    public func fetchCachedBookByQuery(query: String, args: any CVarArg...) -> Book? {
        let fetchRequest: NSFetchRequest<DBCacheBook> = DBCacheBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: query, args)
        
        do {
            if let books: [DBCacheBook] = try managedContext?.fetch(fetchRequest) {
                if (!books.isEmpty) {
                    var convertedBook: Book = Book(id: books[0].id!, name: books[0].name!)
                    convertedBook.authorId = books[0].authorId!
                    convertedBook.authorName = books[0].authorName!
                    convertedBook.description = books[0].descriptionString!
                    convertedBook.priceTier = books[0].priceTier!
                    return convertedBook
                }
            }
        } catch { }
        return nil
    }
    
    public func hardcodedBook(bookId: String) {
        UserDefaultManager.shared.currentReadingBookId = bookId
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", bookId)
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                books[0].isRented = false
                books[0].progress = Int16(Int.random(in: 0...100))
                
                try managedContext?.save()
            }
        } catch { }
    }
}
