//
//  BRProfilePictureView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRProfilePictureView: View {
    
    @ObservedObject private var g_AuthViewModel: BRFIRAuthenticationViewModel
    
    init(g_AuthViewModel: BRFIRAuthenticationViewModel) {
        self.g_AuthViewModel = g_AuthViewModel
    }
    
    var body: some View {
//        if let m_CurrentUser: BRUser = g_AuthViewModel.currentUser {
//            let dd = FileManager.default.contents(atPath: m_CurrentUser.getProfilePictureURL()!)
//            Image(uiImage: UIImage(data: dd!)!)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 44, height: 44)
//                .clipShape(Circle())
//                .clipped()
//                .overlay(
//                    Circle().stroke(Color(uiColor: UIColor(red: 61, green: 84, blue: 103)), lineWidth: 3)
//                )
//                .shadow(radius: 5)
//                .padding([.bottom], 5)
//                .onTapGesture {
//                    g_AuthViewModel.startGoogleSignIn()
//                }
//        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .scaleEffect(0.55)
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .clipped()
                .overlay(
                    Circle().stroke(Color(uiColor: UIColor(red: 61, green: 84, blue: 103)), lineWidth: 3)
                )
                .shadow(radius: 5)
                .padding([.bottom], 5)
                .onTapGesture {
                    g_AuthViewModel.startGoogleSignIn()
                }
//        }
    }
}

#Preview {
    
    BRProfilePictureView(g_AuthViewModel: BRFIRAuthenticationViewModel())
}
