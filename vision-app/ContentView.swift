//
//  ContentView.swift
//  vision-app
//
//  Created by Aidan York on 1/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        TabView {
            PlayingView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Now Playing")
                }
            LibraryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Library")
                }
            CubeView()
                .tabItem {
                    Image(systemName: "square")
                    Text("Cube")
                }

        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
