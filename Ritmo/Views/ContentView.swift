//
//  ContentView.swift
//  Ritmo
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(GameModel.self) var gameModel
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            MusicView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Play")
                }
                .tag(2)
            FriendsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
                }
                .tag(3)
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
        .environment(GameModel().self)
}
