//
//  ImmersiveView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(GameModel.self) var gameModel
    @State var score = 0
    @State private var correctTime = false;
    
    let orbSpawner = Entity()
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let handTravelTime = 4.0 // The time it takes the hand to reach the player
    let acceptInputWindow = 0.8 // The time window in which the player can successfully match a gesture
    
    // @State private var audioControllerGuitar: AudioPlaybackController?
    // @State private var audioControllerDrums: AudioPlaybackController?
    // @State private var audioControllerVocals: AudioPlaybackController?
    
    func spawnHand() {
        // Create a floating sphere
        let sphere = MeshResource.generateSphere(radius: 0.05) // Sphere with radius of 0.1 meters
        let black = SimpleMaterial(color: .black, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphere, materials: [black])
        
        // Hand
        // let glassHand = try? Entity.load(named: "handwork")
        
        // Create circle around the sphere
        let circle = MeshResource.generateCylinder(height: 0.01, radius: 0.2)
        let white = SimpleMaterial(color: .white, isMetallic: false)
        let circleEntity = ModelEntity(mesh: circle, materials: [white])
        
        // Instantiate parent hand
        let hand = ModelEntity()
        
        // Make the sphere and circle a child of the hand
        sphereEntity.addChild(circleEntity)
        hand.addChild(sphereEntity)
        
        // Position the sphere entity above the ground or any reference point
        sphereEntity.transform = Transform(pitch: Float.pi / 2, yaw: 0.0, roll: 0.0) // Set the sphere to face the camera
        // glassHand!.transform = Transform(pitch: Float.pi / 2, yaw: 0.0, roll: 0.0) // Set the sphere to face the camera
        hand.position = [0, 1.3, -5] // Adjust the Y value to float the hand
        
        // Add interaction - assuming RealityKit 2.0 for gestures handling, add if needed
        hand.components.set(InputTargetComponent())
        hand.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
        
        // Make the orb cast a shadow
        hand.components.set(GroundingShadowComponent(castsShadow: true))
        
        // Attach the orb to the spawner
        orbSpawner.addChild(hand)
    
        // Set hand to move towards player and the circle indicator to shrink
        var moveItMoveIt = hand.transform
        moveItMoveIt.translation += SIMD3(0, 0, 5)
        hand.move(to: moveItMoveIt, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
        var scaleTransform: Transform = Transform()
        scaleTransform.scale = SIMD3(0.25, 0.25, 0.25)
        circleEntity.move(to: circleEntity.transform, relativeTo: circleEntity.parent)
        circleEntity.move(to: scaleTransform, relativeTo: circleEntity.parent, duration: handTravelTime, timingFunction: .linear)
        
        // set correctTime to true during the window
        Task {
            try? await Task.sleep(until: .now + .seconds(handTravelTime - acceptInputWindow / 2), clock: .continuous)
            correctTime = true;
            try? await Task.sleep(until: .now + .seconds(acceptInputWindow), clock: .continuous)
            correctTime = false;
        }
    }
    
    // Attach a sphere with the given color to the given entity
    func changeColor(entity: Entity, color: UIColor) {
        entity.children.removeAll()
        let sphere = MeshResource.generateSphere(radius: 0.05)
        let material = SimpleMaterial(color: color, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        entity.addChild(sphereEntity)
    }
    
   var body: some View {
       // Scoreboard
       ScoreView()
           .environment(self.gameModel)
       
       RealityView { content in
           
           /*
           let rootEntity = Entity()
           
           guard let texture = try? await TextureResource(named: immersiveImageName) else {
               return
           }
           
           var material = UnlitMaterial()
           material.color = .init(texture: .init(texture))
           
           rootEntity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1E3),
            materials: [material]
           ))
           rootEntity.scale *= .init(x: -1, y: 1, z: 1)
           rootEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
           
           content.add(rootEntity)
           
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
            Add the immersiveEntity to the scene
            content.add(immersiveEntity)
           */
           
           //orbSpawner.position = [0, 0, 0]
           content.add(orbSpawner)
           
           Task {
               dismissWindow(id: "windowGroup")
           }
           // content.installGestures([.rotation, .translation], for: sphereEntity)
       }
       .onReceive(timer) {time in
           spawnHand()
       }
       .onDisappear(perform: {
           // audioControllerGuitar?.stop()
           // audioControllerDrums?.stop()
           // audioControllerVocals?.stop()
       })
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           // Change color to green or red
           //value.entity.children.removeAll()
           //let sphere = MeshResource.generateSphere(radius: 0.05) // Sphere with radius of 0.1 meters
           
           if (correctTime) {
               changeColor(entity: value.entity, color: .green)
               gameModel.score += 1
           } else {
               changeColor(entity: value.entity, color: .red)
           }
       }))
       .preferredSurroundingsEffect(.systemDark)
   }
}
