//
//  BRBookCollectionView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookCollectionView: View {
    let rows = [
        GridItem(.fixed(200))
    ]
    
    private var g_BooksCollection: [BRBook]
    
    init(bookCollection: [BRBook]) {
        g_BooksCollection = bookCollection
    }
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(g_BooksCollection, id: \.self) { item in
                    VStack {
                        BRBookThumbnailView(thumbnailImageName: "book_1", bookName: item.name)
                            .cornerRadius(10)
                            .shadow(color: Color(uiColor: UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.15)), radius: 5)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    let booksCollection = BRBookStoreViewModel()
    let books: [BRBook] = [
        BRBook(g_ID: "A", g_Name: "Test Book 1"),
        BRBook(g_ID: "B", g_Name: "Test Book 2"),
        BRBook(g_ID: "C", g_Name: "Test Book 3"),
        BRBook(g_ID: "D", g_Name: "Test Book 4"),
    ]
    booksCollection.recentBooks = books
    return BRBookCollectionView(bookCollection: booksCollection.recentBooks)
}
