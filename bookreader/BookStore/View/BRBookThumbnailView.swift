//
//  BRBookThumbnailView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookThumbnailView: View {
    private var g_ImageName: String = "book_1"
    private var g_Name: String = ""
    
    init(thumbnailImageName: String, bookName: String) {
        self.g_ImageName = thumbnailImageName
        self.g_Name = bookName
    }
    
    var body: some View {
        VStack {
            Image(g_ImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)), style: FillStyle())
            Text(g_Name)
                .frame(width: 150, height: 50)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                .padding([.leading, .trailing], 4)
        }
        .padding([.all], 4)
        .padding([.top, .bottom], 10)
        .background(Color(uiColor: UIColor(red: 241, green: 225, blue: 149)))
    }
}

#Preview {
    BRBookThumbnailView(thumbnailImageName: "book_1", bookName: "Last Night Tails")
}
