//
//  BookDetailsView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-16.
//

import SwiftUI

struct BookDetailsView: View {
    
    @ObservedObject var bookStoreViewModel: BookStoreViewModel
    
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
                    
                    Text(bookStoreViewModel.selectedBook!.name)
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
                    
                    Text(bookStoreViewModel.selectedBook!.authorName ?? "")
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
                
                if bookStoreViewModel.isAdditionalDetailsLoaded {
                    Text(bookStoreViewModel.selectedBook!.description ?? "")
                        .font(.subheadline)
                        .padding([.bottom], 5)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .padding([.leading, .trailing], 20)
                    
                    if (bookStoreViewModel.isCurrentSelectedBookAlreadyPurchased) {
                        HStack {
                            Spacer()
                            
                            Text("Read Now")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
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
                            
                            if (!bookStoreViewModel.isPurchasing) {
                                Text("\(InAppManager.shared.getProductPrice(inAppProduct: bookStoreViewModel.selectedBook!.priceTier ?? ""))")
                                    .font(.callout)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            } else {
                                ProgressView()
                                    .scaleEffect(1)
                                    .tint(Color.white)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
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
                            bookStoreViewModel.isPurchasing = true
                            
                            Utils.delayExecution(seconds: 0.15) {
                                isPressed = false
                                Utils.delayExecution(seconds: 0.5) {
                                    bookStoreViewModel.purchaseCurrentSelectedBook()
                                }
                            }
                        }
                        .disabled(bookStoreViewModel.isPurchasing || bookStoreViewModel.isRent7Purchasing || bookStoreViewModel.isRent14Purchasing)
                        
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
                                
                                if (!bookStoreViewModel.isRent7Purchasing) {
                                    Text("7 Days: \(InAppManager.shared.getProductPrice(inAppProduct: RentalOptions.Days7.rawValue))")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                } else {
                                    ProgressView()
                                        .scaleEffect(1)
                                        .tint(Color.white)
                                }
                                    
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
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
                                bookStoreViewModel.isRent7Purchasing = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    is7DaysRentPressed = false
                                    Utils.delayExecution(seconds: 0.5) {
                                        bookStoreViewModel.rentCurrentSelectedBook(rentalOption: .Days7)
                                    }
                                }
                            }
                            .disabled(bookStoreViewModel.isPurchasing || bookStoreViewModel.isRent7Purchasing || bookStoreViewModel.isRent14Purchasing)
                            
                            HStack {
                                Spacer()
                                
                                if (!bookStoreViewModel.isRent14Purchasing) {
                                    Text("14 Days: \(InAppManager.shared.getProductPrice(inAppProduct: RentalOptions.Days14.rawValue))")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.white)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                } else {
                                    ProgressView()
                                        .scaleEffect(1)
                                        .tint(Color.white)
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, minHeight: 24, alignment: .leading)
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
                                bookStoreViewModel.isRent14Purchasing = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    is14DaysRentPressed = false
                                    Utils.delayExecution(seconds: 0.5) {
                                        bookStoreViewModel.rentCurrentSelectedBook(rentalOption: .Days14)
                                    }
                                }
                            }
                            .disabled(bookStoreViewModel.isPurchasing || bookStoreViewModel.isRent7Purchasing || bookStoreViewModel.isRent14Purchasing)
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
            if (bookStoreViewModel.selectedBook?.id) != nil {
                bookStoreViewModel.checkIfBookAlreadyPurchased()
                bookStoreViewModel.fetchAdditionalBookDetails()
            }
        }
        .navigationTitle("Book Details")
        .fullScreenCover(isPresented: $isBookReadingViewPresented) {
            DocumentView(isPresented: $isBookReadingViewPresented)
        }
    }
}

