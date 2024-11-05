//
//  BookDetailsViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-17.
//

import Foundation

public class BookDetailsViewModel: ObservableObject {
    //---- MARK: Properties
    @Published var bookDetails: BookDetails? = nil
    
    //---- MARK: Action Methods
    public func loadBookDetails(bookId: String) {
        FIRDatabaseManager.shared.observeDataAtPathOnce(path: "\(NameSpaces.FirebasePaths.books)/\(bookId)", completion: {
            [weak self] (snapshot) in
            let bookDetailsObj: BookDetails = try! JSONDecoder().decode(BookDetails.self, from: JSONSerialization.data(withJSONObject: snapshot.value!))
            if let self {
                self.bookDetails = bookDetailsObj
            }
        })
    }
}
