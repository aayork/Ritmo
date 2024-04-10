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
    @State var currentIndex = 0
    @State private var correctTime = false;
    @State private var xL = Entity()
    @State private var yL = Entity()
    @State private var zL = Entity()
    @State private var xR = Entity()
    @State private var yR = Entity()
    @State private var zR = Entity()
    @State private var handSpheres = [Entity()]
    @State private var handTargets = [Entity()]

    let entity = Entity()
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var songTiming: [GestureEntity] = []
    @State var timingIndex = 0
    @State var previousSongTime = 0
    let handTravelTime = 4.0 // The time it takes the hand to reach the player
    let acceptInputWindow = 0.8 // The time window in which the player can successfully match a gesture
    
    @State private var imageName = "stageView"
    
    func gameLoop(bpm: Int) { // Use beats per minute as an argument
        if (gameModel.curated) {
            print("current index:", currentIndex)
            if songTiming[currentIndex].timing == gameModel.songTime {
                let entityName = songTiming[currentIndex].type
                
                let hand: Entity
                
                switch entityName {
                case "left_open":
                    hand = leftOpen.clone(recursive: true)
                case "left_fist":
                    hand = leftFist.clone(recursive: true)
                case "left_peaceSign":
                    hand = leftPeaceSign.clone(recursive: true)
                case "left_point":
                    hand = leftPoint.clone(recursive: true)
                case "right_open":
                    hand = rightOpen.clone(recursive: true)
                case "right_fist":
                    hand = rightFist.clone(recursive: true)
                case "right_peaceSign":
                    hand = rightPeaceSign.clone(recursive: true)
                case "right_point":
                    hand = rightPoint.clone(recursive: true)
                default:
                    hand = Entity()
                }
                
                // Attempt to load the chosen entity
//                guard let hand = try? ModelEntity.load(named: entityName, in: realityKitContentBundle) else {
//                    print("Failed to load entity: \(entityName)")
//                    return
//                }
                
                hand.position = SIMD3<Float>(songTiming[currentIndex].position.x, songTiming[currentIndex].position.y, songTiming[currentIndex].position.z - 5)
                
                hand.components.set(InputTargetComponent())
                hand.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                hand.components.set(GroundingShadowComponent(castsShadow: true))
                
                entity.addChild(hand)
                
                // Move the hands towards the player
                var targetTransform = hand.transform
                targetTransform.translation += SIMD3(0, 0, 5)
                hand.move(to: targetTransform, relativeTo: nil, duration: handTravelTime - 1, timingFunction: .linear)
                
                if true { // Add check for gesture here
                    gameModel.score += 10
                }
                
                // Despawn hands after stopping or after a fixed time
                DispatchQueue.main.asyncAfter(deadline: .now() + handTravelTime - 1) {
                    hand.removeFromParent()
                }
                
                if (songTiming.count - 1 != currentIndex) {
                    currentIndex += 1
                }
            }
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

                // Add interaction components if needed
                handOne.components.set(InputTargetComponent())
                handOne.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                handOne.components.set(GroundingShadowComponent(castsShadow: true))
                
                handTwo.components.set(InputTargetComponent())
                handTwo.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                handTwo.components.set(GroundingShadowComponent(castsShadow: true))
                
                // Attach hands to the entity
                entity.addChild(handOne)
                entity.addChild(handTwo)
                
                handTargets.append(handOne)
                handTargets.append(handTwo)
                
                // Move the hands towards the player
                var targetTransform = handOne.transform
                var targetTransformTwo = handTwo.transform
                targetTransform.translation += SIMD3(0, 0, 5)
                targetTransformTwo.translation += SIMD3(0, 0, 5)
                handOne.move(to: targetTransform, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
                handTwo.move(to: targetTransformTwo, relativeTo: nil, duration: handTravelTime + 1, timingFunction: .linear)
                
                if true { // Add check for gesture here
                    gameModel.score += 10
                }
                
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
           
           let rootEntity = Entity()

           guard let texture = try? await TextureResource(named: imageName) else {
               return
           }
           
           var material = UnlitMaterial()
           material.color = .init(texture: .init(texture))

           rootEntity.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [material]))
           rootEntity.scale *= .init(x: -1, y: 1, z: 1)
           rootEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)

           content.add(rootEntity)
           
           content.add(entity)
           
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
           
           
//           let sphereOTP = MeshResource.generateSphere(radius: 0.01)
//           let materialOTP = SimpleMaterial(color: .purple, isMetallic: false)
//           let openTestPoint = ModelEntity(mesh: sphereOTP, materials: [materialOTP])
//           openTestPoint.position = SIMD3(x: -1, y: 1, z: -1)
//           content.add(openTestPoint)
//           openTest.position = SIMD3(x: -1, y: 1, z: -1)
//           openTest.name = "right_open"
//           content.add(openTest)
//           handTargets.append(openTest)
//           
//           let sphereFTP = MeshResource.generateSphere(radius: 0.01)
//           let materialFTP = SimpleMaterial(color: .purple, isMetallic: false)
//           let fistTestPoint = ModelEntity(mesh: sphereFTP, materials: [materialFTP])
//           fistTestPoint.position = SIMD3(x: -0.5, y: 1, z: -1)
//           content.add(fistTestPoint)
//           fistTest.position = SIMD3(x: -0.5, y: 1, z: -1)
//           fistTest.name = "right_fist"
//           content.add(fistTest)
//           handTargets.append(fistTest)
//           
//           let spherePSTP = MeshResource.generateSphere(radius: 0.01)
//           let materialPSTP = SimpleMaterial(color: .purple, isMetallic: false)
//           let peaceSignTestPoint = ModelEntity(mesh: spherePSTP, materials: [materialPSTP])
//           peaceSignTestPoint.position = SIMD3(x: 1, y: 1, z: -1)
//           content.add(peaceSignTestPoint)
//           peaceSignTest.position = SIMD3(x: 1, y: 1, z: -1)
//           peaceSignTest.name = "right_peaceSign"
//           content.add(peaceSignTest)
//           handTargets.append(peaceSignTest)
//           
//           let sphereFGTP = MeshResource.generateSphere(radius: 0.01)
//           let materialFGTP = SimpleMaterial(color: .purple, isMetallic: false)
//           let fingerGunTestPoint = ModelEntity(mesh: sphereFGTP, materials: [materialFGTP])
//           fingerGunTestPoint.position = SIMD3(x: 0.5, y: 1, z: -1)
//           content.add(fingerGunTestPoint)
//           fingerGunTest.position = SIMD3(x: 0.5, y: 1, z: -1)
//           fingerGunTest.name = "right_fingerGun"
//           content.add(fingerGunTest)
//           handTargets.append(fingerGunTest)
           
           // Assuming 'gameModel.musicView.selectedSong?.genres' is an optional array of String
           if let genres = gameModel.musicView.selectedSong?.genres {
               // Use a switch statement to check for specific genres
               // Assuming you want to check the first genre that matches your criteria
               // This could be adapted based on how you want to prioritize or handle multiple genres
               let genre = genres.first(where: { $0 == "Rock" || $0 == "Pop" || $0 == "Country" }) // Add more genres as needed
               
               switch genre {
               case "Rock":
                   do {
                       let immersiveEntity = try await Entity(named: "RockScene", in: realityKitContentBundle)
                       content.add(immersiveEntity)
                   } catch {
                       print("Error loading RockScene: \(error)")
                   }
               case "Pop":
                   do {
                       let immersiveEntity = try await Entity(named: "PopScene", in: realityKitContentBundle)
                       content.add(immersiveEntity)
                   } catch {
                       print("Error loading PopScene: \(error)")
                   }
               case "Country":
                   do {
                       let immersiveEntity = try await Entity(named: "CountryScene", in: realityKitContentBundle)
                       content.add(immersiveEntity)
                   } catch {
                       print("Error loading JazzScene: \(error)")
                   }
               default:
                   // Handle any genre not explicitly matched above or if no genre is found
                   do {
                       let immersiveEntity = try await Entity(named: "DefaultScene", in: realityKitContentBundle)
                       content.add(immersiveEntity)
                   } catch {
                       print("Error loading DefaultScene: \(error)")
                   }
               }
           } else {
               // Handle the case where genres is nil or empty
               do {
                   let immersiveEntity = try await Entity(named: "DefaultScene", in: realityKitContentBundle)
                   content.add(immersiveEntity)
               } catch {
                   print("Error loading DefaultScene: \(error)")
               }
           }

           
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
               if (simd_distance(leftHand.hand.originFromAnchorTransform.columns.3.xyz, handTarget.position) < 0.3 && gestureModel.checkGesture(handTarget.name)!) {
                   handTargets.remove(at: handTargets.firstIndex(of: handTarget)!)
                   handTarget.removeFromParent()
               }
               
               if (simd_distance(rightHand.hand.originFromAnchorTransform.columns.3.xyz, handTarget.position) < 0.3 && gestureModel.checkGesture(handTarget.name)!) {
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
       .onDisappear() {
           gameModel.highScore.addScore(song: gameModel.musicView.selectedSong! ,score: gameModel.score) // Add the score of the song to the score list
       }
   }
}
