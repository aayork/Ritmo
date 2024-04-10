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
    let genres: [String]
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
                        if (gameModel.immsersiveView?.testJSON(songName: song.name) != nil) {
                            Image("ritmoStar")
                                .shadow(color: .blue, radius: 10)
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
                            ZStack {
                                WaveAnimation()
                                Text("Pick a Tune")
                                    .font(.custom("Soulcraft_Wide", size: 70.0))
                                    .foregroundColor(Color.ritmoWhite)
                                    .padding()
                                    .offset(x: -195, y: 150)
                            }
                            .frame(height: 400)
                            .clipShape(Rectangle())
                        }
                    }
                    .offset(y: -250)
                    Spacer()
                    HStack {
                        Spacer()
                        if let song = selectedSong {
                            HStack {
                                ArtworkImage(song.artwork, width: 400)
                                    .cornerRadius(20)
                                    .position(x:250, y:-25)
                                VStack() {
                                
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
                                        Button("START", action: {
                                            Task {
                                                gameModel.musicView = self
                                                gameModel.recentlyPlayed.addSong(song: selectedSong!)
                                                gameModel.curated = gameModel.immsersiveView?.testJSON(songName: song.name) != nil
                                                await openImmersiveSpace(id: "ImmersiveSpace")
                                            }
                                        })
                                        .buttonStyle(PlayButtonStyle())
                                        .offset(x: 40)
                                        Spacer()
                                    }
                                }
                                .frame(width: 300)
                                .position(x:110, y:25)
                                .padding()
                                        
                            }
                        } else {
                            Text("Please search for a song...")
                                .position(x:475, y:-25)
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
            do {
                try await play(selectedSong!.song)
            } catch {
                print("Error")
            }
        } else {
            print("Paused \(selectedSong?.name ?? "song")")
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
                    self.songs = result.songs.compactMap { song in
                        return Item(name: song.title, artist: song.artistName, song: song.self, artwork: song.artwork!, duration: song.duration! * 1000, genres: song.genreNames)
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
    
    struct PlayButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.custom("Soulcraft_Wide", size: 50.0))
                .padding()
                .background(Rectangle().fill(Color.electricLime))
                .hoverEffect()
                .cornerRadius(20)
                .foregroundStyle(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: configuration.isPressed ? 3 : 0)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}

#Preview {
    MusicView()
        .environment(GameModel().self)
}
