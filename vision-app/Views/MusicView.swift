//
//  MusicView.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
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
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var playing = false
    @State private var songTitle = "Not Playing"
    @State private var songs = [Item]()
    
    var body: some View {
        NavigationSplitView {
            List(songs) { song in
                HStack {
                    AsyncImage(url: song.imageURL)
                        .frame(width: 75, height: 75)
                    VStack(alignment: .leading) {
                        Text(song.name).font(.title3)
                        Text(song.artist).font(.footnote)
                    }
                }
            }
        } detail: {
            // Detail view content here
        }
        .onAppear {
            fetchMusic()
        }
        
        VStack {
            Text("About This Song").font(.title)
            Text("").ornament(visibility: .visible, attachmentAnchor: .scene(.bottom), contentAlignment: .center) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                    
                    Button(action: {
                        Task {
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        }
                        playing = true
                    }) {
                        Image(systemName: playing ? "pause.fill" : "play.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                    
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                }
                .labelStyle(.iconOnly)
                .padding(.vertical)
                .padding(.horizontal)
                .glassBackgroundEffect()
            }
        }
    }
    
    private var request: MusicCatalogSearchRequest {
        var request = MusicCatalogSearchRequest(term: "Happy", types: [Song.self])
        request.limit = 25
        return request
    }
    
    private func fetchMusic() {
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
