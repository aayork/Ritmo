//
//  MusicView.swift
//  Ritmo
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
    let duration: TimeInterval
    let genre: MusicItemCollection<Genre>?
}

struct MusicView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(GameModel.self) var gameModel
    @State private var searchText = ""
    @State private var songs = [Item]()
    @State var selectedSong: Item?
    @State var playing = false
    @State var highScore = 0
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
            //if let song = selectedSong { // Step 3: Update detail view for selected song
                VStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        HStack {
                            Text("Pick a Tune")
                                .font(.custom("Soulcraft_Wide", size: 70.0))
                                .foregroundColor(Color.black)
                                .padding()
                            Spacer()
                        }
                    }
                    .frame(height: 150, alignment: .leading)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.electricLime)
                    HStack {
//                        Text("Curated")
//                             .padding(8)
//                             .background(Color.pink)
//                             .clipShape(Capsule())
//                             .foregroundColor(.white)
//
//                        
//                        // Difficulty indicator
//                        Text("Medium")
//                            .padding(8)
//                            .background(difficultyColor(for: "Medium"))
//                            .clipShape(Capsule())
//                            .foregroundColor(.white)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        if let song = selectedSong {
                            HStack {
                                ArtworkImage(song.artwork, width: 400)
                                    .cornerRadius(50)
                                    .position(x:250, y:225)
                                VStack(alignment: .leading) {
                                
                                    Text(song.name) // Display song name
                                        .font(.system(size: 35, weight: .heavy))
                                        .foregroundStyle(Color("electricLime"))
                                    Text(song.artist).font(.system(size: 25)) // Display artist name
                                
                                
                                
                                    Text("High Score: ")
                                        .font(.system(size: 20))
                                    Text(String(highScore))
                                        .font(.system(size: 30))
                                        .foregroundStyle(Color("electricLime"))
                                
                                    // Play controls
                                    HStack {
                                        Button(action: {
                                            Task {
                                                gameModel.musicView = self
                                                //gameModel.selectedSong = self.selectedSong
                                                //gameModel.togglePlayPause = self.togglePlayPause
                                                gameModel.recentlyPlayed.addSong(song: selectedSong!)
                                                // await togglePlaying()
                                                await openImmersiveSpace(id: "ImmersiveSpace")
                                            }
                                        }) {
                                            Text("Start")
                                            .padding()
                                            .background(Rectangle().fill(Color.green))
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .font(.extraLargeTitle)
                                        .cornerRadius(20)
                                    }
                                }
                                .frame(width: 300)
                                .position(x:110, y:225)
                                .padding()
                            }
                        } else {
                            Text("Please search for a song...")
                                .position(x:485, y:225)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            
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
    
    func togglePlayPause() async  {
        print("PlAYPAUSE")
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
    
    func togglePlaying() async {
        // Toggle the playing state
        playing.toggle()
        print(playing)
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
                        // RecentlyPlayedManager.addSong(<#RecentlyPlayedManager#>)
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
                        Item(name: $0.title, artist: $0.artistName, song: $0.self, artwork: $0.artwork!, duration: $0.duration!, genre: $0.genres)
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
        .environment(GameModel().self)
}

