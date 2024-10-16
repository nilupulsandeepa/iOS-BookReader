//
//  BRBookDetailsView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-16.
//

import SwiftUI

struct BRBookDetailsView: View {
    
    var selectedBook: BRBook?
    
    init(book: BRBook?) {
        selectedBook = book
    }
    
    var body: some View {
        Text("Hello, World! \(selectedBook?.name ?? "No Book")")
            .navigationTitle("BOOK")
    }
}
//
//#Preview {
//
//    BRBookDetailsView()
//}
