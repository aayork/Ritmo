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
           
           // Create circle around the sphere
           let circle = MeshResource.generateCylinder(height: 0.01, radius: 0.2)
           let circleMaterial = SimpleMaterial(color: .white, isMetallic: false)
           let circleEntity = ModelEntity(mesh: circle, materials: [circleMaterial])
           
           let pose = ModelEntity()
           
           // Make the sphere and circle a child of the pose
           sphereEntity.addChild(circleEntity)
           pose.addChild(sphereEntity)
           
           // Position the sphere entity above the ground or any reference point
           sphereEntity.transform = Transform(pitch: Float.pi / 2, yaw: 0.0, roll: 0.0) // Set the sphere to face the camera
           pose.position = [0, 1.5, -5] // Adjust the Y value to float the pose
           
           // Add interaction - assuming RealityKit 2.0 for gestures handling, add if needed
           pose.components.set(InputTargetComponent())
           pose.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
           
           Task {
               dismissWindow(id: "windowGroup")
               // Move the sphere automatically
               var moveItMoveIt = pose.transform
               moveItMoveIt.translation += SIMD3(0, 0, 5)
               pose.move(to: moveItMoveIt, relativeTo: nil, duration: 5, timingFunction: .default)
               var scaleTransform: Transform = Transform()
               scaleTransform.scale = SIMD3(0.5, 0.5, 0.5)
               circleEntity.move(to: circleEntity.transform, relativeTo: circleEntity.parent)
               circleEntity.move(to: scaleTransform, relativeTo: circleEntity.parent, duration: 5)
           }

           // Make the orb cast a shadow.
           pose.components.set(GroundingShadowComponent(castsShadow: true))
           // content.installGestures([.rotation, .translation], for: sphereEntity)
           
           // Add the sphere entity to the scene
           content.add(pose)
       }
       .onDisappear(perform: {
           audioControllerGuitar?.stop()
           audioControllerDrums?.stop()
           audioControllerVocals?.stop()
       })
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           value.entity.removeFromParent()
       }))
   }
}

