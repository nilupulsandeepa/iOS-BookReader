//
//  SessionViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-23.
//

import Foundation

public class SessionViewModel: ObservableObject {
    @Published public var currentUser: User? = nil
    
    init() {
        registerNotification()
    }
    
    //---- MARK: Helper Methods
    private func registerNotification() {
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
        let userId: String = currentUser!.id
        let bookInfo: [String: Any] = [
            "book_id": bookId,
            "isExpired": false,
            "rented_timestamp": Int(Date().timeIntervalSince1970)
        ]
        let path: String = "/users/\(userId)/purchased_books/\(bookId)"
        FIRDatabaseManager.shared.setValueAtPath(path: path, value: bookInfo) {
            var updatedBook: Book = Book(id: bookId, name: "")
            updatedBook.isCloudSynced = true
            updatedBook.progress = 0
            LocalCoreDataManager.shared.updatePurchasedBook(book: updatedBook)
            print("Added Purchased Book")
        }
    }
    
    @objc private func sessionUserUpdated(notification: Notification) {
        let data: [AnyHashable: Any] = notification.userInfo!
        var m_NewUser: User? = data["newUser"] as? User
        currentUser = m_NewUser
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
