//
//  BRBookThumbnailView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookThumbnailView: View {
    var g_ImageName: String = "book_1"
    var book: BRBook
    
    @ObservedObject var storeVM: BRBookStoreViewModel
    @State private var isPressed = false
    @Binding var isPresented: Bool
    
//    init(thumbnailImageName: String, bookName: String) {
//        self.g_ImageName = thumbnailImageName
//        self.g_Name = bookName
//    }
    
    var body: some View {
        VStack {
            Image(g_ImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)), style: FillStyle())
            Text(book.name)
                .frame(width: 150, height: 50)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                .padding([.leading, .trailing], 4)
        }
        .padding([.all], 4)
        .padding([.top, .bottom], 10)
        .background(Color(uiColor: UIColor(red: 241, green: 225, blue: 149)))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.bouncy(), value: isPressed)
        .onTapGesture {
            withAnimation {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPressed = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    storeVM.selectedBook = book
                    isPresented = true
                    
                })
            }
        }
    }
}

//#Preview {
//    BRBookThumbnailView(thumbnailImageName: "book_1", bookName: "Last Night Tails")
//}
