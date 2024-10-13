//
//  BRFeaturedBookView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRFeaturedBookView: View {
    var body: some View {
        HStack {
            Image("book_2")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 8) {
                Text("It Is A Love Thing")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Text("By: J.K. Rowling")
                    .font(.system(size: 18))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Spacer()
            }
        }
        .padding()
        .background(Color(uiColor: UIColor(red: 222, green: 245, blue: 227)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    BRFeaturedBookView()
}
