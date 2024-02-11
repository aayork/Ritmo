//
//  PlayMusic.swift
//  vision-app
//
//  Created by Aidan York on 1/26/24.
//

import Foundation
import AVFoundation
import AVFAudio
import OSLog

var player: AVAudioPlayer?
// "?" denotes an optional variable

var songs = ["01 Closing Time", "02 Hey, Soul Sister", "03 I Will Wait", "04 She Will Be Loved"]
var currentSong = 0;
var newSong = true;

func playMusic() {
    // Check if the player is not nil
    if (player == nil || newSong) {
        // Initialize the audio player if it's not already initialized
        guard let url = Bundle.main.url(forResource: songs[currentSong], withExtension: "mp3") else {
            print("Error: Could not find the audio file.")
            return
        }

        do {
            newSong = false
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

func cycleLeft() -> String {
    currentSong -= 1
    if (currentSong < 0) {
        currentSong = songs.count - 1;
    }
    newSong = true;
    return songs[currentSong]
}

func cycleRight() -> String {
    currentSong += 1
    if (currentSong > songs.count - 1) {
        currentSong = 0;
    }
    newSong = true;
    return songs[currentSong]
}
