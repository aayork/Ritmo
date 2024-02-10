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
    // Create your entity
    if let entity = try? Entity.load(named: "AcousticGuitar", in: realityKitContentBundle) {
        do {
            // Load the audio resource
            let resource = try AudioFileResource.load(named: "07 Little Lion Man")
            
            // Play audio from the entity
            entity.playAudio(resource)
        } catch {
            print("Error: \(error)")
        }
    } else {
        print("Failed to load the entity")
    }
}

