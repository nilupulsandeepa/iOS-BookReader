//
//  BRFIRAuthenticationViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

public class BRFIRAuthenticationViewModel: ObservableObject {
    //---- MARK: Properties
    @Published var currentUser: User? = nil
    
    //---- MARK: Initialization
    init() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            self.currentUser = user
        }
    }
    
    //---- MARK: Action Methods
    public func startGoogleSignIn() {
        guard let m_WindowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // Handle Error
            return
        }
        
        guard let m_RootViewController: UIViewController = m_WindowScene.windows.first?.rootViewController else {
            // Handle Error
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: m_RootViewController) {
            (result, error) in
            
            if error != nil {
                // Handle Error
                return
            }
            
            guard let m_Authentication: GIDGoogleUser = result?.user, let m_IDToken: String = m_Authentication.idToken?.tokenString else {
                // Handle Error
                return
            }
            
            if let m_ProfileImageURL: URL = result?.user.profile?.imageURL(withDimension: 512) {
                var img: UIImage? = UIImage(data: try! Data(contentsOf: m_ProfileImageURL))
                print("")
            }
            
            let m_GIDCredential: AuthCredential = GoogleAuthProvider.credential(withIDToken: m_IDToken, accessToken: m_Authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: m_GIDCredential) { result, error in
                if error != nil {
                    // Handle Error
                    return
                } else {
                    print("Authentication Successfull => \(result?.user.uid) => \(result?.user.displayName)")
                }
            }
            
        }
    }
}
