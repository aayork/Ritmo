//
//  MusicPlaybackManager.swift
//  Ritmo
//
//  Created by Aidan York on 4/20/24.
//

import Foundation
import SwiftUI
import MusicKit
import RealityKit
import RealityKitContent

@MainActor
class MusicPlaybackManager {
    
    @EnvironmentObject var gameModel: GameModel
    @State var playing = false
    @State var highScore = 0
    let musicPlayer = ApplicationMusicPlayer.shared
    
    struct Item: Identifiable, Hashable, Codable {
        var id = UUID()
        let name: String
        let artist: String
        let song: Song // This is the playable music item
        let artwork: Artwork
        let duration: TimeInterval
        let genres: [String]
    }
    
    /// Play a given song
    @MainActor
    private func play<I: PlayableMusicItem>(_ item: I) async throws {
        musicPlayer.queue = [item]
        try await musicPlayer.play()
    }
    
    /// Return the selected song's name
    public func getSongName() -> String {
        return gameModel.selectedSong?.name ?? "No Song Selected"
    }
    
    /// Play or pause music
    func togglePlaying() async {
        // Toggle the playing state
        playing.toggle()
        print(playing)
        // Check if there's a selected song and the playing state
        
        if playing {
            // Request music authorization
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                // If authorized, play the selected song
                do {
                    try await play(gameModel.selectedSong!.song)
                } catch {
                    print("Error playing song: \(error)")
                    playing = false
                }
            default:
                print("Music authorization not granted")
                playing = false // Revert playing state as we cannot play the music
            }
        } else {
            // Pause the music player
            musicPlayer.pause()
        }
    }
}
