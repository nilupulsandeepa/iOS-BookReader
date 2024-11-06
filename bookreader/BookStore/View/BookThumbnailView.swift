//
//  BookThumbnailView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BookThumbnailView: View {
    var imageName: String = "book_2"
    var book: Book
    
    @ObservedObject var storeVM: BookStoreViewModel
    @Binding var isPresented: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Image(imageName)
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
        .background(Color(uiColor: UIColor(red: 230, green: 239, blue: 255)))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: isPressed)
        .onTapGesture {
            withAnimation {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
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
