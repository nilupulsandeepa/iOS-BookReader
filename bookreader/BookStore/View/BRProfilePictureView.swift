//
//  BRProfilePictureView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRProfilePictureView: View {
    
    @ObservedObject var authViewModel = BRFIRAuthenticationViewModel()
    
    var body: some View {
        Image("profile_img")
            .resizable()
            .scaledToFill()
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .clipped()
            .overlay(
                Circle().stroke(Color(uiColor: UIColor(red: 61, green: 84, blue: 103)), lineWidth: 3)
            )
            .shadow(radius: 5)
            .padding([.bottom], 5)
            .onTapGesture {
                authViewModel.startGoogleSignIn()
            }
    }
}

#Preview {
    BRProfilePictureView()
}
