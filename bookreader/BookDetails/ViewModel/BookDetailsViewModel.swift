//
//  BookDetailsViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-17.
//

import Foundation
import CoreData

public class BookDetailsViewModel: ObservableObject {
    //---- MARK: Properties
    @Published var bookDetails: BookDetails? = nil
    @Published var isCurrentSelectedBookAlreadyPurchased: Bool = false
    
    //---- MARK: Initialization
    init() {
        registerNotifications()
    }
    
    //---- MARK: Action Methods
    public func checkIfBookAlreadyPurchased(bookId: String) {
        if let selectedBooks: [Book] = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "id = %@", args: bookId) {
            DispatchQueue.main.async {
                [weak self] in
                if let self {
                    self.isCurrentSelectedBookAlreadyPurchased = selectedBooks.filter {
                        $0.id == bookId
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
    
    public func loadBookDetails(bookId: String) {
        FIRDatabaseManager.shared.observeDataAtPathOnce(path: "\(NameSpaces.FirebasePaths.books)/\(bookId)") {
            [weak self] (snapshot) in
            let bookDetailsObj: BookDetails = try! JSONDecoder().decode(BookDetails.self, from: JSONSerialization.data(withJSONObject: snapshot.value!))
            if let self {
                DispatchQueue.main.async {
                    self.bookDetails = bookDetailsObj
                }
            }
        }
    }
    
    //---- MARK: Helper Methods
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localDataDidSave(notification:)),
            name: .NSManagedObjectContextDidSave,
            object: nil
        )
    }
    
    @objc private func localDataDidSave(notification: Notification) {
        if (notification.userInfo?[NSInsertedObjectsKey]) != nil {
            if let bookDetails {
                checkIfBookAlreadyPurchased(bookId: bookDetails.id)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextDidSave, object: nil)
    }
}
