//
//  BookDetailsView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-16.
//

import SwiftUI

struct BookDetailsView: View {
    
    @ObservedObject var bookStoreViewModel: BookStoreViewModel
    @StateObject var bookDetailsViewModel: BookDetailsViewModel = BookDetailsViewModel()
    
    @State private var isPressed = false
    @State private var is7DaysRentPressed = false
    @State private var is14DaysRentPressed = false
    @State private var isReadNowPressed = false
    @State private var isBookReadingViewPresented: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    Spacer()
                    
                    Image("book_3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 20)
                
                HStack {
                    Spacer()
                    
                    Text(bookDetailsViewModel.bookDetails?.name ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .leading, .trailing], 20)
                
                HStack {
                    Spacer()
                    
                    Text(bookDetailsViewModel.bookDetails?.authorName ?? "")
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 20)
                
                if bookDetailsViewModel.bookDetails != nil {
                    Text(bookDetailsViewModel.bookDetails?.description ?? "")
                        .font(.subheadline)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .padding([.leading, .trailing], 20)
                    
                    if (bookDetailsViewModel.isCurrentSelectedBookAlreadyPurchased) {
                        HStack {
                            Spacer()
                            
                            Text("Read Now")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding([.top, .bottom], 5)
                                .foregroundStyle(Color.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 15)
                        .background(Color(uiColor: UIColor(red: 236, green: 195, blue: 11)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .trailing], 20)
                        .scaleEffect(isReadNowPressed ? 0.95 : 1.0)
                        .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: isReadNowPressed)
                        .onTapGesture {
                            withAnimation {
                                isReadNowPressed = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                isReadNowPressed = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                                    isBookReadingViewPresented = true
                                })
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            
                            if (!isPressed) {
                                Text("\(InAppManager.shared.getProductPrice(inAppProduct: bookDetailsViewModel.bookDetails!.priceTier))")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 5)
                                    .foregroundStyle(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            } else {
                                ProgressView()
                                    .scaleEffect(1)
                                    .frame(width: 50)
                                    .tint(Color.white)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 15)
                        .background(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding([.leading, .trailing], 20)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: isPressed)
                        .onTapGesture {
                            withAnimation {
                                isPressed = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isPressed = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                                    bookStoreViewModel.currentPurchasingBook = bookStoreViewModel.selectedBook
                                    bookStoreViewModel.currentPurchasingBook!.authorId = bookDetailsViewModel.bookDetails?.authorId
                                    bookStoreViewModel.currentPurchasingBook!.authorName = bookDetailsViewModel.bookDetails?.authorName
                                    bookStoreViewModel.currentPurchasingBook!.progress = 0
                                    bookStoreViewModel.currentPurchasingBook!.isCloudSynced = false
                                    bookStoreViewModel.currentPurchasingBook!.isRented = false
                                    
                                    InAppManager.shared.purchase(productId: InAppManager.shared.inAppProductsDictionary[bookDetailsViewModel.bookDetails!.priceTier]!)
                                })
                            }
                        }
                        
                        HStack {
                            Text("Rent this book:")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding([.top, .bottom], 5)
                                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], 20)
                        
                        HStack(spacing: 0) {
                            HStack {
                                Spacer()
                                
                                Text("7 Days: USD 1.99")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 5)
                                    .foregroundStyle(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .bottom], 15)
                            .background(Color(uiColor: UIColor(red: 4, green: 142, blue: 87)))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.leading], 20)
                            .padding([.trailing], 10)
                            .scaleEffect(is7DaysRentPressed ? 0.95 : 1.0)
                            .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: is7DaysRentPressed)
                            .onTapGesture {
                                withAnimation {
                                    is7DaysRentPressed = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    is7DaysRentPressed = false
                                    if let books: [Book] = CoreDataManager.shared.fetchPurchasedBooks() {
                                        for book in books {
                                            print(book)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Spacer()
                                
                                Text("14 Days: USD 3.29")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 5)
                                    .foregroundStyle(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                            }
                            .padding([.top, .bottom], 15)
                            .background(Color(uiColor: UIColor(red: 4, green: 142, blue: 87)))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.leading], 10)
                            .padding([.trailing], 20)
                            .scaleEffect(is14DaysRentPressed ? 0.95 : 1.0)
                            .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: is14DaysRentPressed)
                            .onTapGesture {
                                withAnimation {
                                    is14DaysRentPressed = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    is14DaysRentPressed = false
                                    FIRStorageManager.shared.getFile()
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                    }
                } else {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(width: 50)
                        .tint(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                }
            }
        }
        .onAppear {
            if let bookId = bookStoreViewModel.selectedBook?.id {
                bookDetailsViewModel.checkIfBookAlreadyPurchased(bookId: bookId)
                bookDetailsViewModel.loadBookDetails(bookId: bookId)
            }
        }
        .navigationTitle("Book Details")
        .fullScreenCover(isPresented: $isBookReadingViewPresented) {
            DocumentView(isPresented: $isBookReadingViewPresented)
        }
    }
}

