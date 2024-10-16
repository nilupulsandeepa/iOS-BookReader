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
    
    @ObservedObject var storeViewModel: BRBookStoreViewModel
    @Binding var isPresented: Bool
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(storeViewModel.recentBooks) { book in
                    VStack {
                        ZStack {
                            BRBookThumbnailView(g_ImageName: "book_1", book: book, storeVM: storeViewModel, isPresented: $isPresented)
                                .cornerRadius(10)
                                .shadow(color: Color(uiColor: UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.15)), radius: 5)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    let booksCollection = BRBookStoreViewModel()
//    let books: [BRBook] = [
//        BRBook(id: "A", name: "Test Book 1"),
//        BRBook(id: "B", name: "Test Book 2"),
//        BRBook(id: "C", name: "Test Book 3"),
//        BRBook(id: "D", name: "Test Book 4"),
//    ]
//    booksCollection.recentBooks = books
//    return BRBookCollectionView(storeViewModel: booksCollection)
//}
