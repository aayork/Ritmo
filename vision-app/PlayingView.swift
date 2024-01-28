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
                    } label: {
                        Image(systemName: "forward.fill")
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
