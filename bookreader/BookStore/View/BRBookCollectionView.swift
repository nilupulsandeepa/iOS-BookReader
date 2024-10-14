//
//  BRBookCollectionView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookCollectionView: View {
    let items = Array(1...15)
        let rows = [
            GridItem(.fixed(200))
        ]
    
    @State private var g_BooksCollection: BRBooksCollecttionViewModel
    
    init(booksCollectionModel: BRBooksCollecttionViewModel) {
        g_BooksCollection = booksCollectionModel
    }
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(items, id: \.self) { item in
                    VStack {
                        BRBookThumbnailView(thumbnailImageName: "book_2")
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
    let booksCollection = BRBooksCollecttionViewModel()
    return BRBookCollectionView(booksCollectionModel: booksCollection)
}
