//
//  BRBookDetailsViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-17.
//

import Foundation

public class BRBookDetailsViewModel: ObservableObject {
    @Published var bookDetails: BRBookDetails? = nil
    
    public func loadBookDetails(bookId: String) {
        BRFIRDatabaseManager.shared.observeDataAtPathOnce(path: "\(BRNameSpaces.FirebasePaths.books)/\(bookId)", completion: {
            [weak self] (snapshot) in
            let bookDetailsObj: BRBookDetails = try! JSONDecoder().decode(BRBookDetails.self, from: JSONSerialization.data(withJSONObject: snapshot.value!))
            if (self != nil) {
                self!.bookDetails = bookDetailsObj
            }
        })
    }
}
