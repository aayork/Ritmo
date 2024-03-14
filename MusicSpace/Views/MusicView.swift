//
//  MusicView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI
import MusicKit
import RealityKit
import RealityKitContent

struct Item: Identifiable, Hashable, Codable {
    var id = UUID()
    let name: String
    let artist: String
    let song: Song // This is the playable music item
    let artwork: Artwork
}

struct MusicView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var searchText = ""
    @State private var playing = false
    @State private var songs = [Item]()
    @State private var selectedSong: Item?
    let musicPlayer = ApplicationMusicPlayer.shared
    
    var body: some View {
        NavigationSplitView {
            List(songs, selection: $selectedSong) { song in
                Button(action: {
                    self.selectedSong = song
                })
                {
                    HStack {
                        ArtworkImage(song.artwork, width: 75)
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            Text(song.name).font(.headline)
                            Text(song.artist).font(.subheadline)
                        }
                    }
                    .padding()
                }
            }
        } detail: {
            if let song = selectedSong { // Step 3: Update detail view for selected song
                VStack {
                    HStack {
                        Text("Play Now").font(.title)
                        if true {
                            Text("Curated")
                                .padding(8)
                                .background(Color.pink)
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                        }
                        
                        // Difficulty indicator
                        Text("Medium")
                            .padding(8)
                            .background(difficultyColor(for: "Medium"))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                    HStack {
                        ArtworkImage(song.artwork, width: 400)
                                        .cornerRadius(10)
                        
                        VStack {
                            Text(song.name).font(.headline) // Display song name
                            Text(song.artist).font(.subheadline) // Display artist name
                        }
                        .padding(.horizontal)
                        // Play controls
                        HStack {
                            Button(action: {
                                Task {
                                    await togglePlaying()
                                    await openImmersiveSpace(id: "ImmersiveSpace")
                                }
                            }) {
                                Image(systemName: playing ? "pause.fill" : "play.fill")
                                    .padding()
                                    .background(Circle().fill(Color.green))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.largeTitle)
                            .cornerRadius(360)
                        }
                    }
                    .padding()
                    
                    
                }
            } else {
                Text("Select a song to see details") // Prompt user to select a song
            }
        }
        .searchable(text: $searchText)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: searchText, initial: true) { oldValue, newValue in
            fetchMusic()
        }
    } // View
    
    
    // Helper function to determine the color of the difficulty indicator
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "Easy":
            return Color.green
        case "Medium":
            return Color.orange
        case "Hard":
            return Color.red
        default:
            return Color.gray
        }
    }
    
    private func togglePlayPause() async {
        playing.toggle()
        if playing {
            print("Playing \(selectedSong?.name ?? "song")")
            // Add your code to play music here
            do {
                try await play(selectedSong!.song)
            } catch {
                print("Error")
            }
        } else {
            print("Paused \(selectedSong?.name ?? "song")")
            // Add code to pause music here
        }
    }
    
    private func playPreviousSong() {
        if let currentSongIndex = songs.firstIndex(where: { $0.id == selectedSong?.id }), currentSongIndex > 0 {
            let previousSongIndex = songs.index(before: currentSongIndex)
            selectedSong = songs[previousSongIndex]
            print("Playing previous song: \(songs[previousSongIndex].name)")
            // Add code to play the previous song here
        }
    }
    
    private func playNextSong() {
        if let currentSongIndex = songs.firstIndex(where: { $0.id == selectedSong?.id }), currentSongIndex < songs.count - 1 {
            let nextSongIndex = songs.index(after: currentSongIndex)
            selectedSong = songs[nextSongIndex]
            print("Playing next song: \(songs[nextSongIndex].name)")
            // Add code to play the next song here
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
        return selectedSong?.name ?? "No Song Selected"
    }
    
    private func togglePlaying() async {
        // Toggle the playing state
        playing.toggle()
        // Check if there's a selected song and the playing state
        if let item = selectedSong {
            if playing {
                // Request music authorization
                let status = await MusicAuthorization.request()
                switch status {
                case .authorized:
                    // If authorized, play the selected song
                    do {
                                    try await play(item.song)
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
        } else {
            print("No song selected")
            playing = false // Revert playing state as there's no selection
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
                    self.songs = result.songs.compactMap {
                        Item(name: $0.title, artist: $0.artistName, song: $0.self, artwork: $0.artwork!)
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


#Preview {
    MusicView()
}
