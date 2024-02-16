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
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
               fatalError("Unable to load immersive model")
           }
           
           let spatialAudioEntity = immersiveEntity.findEntity(named: "AcousticGuitar")
           spatialAudioEntity?.spatialAudio = SpatialAudioComponent()
        
           guard let resource = try? await AudioFileResource(named: "/Root/back_on_74_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           audioController = spatialAudioEntity?.prepareAudio(resource)
           audioController?.play()
           
           // Add the immersiveEntity to the scene
           content.add(immersiveEntity)
           
           // Create a floating sphere
           let sphere = MeshResource.generateSphere(radius: 0.1) // Sphere with radius of 0.1 meters
           let sphereMaterial = SimpleMaterial(color: .blue, isMetallic: false)
           let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
           
           // Position the sphere entity above the ground or any reference point
           sphereEntity.position = [0, 1, -1] // Adjust the Y value to float the sphere
           
           // Add interaction - assuming RealityKit 2.0 for gestures handling, add if needed
           sphereEntity.components.set(InputTargetComponent())
           sphereEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
           
           Task {
               // Move the sphere automatically
               var moveItMoveIt = sphereEntity.transform
               moveItMoveIt.translation += SIMD3(0, 0, 1)
               sphereEntity.move(to: moveItMoveIt, relativeTo: nil, duration: 5,timingFunction: .default)
           }

           // Make the orb cast a shadow.
           sphereEntity.components.set(GroundingShadowComponent(castsShadow: true))
           // content.installGestures([.rotation, .translation], for: sphereEntity)
           
           // Add the sphere entity to the scene
           content.add(sphereEntity)
       }
       .onDisappear(perform: {
           audioController?.stop()
       })
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           var transform = value.entity.transform
           transform.translation += SIMD3(0.1, 0, -0.1)
           value.entity.move(
            to: transform,
           relativeTo: nil,
            duration: 3,
            timingFunction: .easeInOut
           )
       }))
   }
}

