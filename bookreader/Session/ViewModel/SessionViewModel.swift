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
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserUpdated),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserPurchasedBook(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBook),
            object: nil
        )
    }
    
    private func handleBookPurchase(bookId: String) {
        if let userId = currentUser?.id {
            let bookInfo: [String: Any] = [
                "book_id": bookId,
                "isExpired": false,
                "rented_timestamp": Int(Date().timeIntervalSince1970)
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
    
    @objc private func sessionUserUpdated(notification: Notification) {
        let data: [AnyHashable: Any] = notification.userInfo!
        let newUser: User? = data["newUser"] as? User
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                currentUser = newUser
            }
        }
    }
    
    @objc private func sessionUserPurchasedBook(notification: Notification) {
        let m_BookId: String = notification.userInfo!["bookId"] as! String
        handleBookPurchase(bookId: m_BookId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserUpdated), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBook), object: nil)
    }
}
