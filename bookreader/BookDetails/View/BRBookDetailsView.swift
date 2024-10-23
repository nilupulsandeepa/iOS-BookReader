//
//  BRBookDetailsView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-16.
//

import SwiftUI

struct BRBookDetailsView: View {
    
    @ObservedObject var bookStoreViewMode: BRBookStoreViewModel
    @StateObject var g_BookDetailsViewModel: BRBookDetailsViewModel = BRBookDetailsViewModel()
    
    @State private var isPressed = false
    @State private var is7DaysRentPressed = false
    @State private var is14DaysRentPressed = false
    
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
                    
                    Text(g_BookDetailsViewModel.bookDetails?.name ?? "")
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
                    
                    Text(g_BookDetailsViewModel.bookDetails?.authorName ?? "")
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
                    
                Text(g_BookDetailsViewModel.bookDetails?.description ?? "")
                    .font(.subheadline)
                    .padding([.bottom], 5)
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                    .padding([.leading, .trailing], 20)
                
                HStack {
                    Spacer()
                    
                    Text("USD 4.99")
                        .font(.callout)
                        .fontWeight(.bold)
                        .padding([.top, .bottom], 5)
                        .foregroundStyle(Color.white)//(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.top, .bottom], 15)
                .background(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.leading, .trailing], 20)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
                .onTapGesture {
                    withAnimation {
                        isPressed = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        isPressed = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
                            bookStoreViewMode.currentPurchasingBook = bookStoreViewMode.selectedBook
                            Task {
                                await BRInAppManager.shared.purchase(productId: BRNameSpaces.InAppConsumableProducts.inAppConsumableTier2)
                            }
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
                    .animation(.easeInOut(duration: 0.15), value: is7DaysRentPressed)
                    .onTapGesture {
                        withAnimation {
                            is7DaysRentPressed = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            is7DaysRentPressed = false
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
                    .animation(.easeInOut(duration: 0.15), value: is14DaysRentPressed)
                    .onTapGesture {
                        withAnimation {
                            is14DaysRentPressed = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            is14DaysRentPressed = false
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
        }
        .onAppear {
            if let m_BookId = bookStoreViewMode.selectedBook?.id {
                g_BookDetailsViewModel.loadBookDetails(bookId: m_BookId)
            }
        }
        .onDisappear(perform: {
            bookStoreViewMode.selectedBook = nil
            bookStoreViewMode.currentPurchasingBook = nil
        })
        .navigationTitle("Book Details")
    }
}

