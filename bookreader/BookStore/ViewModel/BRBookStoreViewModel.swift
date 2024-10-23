//
//  BRBookStoreViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-14.
//

import Foundation
import StoreKit

public class BRBookStoreViewModel: NSObject, ObservableObject {
    //---- MARK: Properties
    @Published public var recentBooks: [BRBook] = []
    @Published public var selectedBook: BRBook? = nil
    
    public var currentPurchasingBook: BRBook? = nil
    
    override init() {
        super.init()
        registerNotification()
        fetchRecentBookList()
    }
    
    //---- MARK: Action Methods
    
    //---- MARK: Helper Methods
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseSuccess(notification:)), name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.purchaseSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseFailed(notification:)), name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.purchaseFailedNotification), object: nil)
    }
    
    private func fetchRecentBookList() {
        BRFIRDatabaseManager.shared.observeDataAtPathOnce(path: BRNameSpaces.FirebasePaths.recentBooks) {
            [weak self]
            snapshot in
            let m_BooksObject: [String: Any] = snapshot.value as! [String: Any]
            let m_RecentBooks: [BRBook] = m_BooksObject.values.map({
                let m_BookData: Data = try! JSONSerialization.data(withJSONObject: $0)
                return try! JSONDecoder().decode(BRBook.self, from: m_BookData)
            })
            if (self != nil) {
                self!.recentBooks = m_RecentBooks
            }
        }
    }
    
    @objc private func purchaseSuccess(notification: Notification) {
        let m_UserInfo = notification.userInfo
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.sessionUserPurchasedBook),
            object: nil,
            userInfo: [
                "bookId": currentPurchasingBook!.id
            ]
        )
    }
    
    @objc private func purchaseFailed(notification: Notification) {
        let m_UserInfo = notification.userInfo
        currentPurchasingBook = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.purchaseSuccessNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BRNameSpaces.NotificationIdentifiers.purchaseFailedNotification), object: nil)
    }
}
