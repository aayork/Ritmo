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
        
        // I think to show the R!TMO logo we can make a new window group here and call it from HomeView
        
        WindowGroup(id: "scoreView") {
            ScoreView()
                .environment(self.gameModel)
        }
        .defaultSize(width: 460, height: 230)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
    }
}
