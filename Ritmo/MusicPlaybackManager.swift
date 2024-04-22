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
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @EnvironmentObject var gameModel: GameModel
    @State private var searchText = ""
    @State private var songs = [Item]()
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
    
    func togglePlayPause() async  {
        print("PlAYPAUSE")
        playing.toggle()
        if playing {
            print("Playing \(gameModel.selectedSong?.name ?? "song")")
            do {
                try await play(gameModel.selectedSong!.song)
            } catch {
                print("Error")
            }
        } else {
            print("Paused \(gameModel.selectedSong?.name ?? "song")")
            musicPlayer.pause()
        }
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
        request.limit = 25
        return request
    }
    
    @MainActor
    private func play<I: PlayableMusicItem>(_ item: I) async throws {
        musicPlayer.queue = [item]
        try await musicPlayer.play()
    }
    
    public func getSongName() -> String {
        return gameModel.selectedSong?.name ?? "No Song Selected"
    }
    
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
    
    private func fetchMusic() {
        print(searchText)
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
}
