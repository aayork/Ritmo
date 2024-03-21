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
    @State private var xL = Entity()
    @State private var yL = Entity()
    @State private var zL = Entity()
    @State private var xR = Entity()
    @State private var yR = Entity()
    @State private var zR = Entity()
    @State private var handSpheres = [Entity()]
    
    let orbSpawner = Entity()
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let handTravelTime = 4.0 // The time it takes the hand to reach the player
    let acceptInputWindow = 0.8 // The time window in which the player can successfully match a gesture
    
    func spawnHand() {
            // Randomly choose between "Fist_fixed" and "OPENfixed"
            let entityName = Bool.random() ? "Fist_fixed" : "OPENfixed"
        
            let entityTwoName = Bool.random() ? "Fist_fixed" : "OPENfixed"
            
            // Attempt to load the chosen entity
            guard let importEntity = try? Entity.load(named: entityName, in: realityKitContentBundle) else {
                print("Failed to load entity: \(entityName)")
                return
            }
        
            guard let importEntityTwo = try? Entity.load(named: entityTwoName, in: realityKitContentBundle) else {
                print("Failed to load entity: \(entityName)")
                return
            }

            // Instantiate parent hand
            let handOne = ModelEntity()
            handOne.addChild(importEntity)
            handOne.position = [0.5, 1.3, -5] // Adjust the Y value to float the hand above the ground
        
            let handTwo = ModelEntity()
            handTwo.addChild(importEntityTwo)
            handTwo.position = [-0.5, 1.3, -5]
            
            // Add interaction components if needed
            handOne.components.set(InputTargetComponent())
            handOne.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
            handOne.components.set(GroundingShadowComponent(castsShadow: true))
        
            handTwo.components.set(InputTargetComponent())
            handTwo.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
            handTwo.components.set(GroundingShadowComponent(castsShadow: true))
            
            // Attach the hand to the orbSpawner
            orbSpawner.addChild(handOne)
            orbSpawner.addChild(handTwo)
            
            // Move the hand towards the player
            var targetTransform = handOne.transform
            var targetTransformTwo = handTwo.transform
            targetTransform.translation += SIMD3(0, 0, 5)
            targetTransformTwo.translation += SIMD3(0, 0, 5)
            handOne.move(to: targetTransform, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
            handTwo.move(to: targetTransformTwo, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
            
            // Despawn the hand after it stops moving or after a fixed time
            DispatchQueue.main.asyncAfter(deadline: .now() + handTravelTime + 1) {
                handOne.removeFromParent()
                handTwo.removeFromParent()
            }
            
            // Handle the correct time window for interaction
            handleCorrectTimeWindow()
        }
        
        private func handleCorrectTimeWindow() {
            Task {
                try? await Task.sleep(until: .now + .seconds(Int(handTravelTime - acceptInputWindow / 2)), clock: .continuous)
                correctTime = true
                try? await Task.sleep(until: .now + .seconds(Int(acceptInputWindow)), clock: .continuous)
                correctTime = false
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
    
    func startTimer() {
        self.timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        //self.timer.upstream.connect().cancel()
    }
    
    var body: some View {
       RealityView { content in
           //gestureModel.isFistL()
           content.add(orbSpawner)
           
//           let sphere = MeshResource.generateSphere(radius: 0.01)
//           let material = SimpleMaterial(color: .black, isMetallic: false)
//           handSphere = ModelEntity(mesh: sphere, materials: [material])
//           content.add(handSphere)
           
           for i in 1...48 {
               let sphere = MeshResource.generateSphere(radius: 0.01)
               let material = SimpleMaterial(color: .black, isMetallic: false)
               handSpheres.append(ModelEntity(mesh: sphere, materials: [material]))
               content.add(handSpheres[i])
           }
           
           let sphereX = MeshResource.generateSphere(radius: 0.01)
           let materialX = SimpleMaterial(color: .red, isMetallic: false)
           xL = ModelEntity(mesh: sphereX, materials: [materialX])
           content.add(xL)
           
           let sphereY = MeshResource.generateSphere(radius: 0.01)
           let materialY = SimpleMaterial(color: .green, isMetallic: false)
           yL = ModelEntity(mesh: sphereY, materials: [materialY])
           content.add(yL)
           
           let sphereZ = MeshResource.generateSphere(radius: 0.01)
           let materialZ = SimpleMaterial(color: .blue, isMetallic: false)
           zL = ModelEntity(mesh: sphereZ, materials: [materialZ])
           content.add(zL)
           
           let sphereXR = MeshResource.generateSphere(radius: 0.01)
           let materialXR = SimpleMaterial(color: .red, isMetallic: false)
           xR = ModelEntity(mesh: sphereXR, materials: [materialXR])
           content.add(xR)
           
           let sphereYR = MeshResource.generateSphere(radius: 0.01)
           let materialYR = SimpleMaterial(color: .green, isMetallic: false)
           yR = ModelEntity(mesh: sphereYR, materials: [materialYR])
           content.add(yR)
           
           let sphereZR = MeshResource.generateSphere(radius: 0.01)
           let materialZR = SimpleMaterial(color: .blue, isMetallic: false)
           zR = ModelEntity(mesh: sphereZR, materials: [materialZR])
           content.add(zR)
           
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                        fatalError("Unable to load immersive model")
                    }
           content.add(immersiveEntity)
           
           Task {
               openWindow(id: "scoreView")
               dismissWindow(id: "windowGroup")
               gameModel.immsersiveView = self
               stopTimer()
           }
            
       } update: { updateContent in
           
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
           
           xL.transform.translation = leftHand.x
           yL.transform.translation = leftHand.y
           zL.transform.translation = leftHand.z
           
           xR.transform.translation = rightHand.x
           yR.transform.translation = rightHand.y
           zR.transform.translation = rightHand.z
           
           if (gestureModel.isFistL()!) {
               changeColor(entity: xL, color: .green)
           } else {
               changeColor(entity: xL, color: .black)
           }
           
           if (gestureModel.isFistR()!) {
               changeColor(entity: xR, color: .green)
           } else {
               changeColor(entity: xR, color: .black)
           }
       }
//       .onReceive(timer) {time in
//           spawnHand()
//       }
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
