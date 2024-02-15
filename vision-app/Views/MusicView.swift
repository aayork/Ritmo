//
//  MusicView.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MusicView: View {
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    /// This isn't the original immersive space I created, I've been having trouble getting spatial audio to work with RealityKit. Something weird with setting element values.
    @State private var playing = false
    @State var songTitle = "Not Playing"
    
    var body: some View {
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

#Preview {
    MusicView()
}
