//
//  BookStore.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BookStoreView: View {
    
    @State private var text: String = ""
    @StateObject var booksStoreVM = BookStoreViewModel()
    @State var isBookPresented: Bool = false
    
    var body: some View {
        NavigationStack(root: {
            VStack {
                HStack(alignment: .top) {
                    Text("Explore")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                    Spacer()
                    ProfilePictureView()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 20)
                ScrollView {
                    HStack {
                        TextField("Search...", text: $text)
                            .padding([.leading, .trailing], 8)
                            .frame(height: 38)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        ZStack {
                            Color(.systemGray6)
                                .frame(width: 38, height: 38)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                        }
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
                    ZStack {
                        if (booksStoreVM.recentBooks.count > 0) {
                            BookCollectionView(storeViewModel: booksStoreVM, isPresented: $isBookPresented)
                        } else {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                                .frame(height: 268)
                        }
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
                        FeaturedBookView()
                            .frame(maxWidth: .infinity)
                            .background(Color(uiColor: UIColor(red: 222, green: 245, blue: 227)))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    }
                    .padding([.top], -15)
                    .padding([.leading, .trailing], 20)
                }
                
                .scrollIndicators(.hidden)
            }
            .navigationDestination(isPresented: $isBookPresented, destination: {
                if booksStoreVM.selectedBook != nil {
                    BookDetailsView(bookStoreViewModel: booksStoreVM)
                }
            })
        })
    }
}

#Preview {
    BookStoreView()
}
