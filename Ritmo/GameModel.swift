//
//  GameModel.swift
//  Ritmo
//
//  Created by Max Pelot on 3/12/24.
//

import AVKit
import RealityKit
import RealityKitContent
import SwiftUI

/// State that drives the different screens of the game and options that players select.
@Observable
class GameModel {
    /// A Boolean value that indicates that game assets have loaded.
    var musicView: MusicView
    var recentlyPlayed: RecentlyPlayedManager
    var highScore: HighScoreManager
    var immsersiveView: ImmersiveView?
    var handTracking: HandTracking?
    var carousel: SnapCarouselView
    var score = 0
    var tab = 1
    var songTime = 0 //millis
    var isPlaying = false
    var curated = false

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
        
        guard let importEntity = try? Entity.load(named: "left_open", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        leftOpen = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_fist", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        leftFist = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_peaceSign", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        leftPeaceSign = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_gun", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        leftPoint = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_open", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        rightOpen = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_fist", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        rightFist = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_peaceSign", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        rightPeaceSign = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_gun", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        rightPoint = importEntity
        
        Task { @MainActor in
            self.immsersiveView = ImmersiveView(gestureModel: HandTrackingContainer.handTracking)
            self.handTracking = HandTracking()
        }
    }
}
