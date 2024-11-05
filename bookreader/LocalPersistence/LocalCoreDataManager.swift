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
            newBook.author = "New Author"
            newBook.author_id = "sadf234"
            
            do {
                try managedContext.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    public func fetchBooks() {
        let fetchRequest: NSFetchRequest<DBBook> = DBBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", "-O9-mNJpDX9hA96DXCpt")
        
        do {
            if let books = try managedContext?.fetch(fetchRequest) {
                for book in books {
                    print("Book: \(book.id)")
                    print("Book Name: \(book.name)")
                }
            }
        } catch {
            
        }
    }
}
