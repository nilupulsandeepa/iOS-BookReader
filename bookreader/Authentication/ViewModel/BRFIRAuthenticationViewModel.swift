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
    @Published var currentUser: BRUser? = nil
    
    
    
    //---- MARK: Initialization
    init() {
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                if (self.currentUser == nil) {
                    print("Previous User Loaded")
                    self.currentUser = BRUserDefaultManager.shared.currentUser
                } else {
                    print("User Logged in")
                }
            } else {
                print("No User")
                BRUserDefaultManager.shared.currentUser = nil
                self.currentUser = nil
            }
        }
    }
    
    //---- MARK: Action Methods
    public func startGoogleSignIn() {
        if (self.currentUser != nil) {
            try? Auth.auth().signOut()
            return
        }
        guard let m_WindowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // Handle Error
            return
        }
        
        guard let m_RootViewController: UIViewController = m_WindowScene.windows.first?.rootViewController else {
            // Handle Error
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: m_RootViewController) {
            (gidResult, error) in
            
            if error != nil {
                // Handle Error
                return
            }
            
            guard let m_Authentication: GIDGoogleUser = gidResult?.user, let m_IDToken: String = m_Authentication.idToken?.tokenString else {
                // Handle Error
                return
            }
            
            let m_GIDCredential: AuthCredential = GoogleAuthProvider.credential(withIDToken: m_IDToken, accessToken: m_Authentication.accessToken.tokenString)
            self.firebaseSignIn(credential: m_GIDCredential, profileURL: gidResult?.user.profile?.imageURL(withDimension: 256))
        }
    }
    
    //---- MARK: Helper Methods
    private func firebaseSignIn(credential: AuthCredential, profileURL: URL?) {
        let m_GIDCredential: AuthCredential = credential
        Auth.auth().signIn(with: m_GIDCredential) { result, error in
            if error != nil {
                // Handle Error
                return
            } else {
                if let m_ProfileImageURL: URL = result?.user.photoURL {
                    self.saveProfilePicture(url: m_ProfileImageURL, completion: {
                        (savedURL, errorFileSave) in
                            let m_CurrentUser: BRUser = BRUser()
                            if (errorFileSave == nil) {
                                m_CurrentUser.setProfilePictureURL(path: savedURL!)
                            }
                            m_CurrentUser.setAuthenticationID(id: result!.user.uid)
                            m_CurrentUser.setDisplayName(name: result!.user.displayName ?? "")
                            m_CurrentUser.setEmail(email: result?.user.email ?? "")
                            self.currentUser = m_CurrentUser
                            BRUserDefaultManager.shared.currentUser = m_CurrentUser
                        }
                    )
                }
                
            }
        }
    }
    
    private func saveProfilePicture(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let m_ProfileImageURL: URL = url
        self.loadProfilePicture(url: m_ProfileImageURL) {
            data in
            
            guard let m_Data: Data = data else {
                completion(nil, BRError.fileError)
                return
            }
            
            if let m_ProfileImage: UIImage = UIImage(data: m_Data) {
                let m_FinalURL: String = BRLocalStorageManager.shared.saveFileInLocalStorage(fileData: m_ProfileImage.pngData()!, fileName: "user-profile.png", folderName: "profile-data")
                completion(m_FinalURL, nil)
            } else {
                completion(nil, BRError.fileError)
            }
        }
    }
    
    private func loadProfilePicture(url: URL, completion: @escaping (Data?) -> Void) {
        let m_Request: URLRequest = URLRequest(url: url)
        let m_RequestTask: URLSessionTask = URLSession.shared.dataTask(with: m_Request) {
            (data, response, error) in
            
            let m_Response: HTTPURLResponse = response as! HTTPURLResponse
            if m_Response.statusCode >= 400 && m_Response.statusCode < 200 {
                DispatchQueue.main.async {
                    completion(nil)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        m_RequestTask.resume()
    }
}
