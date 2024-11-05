//
//  FIRAuthenticationViewModel.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

public class FIRAuthenticationViewModel: ObservableObject {
    //---- MARK: Properties
    
    //---- MARK: Initialization
    init() {
        _ = Auth.auth().addStateDidChangeListener {
            [unowned self]
            auth, user in
            if user != nil {
                print("Have User")
            } else {
                print("No User")
                UserDefaultManager.shared.currentUser = nil
            }
            notifyUserChanges()
        }
    }
    
    //---- MARK: Action Methods
    public func startGoogleSignIn() {
        guard let windowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // Handle Error
            return
        }
        
        guard let rootViewController: UIViewController = windowScene.windows.first?.rootViewController else {
            // Handle Error
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {
            [unowned self]
            (gidResult, error) in
            
            if error != nil {
                // Handle Error
                return
            }
            
            guard let authentication: GIDGoogleUser = gidResult?.user, let iDToken: String = authentication.idToken?.tokenString else {
                // Handle Error
                return
            }
            
            let gIDCredential: AuthCredential = GoogleAuthProvider.credential(withIDToken: iDToken, accessToken: authentication.accessToken.tokenString)
            self.firebaseSignIn(credential: gIDCredential)
        }
    }
    
    public func logOut() {
        try? Auth.auth().signOut()
    }
    
    //---- MARK: Helper Methods
    private func firebaseSignIn(credential: AuthCredential) {
        let gIDCredential: AuthCredential = credential
        Auth.auth().signIn(with: gIDCredential) {
            [unowned self]
            result, error in
            if error != nil {
                // Handle Error
                return
            } else {
                if let profileImageURL: URL = result?.user.photoURL {
                    self.saveProfilePicture(url: profileImageURL, completion: {
                        [unowned self]
                        (savedURL, errorFileSave) in
                        
                        let currentUser: User = User()
                        if (errorFileSave == nil) {
                            currentUser.profilePictureURL = savedURL
                        }
                        currentUser.id = result!.user.uid
                        currentUser.name = result!.user.displayName ?? ""
                        currentUser.email = result?.user.email ?? ""
                        self.saveLoggedInUserInFirebase(user: currentUser)
                    })
                }
                
            }
        }
    }
    
    private func saveProfilePicture(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let profileImageURL: URL = url
        self.loadProfilePicture(url: profileImageURL) {
            data in
            
            guard let data: Data = data else {
                completion(nil, AppError.fileError)
                return
            }
            
            if let profileImage: UIImage = UIImage(data: data) {
                let finalURL: String = LocalStorageManager.shared.saveFileInLocalStorage(fileData: profileImage.pngData()!, fileName: "user-profile.png", folderName: "profile-data")
                completion(finalURL, nil)
            } else {
                completion(nil, AppError.fileError)
            }
        }
    }
    
    private func loadProfilePicture(url: URL, completion: @escaping (Data?) -> Void) {
        let request: URLRequest = URLRequest(url: url)
        let requestTask: URLSessionTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            let response: HTTPURLResponse = response as! HTTPURLResponse
            if response.statusCode >= 400 && response.statusCode < 200 {
                DispatchQueue.main.async {
                    completion(nil)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
        requestTask.resume()
    }
    
    private func saveLoggedInUserInFirebase(user: User) {
        let currentUser = user
        let path: String = "/users/\(currentUser.id!)"
        let value: [String: Any] = [
            "id": currentUser.id!,
            "email": currentUser.email!,
            "name": currentUser.name!
        ]
        
        FIRDatabaseManager.shared.observeDataAtPathOnce(path: path, completion: {
            [unowned self]
            (snapshot) in
            if let alreadyLoggedInUser = snapshot.value as? [String: Any],
               let dbUserData: Data = try? JSONSerialization.data(withJSONObject: alreadyLoggedInUser),
               let dbUser: User = try? JSONDecoder().decode(User.self, from: dbUserData) {
                dbUser.profilePictureURL = currentUser.profilePictureURL
                UserDefaultManager.shared.currentUser = dbUser
            } else {
                FIRDatabaseManager.shared.setValueAtPath(path: path, value: value) {
                    //Notify user added
                    UserDefaultManager.shared.currentUser = currentUser
                }
            }
            notifyUserChanges()
        })
    }
    
    private func notifyUserChanges() {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: NameSpaces.NotificationIdentifiers.sessionUserUpdated),
            object: nil,
            userInfo: ["newUser": UserDefaultManager.shared.currentUser as Any]
        )
    }
}
