//
//  FeaturedBookView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct FeaturedBookView: View {
    
    @State var isPreviewTapped: Bool = false
    
    var body: some View {
        HStack {
            Image("book_2")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            VStack(alignment: .leading, spacing: 8) {
                Text("It Is A Love Thing")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Text("By: J.K. Rowling")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Text("⭐️⭐️⭐️⭐️⭐️")
                    .font(.system(size: 12))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color(uiColor: UIColor(red: 64, green: 64, blue: 64)))
                Text("Preview")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .background(Color(uiColor: UIColor(red: 255, green: 214, blue: 117)))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .padding([.top], 5)
                    .scaleEffect(isPreviewTapped ? 0.95 : 1.0)
                    .animation(.bouncy(duration: 0.15, extraBounce: 0.5), value: isPreviewTapped)
                    .onTapGesture {
                        withAnimation {
                            isPreviewTapped = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            isPreviewTapped = false
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    FeaturedBookView()
}
