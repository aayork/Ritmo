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
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 45)
                
                Text("SICKO MODE")
                    .font(.extraLargeTitle)
                    .opacity(1.0)
                    .padding(.horizontal, 50)
                Text("Travis Scott")
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
                        playMusic()
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
