//
//  GameModel.swift
//  vision-app
//
//  Created by Aidan York on 2/22/24.
//

import AVKit
import RealityKit
import SwiftUI

/// State that drives the different screens of the game and options that players select.
@Observable
class GameModel {
    var isPlaying = false
    var isPaused = false {
        didSet {
            if isPaused == true {
                gameplayPlayer.pause()
            } else {
                gameplayPlayer.play()
            }
        }
    }
    
    /// A Boolean value that indicates that game assets have loaded.
    var readyToStart = false
    
    // Music players.
    var victoryPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "happyBeamVictory", withExtension: "m4a")!)
    var gameplayPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "happyBeamGameplay", withExtension: "m4a")!)
    var menuPlayer = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "happyBeamMenu", withExtension: "m4a")!)
    
    var isSharePlaying = false
    var isSpatial = false
    
    var isFinished = false {
        didSet {
            if isFinished == true {
                gameplayPlayer.pause()
                
                victoryPlayer.numberOfLoops = -1
                victoryPlayer.volume = 0.6
                victoryPlayer.currentTime = 0
                victoryPlayer.play()
            }
        }
    }
    
    var isSoloReady = false {
        didSet {
            if isPlaying == true {
                victoryPlayer.pause()
                
                gameplayPlayer.volume = 0.6
                gameplayPlayer.currentTime = 0
                gameplayPlayer.play()
            }
        }
    }
    
    static let gameTime = 35
    var timeLeft = gameTime
    var isCountDownReady = false {
        didSet {
            if isCountDownReady == true {
                menuPlayer.setVolume(0, fadeDuration: Double(countDown))
            }
        }
    }
    
    var countDown = 3
    var score = 0
    var isMuted = false {
        didSet {
            if isMuted == true {
                gameplayPlayer.pause()
            } else {
                gameplayPlayer.play()
            }
        }
    }
   
    /// Resets game state information.
    func reset() {
        isPlaying = false
        isPaused = false
        isSharePlaying = false
        isFinished = false
        isSoloReady = false
        isCountDownReady = false
        countDown = 3
        score = 0
        
        /// Preload assets when the app launches to avoid pop-in during the game.
        
        /// The kinds of input selections offered to players.
        enum InputKind {
            /// An input method that uses ARKit to detect a heart gesture.
            case hands
            
            /// An input method that spawns a stationary heart projector.
            case alternative
        }
    }
}
