//
//  BRNavigationView.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import SwiftUI

struct BRNavigationView: View {
    
    //---- MARK: Properties
    @State private var g_SelectedTabIndex = 0
    
    init() {
        // Customize the appearance of the Tab Bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
            
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView(
            selection: $g_SelectedTabIndex,
            content:  {
                BRBookStoreView()
                    .tabItem {
                        Image(systemName: "safari")
                        Text("Explore")
                    }
                BRLibraryView()
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("Library")
                    }
                BRSettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
        })
        .tint(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
        .background(Color(uiColor: UIColor(red: 219, green: 41, blue: 85)))
    }
}

#Preview {
    BRNavigationView()
}
