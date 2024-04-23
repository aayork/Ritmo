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
class GameModel: ObservableObject {
    /// A Boolean value that indicates that game assets have loaded.
    @Published var musicView: MusicView
    @Published var recentlyPlayed: RecentlyPlayedManager
    @Published var musicPlaybackManager: MusicPlaybackManager?
    @Published var highScore: HighScoreManager
    @Published var immsersiveView: ImmersiveView?
    @Published var handTracking: HandTracking?
    @Published var tutorialPlayer: TutorialPlayer?
    @Published var score = 0
    @Published var tab = 1
    @Published var songTime = 0 //millis
    @Published var isPlaying = false
    @Published var curated = false
    @Published var selectedSong: Item?
    @Published var searchText = ""

    /// Removes 3D content when then game is over.
    func clear() {
        spaceOrigin.children.removeAll()
    }
    
    /// Resets game state information.
    func reset() {
        tab = 1
        songTime = 0
        score = 0
        isPlaying = false
        curated = false
        clear()
    }
    
    /// Preload assets when the app launches to avoid pop-in during the game.
    init() {
        self.musicView = MusicView()
        self.recentlyPlayed = RecentlyPlayedManager()
        self.highScore = HighScoreManager()
        self.tutorialPlayer = TutorialPlayer()
        
        guard let importEntity = try? Entity.load(named: "left_open", in: realityKitContentBundle) else {
            print("Failed to load entity: left_open")
            return
        }
        leftOpen = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_fist", in: realityKitContentBundle) else {
            print("Failed to load entity: left_fist")
            return
        }
        leftFist = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_peaceSign", in: realityKitContentBundle) else {
            print("Failed to load entity: left_peaceSign")
            return
        }
        leftPeaceSign = importEntity
        
        guard let importEntity = try? Entity.load(named: "left_point", in: realityKitContentBundle) else {
            print("Failed to load entity: left_point")
            return
        }
        leftPoint = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_open", in: realityKitContentBundle) else {
            print("Failed to load entity: right_open")
            return
        }
        rightOpen = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_fist", in: realityKitContentBundle) else {
            print("Failed to load entity: right_fist")
            return
        }
        rightFist = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_peaceSign", in: realityKitContentBundle) else {
            print("Failed to load entity: right_peaceSign")
            return
        }
        rightPeaceSign = importEntity
        
        guard let importEntity = try? Entity.load(named: "right_point", in: realityKitContentBundle) else {
            print("Failed to load entity: right_point")
            return
        }
        rightPoint = importEntity
        
        Task { @MainActor in
            self.musicPlaybackManager = MusicPlaybackManager()
            self.immsersiveView = ImmersiveView(gestureModel: HandTrackingContainer.handTracking)
            self.handTracking = HandTracking()
        }
    }
}
