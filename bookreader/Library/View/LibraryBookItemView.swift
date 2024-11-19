//
//  LibraryBookItem.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-06.
//

import SwiftUI

struct LibraryBookItem: View {
    
    @State public var book: Book? = nil
    
    var body: some View {
        HStack(alignment: .center) {
            Image("book_3")
                .resizable()
                .scaledToFit()
                .frame(width: 45)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    if let book {
                        Text(book.name)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .padding([.leading, .trailing], 4)
                        Text(book.authorName ?? "")
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                        .padding([.leading, .trailing], 4)
                }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Menu {
                    Button(role: .cancel, action: {
                        
                    }) {
                        Label("Duplicate item", systemImage: "doc.on.doc")
                    }
                    Button("Edit item") {
                        
                    }
                    Button(role: .destructive, action: {
                        
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                        .foregroundColor(.red)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(Color.green)
                }
                .onTapGesture {
                    print("Menu")
                }
            }
        }
    }
}

#Preview {
    LibraryBookItem()
}
