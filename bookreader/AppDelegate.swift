//
//  File.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Task {
            await InAppManager.shared.loadInAppProducts()
            InAppManager.shared.listenForTransactions()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
