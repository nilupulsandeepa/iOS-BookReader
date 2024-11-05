//
//  BookCollectionView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BookCollectionView: View {
    let rows = [
        GridItem(.fixed(200))
    ]
    
    @ObservedObject var storeViewModel: BookStoreViewModel
    @Binding var isPresented: Bool
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(storeViewModel.recentBooks) { book in
                    VStack {
                        ZStack {
                            BookThumbnailView(imageName: "book_3", book: book, storeVM: storeViewModel, isPresented: $isPresented)
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
