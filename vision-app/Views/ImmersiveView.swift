//
//  ImmersiveView.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var audioController: AudioPlaybackController?
    
    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "Immersive", in:
                realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            content.add(entity)
        }
    }
}

#Preview {
    ImmersiveView()
}

