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
            let newBook: DBBook = DBBook(context: managedContext)
            newBook.id = book.id
            newBook.name = book.name
            newBook.authorName = book.authorName
            newBook.authorId = book.authorId
            newBook.progress = 0
            newBook.isCloudSynced = false
            newBook.isRented = book.isRented!
            
            do {
                try managedContext.save()
            } catch {
                fatalError(error.localizedDescription)
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
