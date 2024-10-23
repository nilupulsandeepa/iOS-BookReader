//
//  BRSessionViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-23.
//

import Foundation

public class BRSessionViewModel: ObservableObject {
    @Published public var currentUser: BRUser? = nil
    
    init() {
        registerNotification()
    }
    
    //---- MARK: Helper Methods
    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserUpdated(notification:)),
            name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.sessionUserUpdated),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserPurchasedBook(notification:)),
            name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.sessionUserPurchasedBook),
            object: nil
        )
    }
    
    private func handleBookPurchase(bookId: String) {
        let m_UserId: String = currentUser!.id
        let m_BookInfo: [String: Any] = [
            "book_id": bookId,
            "isExpired": false,
            "rented_timestamp": Int(Date().timeIntervalSince1970)
        ]
        let m_Path: String = "/users/\(m_UserId)/purchased_books/\(bookId)"
        BRFIRDatabaseManager.shared.setValueAtPath(path: m_Path, value: m_BookInfo, completion: {
            print("Added Purchased Book")
        })
    }
    
    @objc private func sessionUserUpdated(notification: Notification) {
        let m_Data: [AnyHashable: Any] = notification.userInfo!
        var m_NewUser: BRUser? = m_Data["newUser"] as? BRUser
        currentUser = m_NewUser
    }
    
    @objc private func sessionUserPurchasedBook(notification: Notification) {
        let m_BookId: String = notification.userInfo!["bookId"] as! String
        handleBookPurchase(bookId: m_BookId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.sessionUserUpdated), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.sessionUserPurchasedBook), object: nil)
    }
}
