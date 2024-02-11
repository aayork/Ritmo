//
//  SpatialAudioView.swift
//  vision-app
//
//
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SpatialAudioView: View {
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    /// This isn't the original immersive space I created, I've been having trouble getting spatial audio to work with RealityKit. Something weird with setting element values.
    @State private var playing = false
    @State var songTitle = "Not Playing"
    
    var body: some View {
        VStack {
            Text("Experience Spatial Audio!")
                .font(.title)
            Text(SoundView().soundFile)
                .font(.title3)
            
            Text("")
                .ornament(
                    visibility: .visible,
                    attachmentAnchor: .scene(.bottom),
                    contentAlignment: .center
                ) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "backward.fill")
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.extraLarge)
                        Button {
                            Task {
                                await openImmersiveSpace(id: "ImmersiveSpace")
                            }
                            playing = true
                        } label: {
                            Image(systemName: playing ? "pause.fill" : "play.fill")
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.extraLarge)
                        Button {
                            
                        } label: {
                            Image(systemName: "forward.fill")
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.extraLarge)
                        
                    }
                    .labelStyle(.iconOnly)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .glassBackgroundEffect()
                }
            
            
        }
    }
}

#Preview {
    SpatialAudioView()
}

struct SpatialAudioImmersiveSpace: View {
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(scene)
            }
        } update: { updateContent in
            
        }
    }
}

//
//  SoundOrbView.swift
//
//  Created by Rutger Schimmel on 27/07/2023.
//  Based on https://developer.apple.com/videos/play/wwdc2023/10080/
//
//  This view can be placed in a ImmersiveSpace, creating a floating orb that projects sounds.
//  The orb can be interacted with by dragging.
//

import SwiftUI
import RealityKit

struct SoundView: View {
    
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

