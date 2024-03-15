//
//  RitmoApp.swift
//  Ritmo
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI

@main
struct RitmoApp: App {
    @State private var gameModel = GameModel()
    var body: some Scene {
        WindowGroup(id: "windowGroup") {
            ContentView()
                .environment(self.gameModel)
        }
        
        WindowGroup(id: "Score") {
            ScoreView()
                .environment(self.gameModel)
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
    }
}
