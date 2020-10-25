//
//  TabBar.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 25.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    private enum Tab: Hashable {
            case home
            case explore
            case user
            case settings
    }
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tag(0)
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                }
            SearchView()
                .tag(1)
                .tabItem {
                    Text("Search")
                    Image(systemName: "magnifyingglass")
                }
            UserView()
                .tag(2)
                .tabItem {
                    Text("User")
                    Image(systemName: "person.crop.circle")
                }
            MenuView()
                .tag(3)
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear")
                }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
