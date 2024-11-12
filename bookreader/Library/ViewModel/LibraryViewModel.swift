//
//  LibraryViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-06.
//

import Foundation
import CoreData

public class LibraryViewModel: ObservableObject {
    
    //---- MARK: Properties
    @Published public var currentReadingBook: Book? = nil
    @Published public var allUserPurchasedBookList: [Book] = []
    @Published public var userPurchasedBookList: [Book] = []
    @Published public var userRentedBookList: [Book] = []
    
    //---- MARK: Initialization
    init() {
        registerNotifications()
        checkForCurrentReadingBook()
        retrieveBookList()
    }
    
    //---- MARK: Action Methods
    
    //---- MARK: Helper Methods
    private func checkForCurrentReadingBook() {
        if let currentReadingBookId: String = UserDefaultManager.shared.currentReadingBookId {
            if let books: [Book] = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "id = %@", args: currentReadingBookId) {
                DispatchQueue.main.async {
                    [weak self] in
                    if let self {
                        self.currentReadingBook = books[0]
                    }
                }
            }
        }
    }
    
    private func retrieveBookList() {
        if let books: [Book] = CoreDataManager.shared.fetchPurchasedBooks() {
            for book in books {
                if let isRented = book.isRented {
                    DispatchQueue.main.async {
                        [weak self] in
                        if let self {
                            isRented ? userRentedBookList.append(book) : userPurchasedBookList.append(book)
                            allUserPurchasedBookList.append(book)
                        }
                    }
                }
            }
        }
    }
    
    private func handleBookPurchase(bookId: String) {
        if let books: [Book] = CoreDataManager.shared.fetchPurchasedBooksByQuery(query: "id = %@", args: bookId) {
            if let isRented = books[0].isRented {
                DispatchQueue.main.async {
                    [weak self] in
                    if let self {
                        isRented ? userRentedBookList.append(books[0]) : userPurchasedBookList.append(books[0])
                        allUserPurchasedBookList.append(books[0])
                    }
                }
            }
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sessionUserPurchasedBook(notification:)),
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification),
            object: nil
        )
    }
    
    @objc private func sessionUserPurchasedBook(notification: Notification) {
        let m_BookId: String = notification.userInfo!["bookId"] as! String
        handleBookPurchase(bookId: m_BookId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserPurchasedBookNotification), object: nil)
    }
}
