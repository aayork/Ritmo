//
//  LibraryView.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct LibraryView: View {
    
    @State private var playing = false
    // "@State" is a Property wrapper
        
    @State var songTitle = "Not Playing"
        
    @State var artistName = "artist_name"

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        ZStack {
            Color.clear
            
            Color(hue: 0.65, saturation: 0.9, brightness: 1.5, opacity: 0.3)
            
            Text("")
                .ornament(
                    visibility: .visible,
                    attachmentAnchor: .scene(.bottom),
                    contentAlignment: .center
                ) {
                    HStack {
                        Button {
                            if (playing == true) {
                                pauseMusic();
                                playing.toggle();
                            }
                            songTitle = cycleLeft()
                            playMusic()
                            playing = true
                        } label: {
                            Image(systemName: "backward.fill")
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.extraLarge)
                        Button {
                            if (playing == false) {
                                playMusic();
                            } else {
                                pauseMusic();
                            }
                            playing.toggle()
                        } label: {
                            Image(systemName: playing ? "pause.fill" : "play.fill")
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.extraLarge)
                        Button {
                            if (playing == true) {
                                pauseMusic();
                                playing.toggle();
                            }
                            songTitle = cycleRight()
                            playMusic()
                            playing = true
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
            
            
            VStack {
                
                Text(songTitle)
                    .font(.extraLargeTitle)
                    .opacity(1.0)
                    .padding(.horizontal, 50)
                Text(artistName)
                    .font(.subheadline)
                    .opacity(0.5)
                
                Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                    .padding(.top, 50)
            }
            .padding()
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        switch await openImmersiveSpace(id: "ImmersiveSpace") {
                        case .opened:
                            immersiveSpaceIsShown = true
                        case .error, .userCancelled:
                            fallthrough
                        @unknown default:
                            immersiveSpaceIsShown = false
                            showImmersiveSpace = false
                        }
                    } else if immersiveSpaceIsShown {
                        await dismissImmersiveSpace()
                        immersiveSpaceIsShown = false
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
