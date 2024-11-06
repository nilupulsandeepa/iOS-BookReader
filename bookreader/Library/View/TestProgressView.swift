//
//  TestProgressView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-06.
//

import SwiftUI

struct TestProgressView: View {
    
    @State var sliderValue: Float = 0.5
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .opacity(0.1)
                    .foregroundStyle(Color.green)
                Circle()
                    .trim(from: 0.0, to: CGFloat(sliderValue))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundStyle(Color.green)
                    .rotationEffect(.degrees(-90))
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .opacity(0.1)
                    .foregroundStyle(Color.red)
                    .frame(width: 150, height: 150)
                RoundedRectangle(cornerRadius: 25.0)
                    .trim(from: 0.0, to: CGFloat(sliderValue))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundStyle(Color.red)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                Text("\(Int(sliderValue * 100))%")
                    .font(.footnote)
            }
            .padding(40)
            Slider(value: $sliderValue, in: 0...1.0)
        }
    }
}

#Preview {
    TestProgressView()
}
