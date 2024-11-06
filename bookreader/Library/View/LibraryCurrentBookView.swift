//
//  LibraryCurrentBookView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-06.
//

import SwiftUI

struct LibraryCurrentBookView: View {
    
    @State public var bookName: String? = nil
    @State public var authorName: String? = nil
    @State public var bookProgress: Int = 0
    
    var body: some View {
        ZStack {
            if let bookName, let authorName {
                HStack(alignment: .center) {
                    Image("book_3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(bookName)
                                .font(.system(size: 18))
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                .padding([.leading, .trailing], 4)
                            Text(authorName)
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                .padding([.leading, .trailing], 4)
                            Text("⭐️⭐️⭐️⭐️⭐️")
                                .font(.system(size: 10))
                                .multilineTextAlignment(.trailing)
                                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                                .padding([.leading, .trailing], 4)
                                .padding([.top], 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        BookProgressView(progress: Float(bookProgress) / 100)
                            .frame(width: 50)
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryCurrentBookView()
}
