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
    
    override init() {
        super.init()
        fetchRecentBookList()
    }
    
    //---- MARK: Action Methods
    
    //---- MARK: Helper Methods
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
}
