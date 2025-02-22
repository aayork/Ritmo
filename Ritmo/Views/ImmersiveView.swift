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
                
                hand.name = entityName
                handTargets.append(hand)
                
                hand.position = SIMD3<Float>(songTiming[currentIndex].position.x, songTiming[currentIndex].position.y, songTiming[currentIndex].position.z - 5)
                
                hand.components.set(InputTargetComponent())
                hand.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                hand.components.set(GroundingShadowComponent(castsShadow: true))
                
                spaceOrigin.addChild(hand)
                
                // Move the hands towards the player
                var targetTransform = hand.transform
                targetTransform.translation += SIMD3(0, 0, 5)
                hand.move(to: targetTransform, relativeTo: nil, duration: handTravelTime - 1, timingFunction: .linear)
                
                // Despawn hands after stopping or after a fixed time
                DispatchQueue.main.asyncAfter(deadline: .now() + handTravelTime - 1) {
                    handTargets.remove(at: handTargets.firstIndex(of: hand) ?? -1)
                    hand.removeFromParent()
                }
                
                if (songTiming.count - 1 != currentIndex) {
                    currentIndex += 1
                }
            }
        } else {
            let spawnInterval = 60000 / bpm // This is the amount of milliseconds that elapse during each beat
            if gameModel.songTime - previousSongTime == spawnInterval {
                // Randomly choose between hand gesture
                previousSongTime = gameModel.songTime
                let rightEntityNames = ["right_fist", "right_open", "right_peaceSign","","",""]
                let randomRightIndex = Int.random(in: 0..<rightEntityNames.count)
                let rightEntityName = rightEntityNames[randomRightIndex]
                
                let leftEntityNames = ["left_fist", "left_open", "left_peaceSign","","",""]
                let randomLeftIndex = Int.random(in: 0..<leftEntityNames.count)
                let leftEntityName = leftEntityNames[randomLeftIndex]
                
                let rightHand: Entity
                let leftHand: Entity
                
                switch rightEntityName {
                case "right_open":
                    rightHand = rightOpen.clone(recursive: true)
                case "right_fist":
                    rightHand = rightFist.clone(recursive: true)
                case "right_peaceSign":
                    rightHand = rightPeaceSign.clone(recursive: true)
                case "right_point":
                    rightHand = rightPoint.clone(recursive: true)
                default:
                    rightHand = Entity()
                }
                
                switch leftEntityName {
                case "left_open":
                    leftHand = leftOpen.clone(recursive: true)
                case "left_fist":
                    leftHand = leftFist.clone(recursive: true)
                case "left_peaceSign":
                    leftHand = leftPeaceSign.clone(recursive: true)
                case "left_point":
                    leftHand = leftPoint.clone(recursive: true)
                default:
                    leftHand = Entity()
                }
                
                rightHand.name = rightEntityName
                handTargets.append(rightHand)
                
                leftHand.name = leftEntityName
                handTargets.append(leftHand)
                
                let rightYPosition = Float.random(in: 1.1...1.3)
                let rightXPosition = Float.random(in: 0.1...0.5)
                
                rightHand.position = [rightXPosition, rightYPosition, -5]
                rightHand.components.set(InputTargetComponent())
                rightHand.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                rightHand.components.set(GroundingShadowComponent(castsShadow: true))
                
                let leftYPosition = Float.random(in: 1.1...1.3)
                let leftXPosition = Float.random(in: -0.5...(-0.1))
                
                leftHand.position = [leftXPosition, leftYPosition, -5]
                leftHand.components.set(InputTargetComponent())
                leftHand.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
                leftHand.components.set(GroundingShadowComponent(castsShadow: true))
                
                spaceOrigin.addChild(rightHand)
                spaceOrigin.addChild(leftHand)
                
                // Move the hands towards the player
                var rightTargetTransform = rightHand.transform
                rightTargetTransform.translation += SIMD3(0, 0, 5)
                rightHand.move(to: rightTargetTransform, relativeTo: nil, duration: handTravelTime - 1, timingFunction: .linear)
                
                
                var leftTargetTransform = leftHand.transform
                leftTargetTransform.translation += SIMD3(0, 0, 5)
                leftHand.move(to: leftTargetTransform, relativeTo: nil, duration: handTravelTime - 1, timingFunction: .linear)
                
                // Despawn hands after stopping or after a fixed time
                DispatchQueue.main.asyncAfter(deadline: .now() + handTravelTime - 1) {
                    handTargets.remove(at: handTargets.firstIndex(of: rightHand) ?? -1)
                    rightHand.removeFromParent()
                    handTargets.remove(at: handTargets.firstIndex(of: leftHand) ?? -1)
                    leftHand.removeFromParent()
                }
                
                if (songTiming.count - 1 != currentIndex) {
                    currentIndex += 1
                }
            }
        }
    }
    
    func spawnParticles(position: SIMD3<Float>) {
        print("burst")
        var particles = ParticleEmitterComponent()
        particles.timing = .once(emit: ParticleEmitterComponent.Timing.VariableDuration(duration: 4))
        particles.emitterShape = .point
        particles.birthLocation = .surface
        particles.emitterShapeSize = [0.3, 0.3, 0.3]
        
        particles.mainEmitter.birthRate = 0
        particles.burstCount = 30
        particles.mainEmitter.size = 0.03
        particles.mainEmitter.lifeSpan = 1
        particles.mainEmitter.color = .evolving(start: .single(.white), end: .single(.blue))
        particles.mainEmitter.spreadingAngle = 360
        particles.speed = 1.5
        particles.speedVariation = 0.3
        particles.spawnOccasion = .onBirth
        particles.mainEmitter.billboardMode = .billboard
        particles.mainEmitter.dampingFactor = 4
        particles.mainEmitter.stretchFactor = 6
        particles.burst()
        
        let particleModel = ModelEntity()
        particleModel.position = SIMD3(position.x, position.y + 0.1, position.z)
        particleModel.components.set(particles)
        spaceOrigin.addChild(particleModel)
        
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    // Read data from JSON
    func readJSONFromFile(song: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: song, ofType: "json") else {
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
    func parseJSON(song: String) -> [GestureEntity]? {
        let sanitizedSong = sanitizeFilename(song)
        print("parseJSON for \(sanitizedSong)")
        guard let jsonData = readJSONFromFile(song: sanitizedSong) else { return nil }
        
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
    
    func testJSON(song: String) -> Bool? {
        print("testJSON")
        let sanitizedSong = sanitizeFilename(song)
        guard readJSONFromFile(song: sanitizedSong) != nil else { return nil }
        do {
            return true
        }
    }
    
    func sanitizeFilename(_ input: String) -> String {
        let disallowedCharacters = CharacterSet(charactersIn: ":\\/<>?*|\"").union(.newlines).union(.illegalCharacters).union(.controlCharacters)
        var sanitizedString = ""

        for character in input {
            if character.unicodeScalars.contains(where: disallowedCharacters.contains) {
                sanitizedString.append("-")
            } else {
                sanitizedString.append(character)
            }
        }

        return sanitizedString
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
            content.add(spaceOrigin)
            
            // Assuming 'gameModel.musicView.selectedSong?.genres' is an optional array of String
            if let genres = gameModel.selectedSong?.genres {
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
                        let immersiveEntity = try await Entity(named: "PopScene", in: realityKitContentBundle)
                        content.add(immersiveEntity)
                    } catch {
                        print("Error loading PopScene: \(error)")
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
                guard let songTiming = parseJSON(song: "\(gameModel.musicView.getSongName()) \(gameModel.musicView.selectedSong?.artist ?? "")")
                else {
                    print("songTiming is nil")
                    return
                }
                self.songTiming = songTiming
                print("Song Timing count: \(self.songTiming.count)")
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
            
            xL.transform.translation = leftHand.x
            yL.transform.translation = leftHand.y
            zL.transform.translation = leftHand.z
            
            xR.transform.translation = rightHand.x
            yR.transform.translation = rightHand.y
            zR.transform.translation = rightHand.z
            
            for handTarget in handTargets {
                if ((simd_distance(leftHand.hand.originFromAnchorTransform.columns.3.xyz, handTarget.position) < 0.3 || simd_distance(rightHand.hand.originFromAnchorTransform.columns.3.xyz, handTarget.position) < 0.3) && gestureModel.checkGesture(handTarget.name) == true) {
                    
                    // Spawn particles
                    spawnParticles(position: handTarget.position)
                    
                    handTarget.position = (SIMD3(7, 7, 7))
                    // handTargets.remove(at: handTargets.firstIndex(of: handTarget) ?? -1)
                    handTarget.removeFromParent()
                    DispatchQueue.main.async {
                        gameModel.score += 10
                    }
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
            gameModel.highScore.addScore(song: gameModel.selectedSong! ,score: gameModel.score) // Add the score of the song to the score list
            gameModel.reset()
        }
    }
}
