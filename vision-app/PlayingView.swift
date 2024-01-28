//
//  BlueView.swift
//  vision-app
//
//  Created by Max Pelot on 1/26/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct PlayingView: View {
    @State private var playing = false
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 45)
                
                Text("song_title")
                    .font(.extraLargeTitle)
                    .opacity(1.0)
                    .padding(.horizontal, 50)
                Text("artist_name")
                    .font(.subheadline)
                    .opacity(0.5)
                HStack {
                    Button {
                        
                    } label: {
                        Label("", systemImage: "backward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                    Button {
                        if (playing == false) {
                            playMusic();
                            playing = true;
                        } else {
                            pauseMusic();
                            playing = false;
                        }
                    } label: {
                        Label("", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                    Button {
                    } label: {
                        Label("", systemImage: "forward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.extraLarge)
                }
            }
        }
    }
}

#Preview {
    PlayingView()
}
