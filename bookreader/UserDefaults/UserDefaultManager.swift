//
//  UserDefaultManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public class UserDefaultManager {
    public static var shared: UserDefaultManager = UserDefaultManager()
    
    public var currentUser: User? {
        get {
            if let userData: Data = UserDefaults.standard.data(forKey: NameSpaces.UserDefaultIndentifiers.currentUserKey) {
                if let user: User = try? JSONDecoder().decode(User.self, from: userData) {
                    return user
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let userJSON: Data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(userJSON, forKey: NameSpaces.UserDefaultIndentifiers.currentUserKey)
            }
        }
    }
}
