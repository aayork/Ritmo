//
//  Instruments.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Instruments: View {
    
    @State var enlarge = false
    
    var body: some View {
        VStack {
            RealityView { content in
                
                if let scene = try? await Entity(named: "GlassCube", in:
                                                    realityKitContentBundle) {
                    content.add(scene)
                }
                } update: { content in
                    if let scene = content.entities.first {
                        let uniformScale: Float = enlarge ? 1.4 : 1.0
                        scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                    }
                }
                .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                    enlarge.toggle()
                })
                
                VStack {
                    Toggle("Enlarge RealityView Content", isOn: $enlarge)
                        .toggleStyle(.button)
                }
                .padding()
                .glassBackgroundEffect()
                }
            }
        }

#Preview {
    Instruments()
}
