//
//  GameModel.swift
//  Ritmo
//
//  Created by Max Pelot on 3/12/24.
//

import AVKit
import RealityKit
import SwiftUI

/// State that drives the different screens of the game and options that players select.
@Observable
class GameModel {
    /// A Boolean value that indicates that game assets have loaded.
    var readyToStart = false
    var musicView: MusicView
    var recentlyPlayed: RecentlyPlayedManager
    var score = 0

    /// Removes 3D content when then game is over.
    func clear() {
        spaceOrigin.children.removeAll()
    }
    
    /// Resets game state information.
    func reset() {
        score = 0
        clear()
    }
    
    /// Preload assets when the app launches to avoid pop-in during the game.
    init() {
        //self.togglePlayPause = {}
        self.musicView = MusicView()
        self.recentlyPlayed = RecentlyPlayedManager()
    }
    /// Preload animation assets.
}
