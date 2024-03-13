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
    
    func spawnHand() {
        // Import entity from RealityKit package
        let importEntity = try? Entity.load(named: "RubberGlove", in: realityKitContentBundle)
        
        // Create circle around the sphere
        let circle = MeshResource.generateCylinder(height: 0.01, radius: 0.2)
        let white = SimpleMaterial(color: .white, isMetallic: false)
        let circleEntity = ModelEntity(mesh: circle, materials: [white])
        
        // Instantiate parent hand
        let hand = ModelEntity()
        
        // Make the sphere and circle a child of the hand
        importEntity!.addChild(circleEntity)
        hand.addChild(importEntity!)
        
        // Position the sphere entity above the ground or any reference point
        importEntity!.transform = Transform(pitch: Float.pi / 2, yaw: 0.0, roll: 0.0) // Set the sphere to face the camera
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
           content.add(orbSpawner)
           
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                        fatalError("Unable to load immersive model")
                    }
           content.add(immersiveEntity)
           
           Task {
               dismissWindow(id: "windowGroup")
           }
       }
       .onReceive(timer) {time in
           spawnHand()
       }
       
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
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
