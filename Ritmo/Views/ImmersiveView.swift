//
//  ImmersiveView.swift
//  Ritmo
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(GameModel.self) var gameModel
    @ObservedObject var gestureModel: HandTracking
    @State var score = 0
    @State private var correctTime = false;
    @State private var x = Entity()
    @State private var y = Entity()
    @State private var z = Entity()
    @State private var handSpheres = [Entity()]
    
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
       RealityView { content in
           //gestureModel.isFistL()
           content.add(orbSpawner)
           
//           let sphere = MeshResource.generateSphere(radius: 0.01)
//           let material = SimpleMaterial(color: .black, isMetallic: false)
//           handSphere = ModelEntity(mesh: sphere, materials: [material])
//           content.add(handSphere)
           
           for i in 1...46 {
               let sphere = MeshResource.generateSphere(radius: 0.01)
               let material = SimpleMaterial(color: .black, isMetallic: false)
               handSpheres.append(ModelEntity(mesh: sphere, materials: [material]))
               content.add(handSpheres[i])
           }
           
           let sphereX = MeshResource.generateSphere(radius: 0.01)
           let materialX = SimpleMaterial(color: .red, isMetallic: false)
           x = ModelEntity(mesh: sphereX, materials: [materialX])
           content.add(x)
           
           let sphereY = MeshResource.generateSphere(radius: 0.01)
           let materialY = SimpleMaterial(color: .green, isMetallic: false)
           y = ModelEntity(mesh: sphereY, materials: [materialY])
           content.add(y)
           
           let sphereZ = MeshResource.generateSphere(radius: 0.01)
           let materialZ = SimpleMaterial(color: .blue, isMetallic: false)
           z = ModelEntity(mesh: sphereZ, materials: [materialZ])
           content.add(z)
           
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                        fatalError("Unable to load immersive model")
                    }
           content.add(immersiveEntity)
           
           Task {
               openWindow(id: "scoreView")
               dismissWindow(id: "windowGroup")
           }
            
       } update: { updateContent in
           
           gestureModel.isFistL()
           
           guard let hands = gestureModel.getHands()
           else {
               print("hand positions not found")
               return
           }
           
           let leftHand = hands[0]
           let rightHand = hands[1]
           
           let jointPositions: [SIMD3<Float>] = [
            leftHand.thumbIntermediateBase,
            leftHand.thumbIntermediateTip,
            leftHand.thumbKnuckle,
            leftHand.thumbTip,
            leftHand.indexFingerIntermediateBase,
            leftHand.indexFingerIntermediateTip,
            leftHand.indexFingerKnuckle,
            leftHand.indexFingerMetacarpal,
            leftHand.indexFingerTip,
            leftHand.middleFingerIntermediateBase,
            leftHand.middleFingerIntermediateTip,
            leftHand.middleFingerKnuckle,
            leftHand.middleFingerMetacarpal,
            leftHand.middleFingerTip,
            leftHand.ringFingerIntermediateBase,
            leftHand.ringFingerIntermediateTip,
            leftHand.ringFingerKnuckle,
            leftHand.ringFingerMetacarpal,
            leftHand.ringFingerTip,
            leftHand.littleFingerIntermediateBase,
            leftHand.littleFingerIntermediateTip,
            leftHand.littleFingerKnuckle,
            leftHand.littleFingerMetacarpal,
            leftHand.littleFingerTip,
               
            rightHand.thumbIntermediateBase,
            rightHand.thumbIntermediateTip,
            rightHand.thumbKnuckle,
            rightHand.thumbTip,
            rightHand.indexFingerIntermediateBase,
            rightHand.indexFingerIntermediateTip,
            rightHand.indexFingerKnuckle,
            rightHand.indexFingerMetacarpal,
            rightHand.indexFingerTip,
            rightHand.middleFingerIntermediateBase,
            rightHand.middleFingerIntermediateTip,
            rightHand.middleFingerKnuckle,
            rightHand.middleFingerMetacarpal,
            rightHand.middleFingerTip,
            rightHand.ringFingerIntermediateBase,
            rightHand.ringFingerIntermediateTip,
            rightHand.ringFingerKnuckle,
            rightHand.ringFingerMetacarpal,
            rightHand.ringFingerTip,
            rightHand.littleFingerIntermediateBase,
            rightHand.littleFingerIntermediateTip,
            rightHand.littleFingerKnuckle,
            rightHand.littleFingerMetacarpal,
            rightHand.littleFingerTip
           ]
           
           for i in 0...jointPositions.count - 1 {
               handSpheres[i].transform.translation = jointPositions[i]
           }
           
           x.transform.translation = leftHand.x
           y.transform.translation = leftHand.y
           z.transform.translation = leftHand.z
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
       .task {
           await gestureModel.start()
       }
       .task {
           await gestureModel.publishHandTrackingUpdates()
       }
       .task {
           await gestureModel.monitorSessionEvents()
       }
       .preferredSurroundingsEffect(.systemDark)
   }
}
