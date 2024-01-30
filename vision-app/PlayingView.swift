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
    
    @State var songTitle = "01 Closing Time"
    
    @State var artistName = "Not Playing"
    
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 45)
                
                Text(songTitle)
                    .font(.extraLargeTitle)
                    .opacity(1.0)
                    .padding(.horizontal, 50)
                Text(artistName)
                    .font(.subheadline)
                    .opacity(0.5)
                HStack {
                    Button {
                        if (playing == true) {
                            pauseMusic();
                            playing.toggle();
                        }
                        songTitle = cycleLeft()
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
