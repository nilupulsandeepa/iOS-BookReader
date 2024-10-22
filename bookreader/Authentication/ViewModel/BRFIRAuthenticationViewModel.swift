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
        _ = Auth.auth().addStateDidChangeListener {
            [unowned self]
            auth, user in
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
            [unowned self]
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
            self.firebaseSignIn(credential: m_GIDCredential)
        }
    }
    
    //---- MARK: Helper Methods
    private func firebaseSignIn(credential: AuthCredential) {
        let m_GIDCredential: AuthCredential = credential
        Auth.auth().signIn(with: m_GIDCredential) {
            [unowned self]
            result, error in
            if error != nil {
                // Handle Error
                return
            } else {
                if let m_ProfileImageURL: URL = result?.user.photoURL {
                    self.saveProfilePicture(url: m_ProfileImageURL, completion: {
                        [unowned self]
                        (savedURL, errorFileSave) in
                        
                        let m_CurrentUser: BRUser = BRUser()
                        if (errorFileSave == nil) {
                            m_CurrentUser.profilePictureURL = savedURL
                        }
                        m_CurrentUser.id = result!.user.uid
                        m_CurrentUser.name = result!.user.displayName ?? ""
                        m_CurrentUser.email = result?.user.email ?? ""
                        self.saveLoggedInUserInFirebase(user: m_CurrentUser)
                    })
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
    
    private func saveLoggedInUserInFirebase(user: BRUser) {        
        let m_CurrentUser = user
        let m_Path: String = "/users/\(m_CurrentUser.id!)"
        let m_Value: [String: Any] = [
            "id": m_CurrentUser.id!,
            "email": m_CurrentUser.email!,
            "name": m_CurrentUser.name!
        ]
        
        BRFIRDatabaseManager.shared.observeDataAtPathOnce(path: m_Path, completion: {
            [unowned self]
            (snapshot) in
            if let m_AlreadyLoggedInUser = snapshot.value as? [String: Any],
               let m_DbUserData: Data = try? JSONSerialization.data(withJSONObject: m_AlreadyLoggedInUser),
               let m_DbUser: BRUser = try? JSONDecoder().decode(BRUser.self, from: m_DbUserData) {
                m_DbUser.profilePictureURL = m_CurrentUser.profilePictureURL
                self.currentUser = m_DbUser
                BRUserDefaultManager.shared.currentUser = m_DbUser
            } else {
                BRFIRDatabaseManager.shared.setValueAtPath(path: m_Path, value: m_Value) {
                    //Notify user added
                    self.currentUser = m_CurrentUser
                }
            }
        })
    }
}
