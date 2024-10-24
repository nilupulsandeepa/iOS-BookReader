//
//  BRProfilePictureView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRProfilePictureView: View {
    
    @EnvironmentObject var appAuthentication: BRFIRAuthenticationViewModel
    @EnvironmentObject var appAuthSession: BRSessionViewModel
    
    var body: some View {
        if let m_CurrentUser: BRUser = appAuthSession.currentUser {
            let m_ProfileImgData: Data = BRLocalStorageManager.shared.getFileDataInLocalStorage(filePath: m_CurrentUser.profilePictureURL!)!
            Image(uiImage: UIImage(data: m_ProfileImgData)!)
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
                    appAuthentication.logOut()
                }
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
    BRProfilePictureView()
}
