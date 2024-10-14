//
//  BRUserDefaultManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public class BRUserDefaultManager {
    public static var shared: BRUserDefaultManager = BRUserDefaultManager()
    
    public var currentUser: BRUser? {
        get {
            if let m_UserData: Data = UserDefaults.standard.data(forKey: BRNameSpaces.UserDefaultIndentifiers.currentUserKey) {
                if let m_User: BRUser = try? JSONDecoder().decode(BRUser.self, from: m_UserData) {
                    return m_User
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if let m_UserJSON: Data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(m_UserJSON, forKey: BRNameSpaces.UserDefaultIndentifiers.currentUserKey)
            }
        }
    }
}
