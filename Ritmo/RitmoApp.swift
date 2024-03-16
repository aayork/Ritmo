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
                .frame(
                    minWidth: 1280, maxWidth: 1280,
                    minHeight: 720, maxHeight: 720)
        }
        .windowResizability(.contentSize)
        
        // I think to show the R!TMO logo we can make a new window group here and call it from HomeView
        
        WindowGroup(id: "scoreView") {
            ScoreView()
                .environment(self.gameModel)
                .frame(
                    minWidth: 460, maxWidth: 460,
                    minHeight: 230, maxHeight: 230)
        }
        .defaultSize(width: 460, height: 230)
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
    }
}
