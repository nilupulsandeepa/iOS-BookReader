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
    
    //---- MARK: Environment Properties
    @StateObject var appAuthentication: AuthenticationViewModel = AuthenticationViewModel()
    @StateObject var appAuthSession: SessionViewModel = SessionViewModel()
    
    let persistenceController = PersistenceController.shared
    
    init() {
        CoreDataManager.shared.initializeCoreData(context: persistenceController.container.newBackgroundContext())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appAuthentication)
                .environmentObject(appAuthSession)
        }
    }
}
