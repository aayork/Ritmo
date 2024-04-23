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
    @EnvironmentObject var gameModel: GameModel
    @State private var searchText = ""
    @State private var songs = [Item]()
    @State var highScore = 0
    @State var listedSong: Item?
    
    var body: some View {
        ZStack {
            Color.ritmoBlue.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            NavigationSplitView {
                List(songs, selection: $listedSong) { song in
                    Button(action: {
                        listedSong = song
                        gameModel.selectedSong = listedSong
                    })
                    {
                        HStack {
                            ArtworkImage(song.artwork, width: 100)
                                .cornerRadius(10)
                            VStack(alignment: .leading) {
                                Text(song.name).font(.custom("FormaDJRMicro-Bold", size: 18.0))
                                    .foregroundStyle(Color("ritmoWhite"))
                                Text(song.artist).font(.custom("FormaDJRMicro-light", size: 14.0))
                                    .foregroundStyle(Color("ritmoWhite"))
                            }
                            if (gameModel.immsersiveView?.testJSON(song: "\(song.name) \(song.artist)") != nil) {
                                Image("ritmoYellowStar")
                                    .shadow(color: .electricLime, radius: 10)
                                    .offset(x: 20)
                            }
                        }
                        .padding()
                    }
                }
            } detail: {
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
                        if let song = gameModel.selectedSong {
                            HStack {
                                ArtworkImage(song.artwork, width: 400)
                                    .cornerRadius(20)
                                    .position(x:250, y:-25)
                                VStack() {
                                    
                                    Text(song.name) // Display song name
                                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                                        .foregroundStyle(Color("electricLime"))
                                    Text(song.artist).font(.custom("FormaDJRMicro-Medium", size: 25.0)) // Display artist name
                                    
                                    // Play controls
                                    HStack {
                                        Button("START", action: {
                                            Task {
                                                gameModel.musicView = self
                                                gameModel.recentlyPlayed.addSong(song: gameModel.selectedSong!)
                                                gameModel.curated = gameModel.immsersiveView?.testJSON(song: "\(song.name) \(song.artist)") != nil
                                                await openImmersiveSpace(id: "ImmersiveSpace")
                                                DispatchQueue.main.async {
                                                    self.searchText = "" // Reset searchText to force onChange detection
                                                    self.listedSong = nil
                                                }
                                            }
                                        })
                                        .buttonStyle(PlayButtonStyle())
                                        .offset(x: 40)
                                        Spacer()
                                    }
                                }
                                .frame(width: 300)
                                .position(x:195, y: -10)
                                .padding()
                                
                            }
                        } else {
                            Text("Please search for a song...")
                                .font(.custom("FormaDJRMicro-Medium", size: 25.0))
                                .position(x:475, y:-25)
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
            }
            .searchable(text: $searchText)
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: searchText) {
                fetchMusic()
            }
        }
    } // View
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
        request.limit = 25
        return request
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
        .environmentObject(GameModel().self)
}
