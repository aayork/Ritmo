//
//  ImmersiveView.swift
//  Ritmo
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import MusicKit

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
    @State private var handTargets = [Entity()]
    
    let orbSpawner = Entity()
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var songTiming: [GestureEntity] = []
    @State var timingIndex = 0
    @State var previousSongTime = 0
    let handTravelTime = 4.0 // The time it takes the hand to reach the player
    let acceptInputWindow = 0.8 // The time window in which the player can successfully match a gesture
    
    func gameLoop() {
            
        if (timingIndex < songTiming.count) {
            if (gameModel.songTime == songTiming[timingIndex].timing) {
                print(songTiming)
                timingIndex += 1
            }
        }
        
        if (testJSON(songName: gameModel.musicView.selectedSong!.name) != nil) {
            print("JSON exists.")
        } else {
            print("JSON does NOT exist.")
        }
    
        //gameModel.highScore.addScore(song: gameModel.musicView.selectedSong! ,score: score) // Add the score of the song to the score list
        
        // Handle the correct time window for interaction
        // handleCorrectTimeWindow()
    }
    
    func spawner(bpm: Int) { // Use beats per minute as an argument
        if (testJSON(songName: gameModel.musicView.selectedSong!.name) != nil) {
            print("JSON exists.")
        } else {
            let spawnInterval = 60000 / bpm // This is the amount of milliseconds that elapse during each beat
            if gameModel.songTime - previousSongTime == spawnInterval {
                // Randomly choose between "Fist_fixed" and "OPENfixed"
                previousSongTime = gameModel.songTime
                let entityNames = ["right_fist", "right_open", "right_peaceSign"]
                let randomIndex = Int.random(in: 0..<entityNames.count)
                let entityName = entityNames[randomIndex]
                
                let entityTwoNames = ["left_fist", "left_open", "left_peaceSign"]
                let randomIndexTwo = Int.random(in: 0..<entityTwoNames.count)
                let entityTwoName = entityTwoNames[randomIndexTwo]
                
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
                
                var material = SimpleMaterial()
                material.color = .init(tint: .electricLime)
                material.metallic = .init(floatLiteral: 100.0)
                handTwo.model?.materials[0] = material
                
                // Add interaction components if needed
                handOne.components.set(InputTargetComponent())
                handOne.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                handOne.components.set(GroundingShadowComponent(castsShadow: true))
                
                handTwo.components.set(InputTargetComponent())
                handTwo.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                handTwo.components.set(GroundingShadowComponent(castsShadow: true))
                
                // Attach hands to the orbSpawner
                orbSpawner.addChild(handOne)
                orbSpawner.addChild(handTwo)
                
                handTargets.append(handOne)
                handTargets.append(handTwo)
                
                var smpl = SimpleMaterial()
                        smpl.color.tint = .blue
                        smpl.metallic = 0.7
                        smpl.roughness = 0.2
                
                // Move the hands towards the player
                var targetTransform = handOne.transform
                var targetTransformTwo = handTwo.transform
                targetTransform.translation += SIMD3(0, 0, 5)
                targetTransformTwo.translation += SIMD3(0, 0, 5)
                handOne.move(to: targetTransform, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
                handTwo.move(to: targetTransformTwo, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
                
                // Despawn hands after stopping or after a fixed time
                DispatchQueue.main.asyncAfter(deadline: .now() + handTravelTime + 1) {
                    // handTargets.remove(at: handTargets.firstIndex(of: handOne)!) // These just made it lag
                    // handTargets.remove(at: handTargets.firstIndex(of: handTwo)!)
                    handOne.removeFromParent()
                    handTwo.removeFromParent()
                }
            }
        }
    }
        
    private func handleCorrectTimeWindow() {
        Task {
            try? await Task.sleep(until: .now + .seconds(Int(handTravelTime - acceptInputWindow / 2)), clock: .continuous)
            correctTime = true
            try? await Task.sleep(until: .now + .seconds(Int(acceptInputWindow)), clock: .continuous)
            correctTime = false
        }
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    // Read data from JSON
    func readJSONFromFile(songName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: songName, ofType: "json") else {
            print("File not found")
            return nil
        }
        
        do {
            let fileURL = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error reading file:", error)
            return nil
        }
    }

    // Parse JSON data into Song object
    func parseJSON(songName: String) -> [GestureEntity]? {
        print("parseJSON")
        guard let jsonData = readJSONFromFile(songName: songName) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: jsonData)
            
            print("Song Title:", response.song.title)
            print("Artist:", response.song.artist)
            print("Duration:", response.song.duration)
            print("BPM:", response.song.bpm)
            print("Creator:", response.song.creator)
            
            return response.gesture_entities
        } catch {
            print("Error parsing JSON:", error)
        }
        return nil
    }
    
    func testJSON(songName: String) -> Bool? {
            print("testJSON")
        guard readJSONFromFile(songName: songName) != nil else { return nil }
            do {
                return true
            }
    }
    
    struct Response: Codable {
        var song: SongJSON
        var gesture_entities: [GestureEntity]
    }
    
    struct SongJSON: Codable {
        let title: String
        let artist: String
        let duration: Int
        let bpm: Int
        let creator: String
    }

    struct GestureEntity: Codable {
        let timing: Int
        let type: String
        let position: Position
        let orientation: Orientation
    }
    
    struct Position: Codable {
        let x: Float
        let y: Float
        let z: Float
    }

    struct Orientation: Codable {
        let pitch: Float
        let yaw: Float
        let roll: Float
    }
    
    
    var body: some View {
       RealityView { content in
           
           content.add(orbSpawner)
           
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
           
           openTest.position = SIMD3(x: -1, y: 1, z: -1)
           content.add(openTest)
           fistTest.position = SIMD3(x: -0.5, y: 1, z: -1)
           content.add(fistTest)
           peaceSignTest.position = SIMD3(x: 0, y: 1, z: -1)
           content.add(peaceSignTest)
           fingerGunTest.position = SIMD3(x: 0.5, y: 1, z: -1)
           content.add(fingerGunTest)
           
           
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                fatalError("Unable to load immersive model")
            }
           content.add(immersiveEntity)
           
           Task {
               openWindow(id: "scoreView")
               dismissWindow(id: "windowGroup")
               // Attach itself to the gameModel
               gameModel.immsersiveView = self
               print("runtask")
               // Read data from JSON
               guard let songTiming = parseJSON(songName: gameModel.musicView.getSongName())
               else {
                   print("songTiming is nil")
                   return
               }
               self.songTiming = songTiming
               print(self.songTiming.count)
               stopTimer()
           }
            
       } update : { updateContent in
           
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
           
           for handTarget in handTargets {
               if (simd_distance(leftHand.middleFingerKnuckle, handTarget.position) < 0.2) {
                   handTargets.remove(at: handTargets.firstIndex(of: handTarget)!)
                   handTarget.removeFromParent()
               }
               if (simd_distance(rightHand.middleFingerKnuckle, handTarget.position) < 0.2) {
                   handTargets.remove(at: handTargets.firstIndex(of: handTarget)!)
                   handTarget.removeFromParent()
               }
           }
       }
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           if (correctTime) {
               gameModel.score += 1
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
