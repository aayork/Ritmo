//
//  vision_appApp.swift
//  vision-app
//
//  Created by Aidan York on 1/23/24.
//

import SwiftUI

@main
struct vision_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: "secondaryVolume") {
            SecondaryVolumeView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.1, height: 0.1, depth: 0.1, in: .meters)
        
        ImmersiveSpace(id: "Immersive Space") {

            
        }
    }
}
