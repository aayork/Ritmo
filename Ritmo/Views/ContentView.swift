//
//  ContentView.swift
//  Ritmo
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(GameModel.self) var gameModel
    var body: some View {
        if (gameModel.musicView.playing == true) {
            ScoreView()
        } else {
            IntermediateView()
        }
    }
}
