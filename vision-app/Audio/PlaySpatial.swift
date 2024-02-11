//
//  PlaySpatial.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
//

import Foundation
import RealityKit
import RealityKitContent

func playSpatialAudio() {
    if let acousticGuitar = try? Entity.load(named: "AcousticGuitar", in: realityKitContentBundle) {
        // Create your entity
        print("Creating entity...")
        let audioSource = Entity()
        audioSource.spatialAudio = SpatialAudioComponent()
        
        do {
            let resource = try AudioFileResource.load(named: "07 Little Lion Man.mp3", configuration: .init(shouldLoop: true))
            
            // Place the loaded audio resource onto the orb.
            acousticGuitar.addChild(audioSource)
            audioSource.playAudio(resource)
        } catch {
            print("Error loading audio file: \(error.localizedDescription)")
        }
        
    }
}


