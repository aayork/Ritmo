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
    var highScore: HighScoreManager
    var immsersiveView: ImmersiveView?
    var handTracking: HandTracking?
    var carousel: SnapCarouselView
    var score = 0
    var tab = 1

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
        self.musicView = MusicView()
        self.recentlyPlayed = RecentlyPlayedManager()
        self.carousel = SnapCarouselView()
        self.highScore = HighScoreManager()
        Task { @MainActor in
            self.immsersiveView = ImmersiveView(gestureModel: HandTrackingContainer.handTracking)
            self.handTracking = HandTracking()
        }
    }
    /// Preload animation assets.
}
