//
//  BRBookDetailsView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-16.
//

import SwiftUI

struct BRBookDetailsView: View {
    
    @StateObject var bookDetailsVM: BRBookDetailsViewModel = BRBookDetailsViewModel()
    var selectedBook: BRBook?
    
    init(book: BRBook?) {
        selectedBook = book
        if let m_Book = book {
            bookDetailsVM.loadBookDetails(bookId: m_Book.id)
        }
    }
    
    var body: some View {
        VStack {
            Text(bookDetailsVM.bookDetails?.name ?? "")
            Text(bookDetailsVM.bookDetails?.description ?? "")
        }
        .navigationTitle("Book Details")
    }
}
//
//#Preview {
//
//    BRBookDetailsView()
//}
