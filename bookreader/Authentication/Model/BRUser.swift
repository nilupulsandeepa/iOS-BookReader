//
//  BRUser.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import SwiftUI

public class BRUser: Codable {
    private var g_AuthenticationID: String? = nil
    private var g_Email: String? = nil
    private var g_DisplayName: String? = nil
    private var g_ProfilePictureURL: String? = nil
    
    //---- MARK: Action Methods
    public func setAuthenticationID(id: String) {
        g_AuthenticationID = id
    }
    
    public func setEmail(email: String) {
        g_Email = email
    }
    
    public func setDisplayName(name: String) {
        g_DisplayName = name
    }
    
    public func setProfilePictureURL(path: String) {
        g_ProfilePictureURL = path
    }
    
    public func getAuthenticationID() -> String? {
        return g_AuthenticationID
    }
    
    public func getEmail() -> String? {
        return g_Email
    }
    
    public func getDisplayName() -> String? {
        return g_DisplayName
    }
    
    public func getProfilePictureURL() -> String? {
        return g_ProfilePictureURL
    }
}
