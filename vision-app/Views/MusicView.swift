//
//  MusicView.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Song: Identifiable {
    var id = UUID()
    var title: String
    var artist: String
}


struct MusicView: View {
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    /// This isn't the original immersive space I created, I've been having trouble getting spatial audio to work with RealityKit. Something weird with setting element values.
    @State private var playing = false
    @State var songTitle = "Not Playing"
    @State private var librarySongs: [Song] = [
        Song(title: "Song 1", artist: "Artist 1"),
        Song(title: "Song 2", artist: "Artist 2"),
        Song(title: "Song 3", artist: "Artist 3"),
        Song(title: "Song 4", artist: "Artist 4"),
        Song(title: "Song 5", artist: "Artist 5"),
        Song(title: "Song 6", artist: "Artist 6"),
    ]
    
    
    var body: some View {
     
            NavigationSplitView {
                Text("Library")
                    .font(.title)
                    .padding(.bottom)
                ScrollView {
                    LazyVStack {
                        ForEach(librarySongs) { song in
                            HStack {
                                Text("\(song.title) - \(song.artist)")
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                    // Handle play button action
                                    print("Play \(song.title)")
                                }) {
                                    Image(systemName: "play.circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding()
                                .background(Color.clear.opacity(0.8))
                                .cornerRadius(10)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
            } detail: {
            VStack {
                
                Text("Experience Spatial Audio!")
                    .font(.title)
                Text("Song Name")
                    .font(.title3)
                
                Text("")
                    .ornament(
                        visibility: .visible,
                        attachmentAnchor: .scene(.bottom),
                        contentAlignment: .center
                    ) {
                        HStack {
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "backward.fill")
                            }
                            .buttonStyle(.borderless)
                            .controlSize(.extraLarge)
                            Button {
                                Task {
                                    await openImmersiveSpace(id: "ImmersiveSpace")
                                }
                                playing = true
                            } label: {
                                Image(systemName: playing ? "pause.fill" : "play.fill")
                            }
                            .buttonStyle(.borderless)
                            .controlSize(.extraLarge)
                            Button {
                                
                            } label: {
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
    }
}

#Preview {
    MusicView()
}
