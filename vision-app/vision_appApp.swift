//
//  vision_appApp.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI

@main
struct vision_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        } // To make the "glass window" go away, set window group to plain type

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    
    }
}
