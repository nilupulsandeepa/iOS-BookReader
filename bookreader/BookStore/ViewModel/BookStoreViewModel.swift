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
    
    public var currentPurchasingBook: Book? = nil
    
    //---- MARK: Initialization
    override init() {
        super.init()
        registerNotifications()
        fetchRecentBookList()
    }
    
    //---- MARK: Action Methods
    
    //---- MARK: Helper Methods
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseSuccess(notification:)), name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseSuccessNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseFailed(notification:)), name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseFailedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkStateChanged(notification:)), name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.networkStateChangedNotification), object: nil)
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
        CoreDataManager.shared.saveBook(book: currentPurchasingBook!)
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification),
            object: nil,
            userInfo: [
                "bookId": currentPurchasingBook!.id
            ]
        )
    }
    
    @objc private func purchaseFailed(notification: Notification) {
        DispatchQueue.main.async {
            [weak self] in
            if let self {
                currentPurchasingBook = nil
            }
        }
    }
    
    @objc private func networkStateChanged(notification: Notification) {
        let networkState: NetworkState = notification.userInfo!["networkState"] as! NetworkState
        print("Network State Changed: \(networkState)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseSuccessNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.purchaseFailedNotification), object: nil)
    }
}
