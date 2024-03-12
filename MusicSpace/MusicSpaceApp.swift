//
//  MusicSpaceApp.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI

@main
struct vision_appApp: App {
    @State private var gameModel = GameModel()
    var body: some Scene {
        WindowGroup(id: "windowGroup") {
            ContentView()
                .environment(self.gameModel)
        } // To make the "glass window" go away, set window group to plain type

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
        /*
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
         */
    
    }
}
