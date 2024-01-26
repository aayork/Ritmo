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
            BlueView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Now Playing")
                }
            RedView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Library")
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
