//
//  ContentView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(GameModel.self) var gameModel
    var body: some View {
        if musicView.playing {
            ScoreView()
        } else {
            ContentView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
