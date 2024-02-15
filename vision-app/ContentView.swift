//
//  ContentView.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            MusicView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Library")
                }
            GameView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Game")
                }
            FriendsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            MusicSpaceView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Game")
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
