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
    let imageURL: URL?
}

struct MusicView: View {
    @State private var searchText = ""
    @Environment(GameModel.self) var gameModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var playing = false
    @State private var songs = [Item]()
    @State private var selectedSong: Item?
    private let musicPlayer = ApplicationMusicPlayer.shared
    
    
    var body: some View {
        NavigationSplitView {
            List(songs, selection: $selectedSong) { song in // Bind selection to selectedSong
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(song.name).font(.headline)
                        Text(song.artist).font(.subheadline)
                    }
                    
                    
                    // Assuming you want these to be in the detail view of the selected item
                    // If you want them in the list, you can adjust accordingly
                }
                .onTapGesture {
                    self.selectedSong = song
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
                        AsyncImage(
                            url: song.imageURL,
                            content: { image in
                                image.resizable()
                                    .frame(maxWidth: 400, maxHeight: 400)
                                    .cornerRadius(25.0)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
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
    
    
    // Example implementations of playback control actions
    private func togglePlayPause() async {
        playing.toggle()
        if playing {
            print("Playing \(selectedSong?.name ?? "song")")
            // Add your code to play music here
            await play(item: selectedSong!)
        } else {
            print("Paused \(selectedSong?.name ?? "song")")
            // Add your code to pause music here
        }
    }
    
    private func playPreviousSong() {
        // Example logic to select the previous song in the list
        if let currentSongIndex = songs.firstIndex(where: { $0.id == selectedSong?.id }), currentSongIndex > 0 {
            let previousSongIndex = songs.index(before: currentSongIndex)
            selectedSong = songs[previousSongIndex]
            print("Playing previous song: \(songs[previousSongIndex].name)")
            // Add your code to play the previous song here
        }
    }
    
    private func playNextSong() {
        // Example logic to select the next song in the list
        if let currentSongIndex = songs.firstIndex(where: { $0.id == selectedSong?.id }), currentSongIndex < songs.count - 1 {
            let nextSongIndex = songs.index(after: currentSongIndex)
            selectedSong = songs[nextSongIndex]
            print("Playing next song: \(songs[nextSongIndex].name)")
            // Add your code to play the next song here
        }
    }
    
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
        request.limit = 25
        return request
    }
    
    func play(item: Item) async {
        var searchRequest = MusicCatalogSearchRequest(term: "\(item.name) \(item.artist)", types: [Song.self])
        searchRequest.limit = 1 // You may adjust this based on how specific your search needs to be
        
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                let response = try await searchRequest.response()
                guard let song = response.songs.first else {
                    print("No matching song found in Apple Music catalog.")
                    return
                }
                // Now that you have a Song, you can proceed with the original play logic
                try await musicPlayer.queue.insert(song, position: .afterCurrentEntry)
                try await musicPlayer.play()
            default:
                print("Music authorization not granted")
            }
        } catch {
            print("Error playing the song: \(error.localizedDescription)")
        }
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
                    await play(item: item)
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
                        Item(name: $0.title, artist: $0.artistName, imageURL: $0.artwork?.url(width: 75, height: 75))
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
