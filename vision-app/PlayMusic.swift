//
//  PlayMusic.swift
//  vision-app
//
//  Created by Aidan York on 1/26/24.
//

import Foundation
import AVFoundation
import AVFAudio

var player: AVAudioPlayer!

let url = Bundle.main.url(forResource: "01 Closing Time", withExtension: "mp3")

func playMusic() {
    // Check if the URL is not nil
    guard let url = Bundle.main.url(forResource: "Music/08 All the Small Things", withExtension: ".mp3") else {
        print("Error: Could not find the audio file.")
        return
    }

    do {
        // Initialize the audio player
        player = try AVAudioPlayer(contentsOf: url)
        
        // Prepare the player for playback
        player.prepareToPlay()
        
        // Play the audio
        player.play()
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
