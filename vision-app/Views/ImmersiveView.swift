//
//  ImmersiveView.swift
//  vision-app
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
   
   @State private var playbackController: AudioPlaybackController?
   
   var body: some View {
      RealityView { content in
         // Add the initial RealityKit content
         if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
            //Accessing ambient emitter
            let audioEntity = scene.findEntity(named: "AmbientAudioComponent")
            // Add the audio source to a parent entity, and play a looping sound on it.
            //example from Apple code to find the audio file res
            if let audio = try? await AudioFileResource(named: "StarWars60",
                                                        configuration: .init(shouldLoop: true)) {
               playbackController = audioEntity?.prepareAudio(audio)
               playbackController?.play()
            }
            content.add(scene)
         }
      }
   }
}

