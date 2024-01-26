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
                    Image(systemName: "checkmark")
                    Text("Blue")
                }
            RedView()
                .tabItem {
                    Image(systemName: "rays")
                    Text("Red")
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
