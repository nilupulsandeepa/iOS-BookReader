//
//  bookreaderApp.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-11.
//

import SwiftUI

@main
struct bookreaderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
