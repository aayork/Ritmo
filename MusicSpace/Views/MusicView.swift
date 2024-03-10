//
//  MusicView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/10/24.
//
// This should work but I can't test without visionOS hardware.
//

import SwiftUI
import MusicKit
import RealityKit
import RealityKitContent

struct Item: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let artist: String
    let imageURL: URL?
}

struct MusicView: View {
    @State private var searchText = ""
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var playing = false
    @State private var songs = [Item]()
    @State private var selectedSong: Item?
    private let musicPlayer = ApplicationMusicPlayer.shared
    @State var musicSubscription: MusicSubscription?
    
    var body: some View {
        NavigationSplitView {
            List(songs, selection: $selectedSong) { song in // Bind selection to selectedSong
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 75, height: 75)
                    VStack(alignment: .leading) {
                        Text(song.name).font(.title3)
                        Text(song.artist).font(.footnote)
                    }
                }
                .onTapGesture {
                    self.selectedSong = song // Step 2: Set selected song on tap
                }
            }
        } detail: {
            if let song = selectedSong { // Step 3: Update detail view for selected song
                    VStack {
                        Text("Play Now").font(.title)
                        Text(song.name).font(.headline) // Display song name
                        Text(song.artist).font(.subheadline) // Display artist name
                        AsyncImage(url: song.imageURL) // Display song image if available
                            .frame(width: 150, height: 150)
                                
                        // Play controls
                        HStack {
                                Button(action: {
                                    Task {
                                        await togglePlaying()
                                        await openImmersiveSpace(id: "ImmersiveSpace")
                                    }
                                }) {
                                    Image(systemName: playing ? "pause.fill" : "play.fill")
                                }
                                .buttonStyle(.borderless)
                                .controlSize(.large)
                            }
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
                // If we are going to play, check if the music subscription allows playing
                if musicSubscription?.canPlayCatalogContent == true {
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
                    print("You are not an Apple Music subscriber.")
                    playing = false // Revert playing state as user cannot play the content
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
