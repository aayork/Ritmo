//
//  PlayMusic.swift
//  vision-app
//
//  Created by Aidan York on 1/26/24.
//

import Foundation
import AVFoundation
import AVFAudio

var player: AVAudioPlayer?

func playMusic() {
    // Check if the player is not nil
    if player == nil {
        // Initialize the audio player if it's not already initialized
        guard let url = Bundle.main.url(forResource: "08 All the Small Things", withExtension: "mp3") else {
            print("Error: Could not find the audio file.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
    }
        
    // Play the audio
    player?.play()
}

func pauseMusic() {
    // Pause the audio if the player is not nil
    player?.pause()
}
