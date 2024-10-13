//
//  BRBookThumbnailView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRBookThumbnailView: View {
    @State private var g_ImageName: String = "book_1"
    
    init(thumbnailImageName: String) {
        self.g_ImageName = g_ImageName
    }
    
    var body: some View {
        VStack {
            Image(g_ImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 112)
            Text("Tails Of The Last Night")
                .frame(width: 150)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
        }
        .padding([.all], 4)
        .padding([.top, .bottom], 10)
        .background(Color(uiColor: UIColor(red: 241, green: 225, blue: 149)))
    }
}

#Preview {
    BRBookThumbnailView(thumbnailImageName: "book_1")
}
