//
//  LocalCoreDataManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-05.
//

import Foundation
import CoreData

public class LocalCoreDataManager {
    
    //---- MARK: Properties
    public static let shared: LocalCoreDataManager = LocalCoreDataManager()
    
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
            
            do {
                try managedContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func fetchPurchasedBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                return books.map {
                    var convertedBook = Book(id: $0.id!, name: $0.name!)
                    convertedBook.authorId = $0.authorId
                    convertedBook.authorName = $0.authorName
                    convertedBook.isCloudSynced = $0.isCloudSynced
                    convertedBook.progress = Int($0.progress)
                    return convertedBook
                }
            }
        } catch {
            
        }
        return []
    }
    
    public func updatePurchasedBook(book: Book) {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", book.id)
        
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                books[0].isCloudSynced = book.isCloudSynced!
                books[0].progress = Int16(book.progress!)
                
                try managedContext?.save()
            }
        } catch {
            
        }
    }
}
