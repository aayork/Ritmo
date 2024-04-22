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
    @EnvironmentObject var gameModel: GameModel
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            HomeView()
                .environmentObject(gameModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            MusicView()
                .environmentObject(gameModel)
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Play")
                }
                .tag(2)
            SettingsView()
                .environmentObject(gameModel)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameModel().self)
}
