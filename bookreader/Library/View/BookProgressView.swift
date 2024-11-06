//
//  BookProgressView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-06.
//

import SwiftUI

struct BookProgressView: View {
    @State var progress: Float = 0.5
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .opacity(0.1)
                    .foregroundStyle(Color(uiColor: UIColor(red: 51, green: 129, blue: 255)))
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundStyle(Color(uiColor: UIColor(red: 51, green: 129, blue: 255)))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(progress * 100))%")
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    BookProgressView()
}
