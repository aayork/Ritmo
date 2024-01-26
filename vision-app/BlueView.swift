//
//  BlueView.swift
//  vision-app
//
//  Created by Max Pelot on 1/26/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct BlueView: View {
    var body: some View {
        ZStack {
            Color.blue
            VStack {
                Model3D(named: "Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 45)
                
                Text("Hi Team! Can't wait to get started with this new app -Max")
                    .font(.extraLargeTitle)
                    .opacity(1.0)
                    .padding(.horizontal, 50)
                HStack {
                    Button {
                        
                    } label: {
                        Label("", systemImage: "backward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.large)
                    Button {
                    } label: {
                        Label("", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.large)
                    Button {
                    } label: {
                        Label("", systemImage: "forward.fill")
                    }
                    .buttonStyle(.borderless)
                    .controlSize(.large)
                }
            }
        }
    }
}

#Preview {
    BlueView()
}
