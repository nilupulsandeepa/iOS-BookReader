//
//  ProfilePictureView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct ProfilePictureView: View {
    
    @EnvironmentObject var appAuthentication: AuthenticationViewModel
    @EnvironmentObject var appAuthSession: SessionViewModel
    
    @State var isAlertPresented: Bool = false
    
    var body: some View {
        if let currentUser: User = appAuthSession.currentUser {
            let profileImgData: Data = LocalStorageManager.shared.getFileDataInLocalStorage(filePath: currentUser.profilePictureURL!)!
            Image(uiImage: UIImage(data: profileImgData)!)
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
                    isAlertPresented = true
                }
                .alert("Warning!", isPresented: $isAlertPresented, actions: {
                    Button("Cancel", role: .cancel) { }
                    Button("LogOut", role: .destructive) {
                        appAuthentication.logOut()
                    }
                }, message: {
                    Text("Do you want to continue loging out?")
                })
        } else {
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
                    appAuthentication.startGoogleSignIn()
                }
        }
    }
}

#Preview {
    ProfilePictureView()
}
