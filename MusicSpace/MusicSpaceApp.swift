//
//  MusicSpaceApp.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI

@main
struct MusicSpaceApp: App {
    @State private var gameModel = GameModel()
    var body: some Scene {
        WindowGroup(id: "windowGroup") {
            ContentView()
                .environment(self.gameModel)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
    }
}
