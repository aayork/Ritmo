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
    
    @State private var playing = false
        
    @State var songTitle = "Not Playing"
        
    @State var artistName = "artist_name"

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        TabView {
            
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
