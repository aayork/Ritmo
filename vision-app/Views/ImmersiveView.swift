//
//  ImmersiveView.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

//  Based on https://developer.apple.com/videos/play/wwdc2023/10080/ and Rutger Schimmel's design

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    
    var songs = ["01 Closing Time", "02 Hey, Soul Sister", "03 I Will Wait", "04 She Will Be Loved"]
    var soundFile = "01 Closing Time"
    var acousticGuitar: Entity
        
        init() {
            self.acousticGuitar = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            setupModel()
            loadAudio()
        }
 
    
    func setupModel() {
        // Set the position of the orb in meters.
        acousticGuitar.position.x = 0
        acousticGuitar.position.y = 1.5
        acousticGuitar.position.z = -1
        
        // Make the orb selectable.
        acousticGuitar.components.set(InputTargetComponent())
        acousticGuitar.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
        
        // Make the orb cast a shadow.
        acousticGuitar.components.set(GroundingShadowComponent(castsShadow: true))
    }
    
    func loadAudio() {
        // Create an empty entity to act as an audio source.
        let audioSource = Entity()
        audioSource.spatialAudio = SpatialAudioComponent()
        
        do {
            let resource = try AudioFileResource.load(named: soundFile, configuration: .init(shouldLoop: true))
            
            // Place the loaded audio resource onto the orb.
            acousticGuitar.addChild(audioSource)
            audioSource.playAudio(resource)
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        RealityView { content in
            content.add(acousticGuitar)
        }
        .gesture(DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                // The value is in SwiftUI's coordinate space, so we have to convert it to RealityKit's coordinate space.
                acousticGuitar.position = value.convert(value.location3D, from: .local, to: acousticGuitar.parent!)
            })
    }
}

