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
            SpatialAudioView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Library")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
