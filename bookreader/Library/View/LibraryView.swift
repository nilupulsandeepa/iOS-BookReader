//
//  LibraryView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct LibraryView: View {
    
    //---- MARK: Properties
    @StateObject private var libraryViewModel: LibraryViewModel = LibraryViewModel()
    @State private var isBookReadingViewPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 20)
                ScrollView {
                    ZStack {
                        VStack {
                            if let currentReadingBook = libraryViewModel.currentReadingBook {
                                HStack {
                                    Text("Continue reading:")
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top], 5)
                                .padding([.leading], 20)
                                LibraryCurrentBookView(
                                    bookName: currentReadingBook.name,
                                    authorName: currentReadingBook.authorName,
                                    bookProgress: currentReadingBook.progress!
                                )
                                    .padding()
                                    .background(Color(uiColor: UIColor(red: 227, green: 255, blue: 234)))
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .padding([.top], 10)
                                    .shadow(color: Color(uiColor: UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.15)), radius: 5)
                                    .padding([.leading, .trailing], 20)
                            }
                            HStack {
                                Text("Books:")
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                    .padding([.leading], 20)
                                Spacer()
                                Menu {
                                    Button(role: .cancel, action: {
                                        print("Purchased Sorting")
                                    }) {
                                        Label("Purchased", systemImage: "dollarsign.circle.fill")
                                    }
                                    Button(role: .cancel, action: {
                                        print("Rented Sorting")
                                    }) {
                                        Label("Rented", systemImage: "dollarsign.circle")
                                    }
                                    Button(role: .cancel, action: {
                                        
                                    }) {
                                        Label("Hidden", systemImage: "eye.slash.circle")
                                    }
                                } label: {
                                    Text("Sort")
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                    Image(systemName: "arrow.up.arrow.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 12)
                                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                }
                                .padding([.trailing], 20)
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top], 15)
                            if libraryViewModel.allUserPurchasedBookList.count > 0 {
                                LazyVGrid(columns: [GridItem(.flexible())]) {
                                    ForEach(libraryViewModel.allUserPurchasedBookList, id:\.self)  { item in
                                        LibraryBookItem(book: item)
                                            .padding()
                                            .background(Color(uiColor: UIColor(red: 230, green: 239, blue: 255)))
                                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                            .padding([.top], 4)
                                            .shadow(color: Color(uiColor: UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.15)), radius: 5)
                                            .padding([.leading, .trailing], 20)
                                            .onTapGesture {
                                                isBookReadingViewPresented = true
                                                CoreDataManager.shared.hardcodedBook(bookId: item.id)
                                            }
                                            .fullScreenCover(isPresented: $isBookReadingViewPresented) {
                                                DocumentView(isPresented: $isBookReadingViewPresented)
                                            }
                                    }
                                }
                                .padding([.bottom], 20)
                            } else {
                                VStack(alignment: .center) {
                                    Image(systemName: "exclamationmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 25)
                                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                    Text("You Don't have any purchased books")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .padding([.bottom, .top], 5)
                                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                }
                                .frame(maxHeight: .infinity)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    private func getAllPurchasedBooks() -> [Book] {
        return libraryViewModel.userPurchasedBookList + libraryViewModel.userRentedBookList
    }
}

#Preview {
    LibraryView()
}
