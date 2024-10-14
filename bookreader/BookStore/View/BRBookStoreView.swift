//
//  BRBookStore.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookStoreView: View {
    
    @State private var text: String = ""
    @State private var bookCollection = BRBooksCollecttionViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Explore")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.bottom], 5)
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Spacer()
                BRProfilePictureView()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .leading, .trailing], 20)
            ScrollView {
                HStack {
                    TextField("Search...", text: $text)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding([.leading, .trailing], 20)
                .padding([.top], 10)
                HStack {
                    Text("New Araivals")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                .padding([.top], 15)
                HStack {
                    BRBookCollectionView(booksCollectionModel: bookCollection)
                }
                .padding([.top], -15)
                HStack {
                    Text("Featured")
                        .font(.title)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                    Spacer()
                }
                .padding([.leading, .trailing], 20)
                HStack {
                    BRFeaturedBookView()
                }
                .padding([.top], -15)
                
            }
        }
    }
}

#Preview {
    BRBookStoreView()
}
