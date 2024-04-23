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
    @State private var songs = [Item]()
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
    private func play<I: PlayableMusicItem>(_ song: I) async throws {
        musicPlayer.queue = [song]
        print("song", song)
        try await musicPlayer.play()
    }
    
    /// Return the selected song's name
    public func getSongName() -> String {
        return gameModel.selectedSong?.name ?? "No Song Selected"
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: gameModel.searchText, types: [Song.self])
        request.limit = 25
        return request
    }
    
    func fetchMusic() {
        print(gameModel.searchText)
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let result = try await request.response()
                    self.songs = result.songs.compactMap { song in
                        return Item(name: song.title, artist: song.artistName, song: song.self, artwork: song.artwork!, duration: (song.duration ?? -1) * 1000, genres: song.genreNames)
                    }
                    
                    for song in self.songs {
                        print("Song: \(song.name), Artist: \(song.artist), Genres: \(song.genres.joined(separator: ", "))")
                    }
                } catch {
                    print("Error fetching music")
                }
            default:
                break
            }
        }
    }
    
    /// Play or pause music
    func togglePlaying() async {
        // Toggle the playing state
        playing.toggle()
        print("Playing toggled: \(playing)")

        if playing {
            // Request music authorization
            let status = await MusicAuthorization.request()
            print("Music authorization status: \(status)")
            switch status {
            case .authorized:
                // If authorized, attempt to play the selected song
                guard let selectedSong = gameModel.selectedSong?.song else {
                    print("No song selected")
                    playing = false
                    return
                }
                do {
                    try await play(selectedSong)
                } catch {
                    print("Error playing song: \(error)")
                    playing = false
                }
            default:
                print("Music authorization not granted")
                playing = false // Revert playing state if we cannot play the music
            }
        } else {
            // Pause the music player
            musicPlayer.pause()
            print("Music playback paused")
        }
    }
}
