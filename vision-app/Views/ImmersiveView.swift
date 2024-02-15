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
   
   @State private var audioController: AudioPlaybackController? // ? means nullable
   
   var body: some View {
       
       RealityView { content in
           guard let entity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
               fatalError("Unable to load immersive model")
           }
           
           let spatialAudioEntity = entity.findEntity(named: "AcousticGuitar")
           
           spatialAudioEntity?.spatialAudio = SpatialAudioComponent()
        
           guard let resource = try? await AudioFileResource(named: "/Root/back_on_74_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           audioController = spatialAudioEntity?.prepareAudio(resource)
           audioController?.play()
           
           
           
           content.add(entity)
       }
       .onDisappear(perform: {
           audioController?.stop()
       })
   }
}
