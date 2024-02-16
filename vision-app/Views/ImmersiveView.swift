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
    @State private var audioControllerGuitar: AudioPlaybackController?
    @State private var audioControllerDrums: AudioPlaybackController?
    @State private var audioControllerVocals: AudioPlaybackController?
    
    @Environment(\.dismissWindow) private var dismissWindow
   
   var body: some View {
       
       RealityView { content in
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
               fatalError("Unable to load immersive model")
           }
           
           let spatialAudioEntityGuitar = immersiveEntity.findEntity(named: "AcousticGuitar")
           spatialAudioEntityGuitar?.spatialAudio = SpatialAudioComponent()
           
           let spatialAudioEntityDrums = immersiveEntity.findEntity(named: "DrumKit")
           spatialAudioEntityDrums?.spatialAudio = SpatialAudioComponent()
           
           let spatialAudioEntityVocals = immersiveEntity.findEntity(named: "MovieBoomMicrophone")
           spatialAudioEntityVocals?.spatialAudio = SpatialAudioComponent()
        
           guard let instrumentResource = try? await AudioFileResource(named: "/Root/instruments_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           guard let drumsResource = try? await AudioFileResource(named: "/Root/drums_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           guard let vocalsResource = try? await AudioFileResource(named: "/Root/vocals_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           audioControllerGuitar = spatialAudioEntityGuitar?.prepareAudio(instrumentResource)
           audioControllerDrums = spatialAudioEntityDrums?.prepareAudio(drumsResource)
           audioControllerVocals = spatialAudioEntityDrums?.prepareAudio(vocalsResource)
           audioControllerGuitar?.play()
           audioControllerDrums?.play()
           audioControllerVocals?.play()
           // Add the immersiveEntity to the scene
           content.add(immersiveEntity)
           
           // Create a floating sphere
           let sphere = MeshResource.generateSphere(radius: 0.1) // Sphere with radius of 0.1 meters
           let sphereMaterial = SimpleMaterial(color: .blue, isMetallic: false)
           let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
           
           // Position the sphere entity above the ground or any reference point
           sphereEntity.position = [0, 1.25, -1] // Adjust the Y value to float the sphere
           
           // Add interaction - assuming RealityKit 2.0 for gestures handling, add if needed
           sphereEntity.components.set(InputTargetComponent())
           sphereEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
           
           Task {
               dismissWindow(id: "windowGroup")
               // Move the sphere automatically
               var moveItMoveIt = sphereEntity.transform
               moveItMoveIt.translation += SIMD3(0, 1.5, 1)
               sphereEntity.move(to: moveItMoveIt, relativeTo: nil, duration: 5,timingFunction: .default)
           }

           // Make the orb cast a shadow.
           sphereEntity.components.set(GroundingShadowComponent(castsShadow: true))
           // content.installGestures([.rotation, .translation], for: sphereEntity)
           
           // Add the sphere entity to the scene
           content.add(sphereEntity)
       }
       .onDisappear(perform: {
           audioControllerGuitar?.stop()
           audioControllerDrums?.stop()
       })
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           value.entity.removeFromParent()
           
//           var transform = value.entity.transform
//           transform.translation += SIMD3(0.1, 0, -0.1)
//           value.entity.move(
//            to: transform,
//           relativeTo: nil,
//            duration: 3,
//            timingFunction: .easeInOut
//           )
       }))
   }
}

