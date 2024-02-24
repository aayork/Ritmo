//
//  ImmersiveView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @State private var audioControllerGuitar: AudioPlaybackController?
    @State private var audioControllerDrums: AudioPlaybackController?
    @State private var audioControllerVocals: AudioPlaybackController?
    @State var score = 0
    
    let orbSpawner = Entity()
    
    @Environment(\.dismissWindow) private var dismissWindow
    // Your existing functions

    /// Function to dismiss the immersive space.
    func dismissImmersiveSpace() async {
        // Use the dismissWindow environment variable to dismiss the current window.
        // You might need to provide the specific window ID if your app has multiple windows.
        dismissWindow()
    }
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var correctTime = false;
    
//    func input() {
//        if (correctTime) {
//            output = "Nice!";
//        } else {
//            output = "Bad..."
//        }
//    }
   
    func tick() {
        // Create a floating sphere
        let sphere = MeshResource.generateSphere(radius: 0.05) // Sphere with radius of 0.1 meters
        let black = SimpleMaterial(color: .black, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphere, materials: [black])
        
        // Create circle around the sphere
        let circle = MeshResource.generateCylinder(height: 0.01, radius: 0.2)
        let white = SimpleMaterial(color: .white, isMetallic: false)
        let circleEntity = ModelEntity(mesh: circle, materials: [white])
        
        let pose = ModelEntity()
        
        // let info = MeshResource.generateText("Info", containerFrame: CGRect(x: 0, y: 0, width: 0, height: 0), alignment: .center)
        // let infoEntity = ModelEntity(mesh: info, materials: [black])
        
        // Make the sphere and circle a child of the pose
        sphereEntity.addChild(circleEntity)
        pose.addChild(sphereEntity)
        
        // Position the sphere entity above the ground or any reference point
        sphereEntity.transform = Transform(pitch: Float.pi / 2, yaw: 0.0, roll: 0.0) // Set the sphere to face the camera
        pose.position = [0, 1.3, -5] // Adjust the Y value to float the pose
        // infoEntity.setScale(SIMD3(0.01, 0.01, 0.01), relativeTo: nil)
        // infoEntity.position = [0, 1.6, -1]
        
        // Add interaction - assuming RealityKit 2.0 for gestures handling, add if needed
        pose.components.set(InputTargetComponent())
        pose.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.1)]))
        
        // Make the orb cast a shadow.
        pose.components.set(GroundingShadowComponent(castsShadow: true))
        
        // Attach the orb to the spawner
        orbSpawner.addChild(pose)
    
        var moveItMoveIt = pose.transform
        moveItMoveIt.translation += SIMD3(0, 0, 5)
        pose.move(to: moveItMoveIt, relativeTo: nil, duration: 5, timingFunction: .linear)
        var scaleTransform: Transform = Transform()
        scaleTransform.scale = SIMD3(0.25, 0.25, 0.25)
        circleEntity.move(to: circleEntity.transform, relativeTo: circleEntity.parent)
        circleEntity.move(to: scaleTransform, relativeTo: circleEntity.parent, duration: 4, timingFunction: .linear)
        
        Task {
            try? await Task.sleep(until: .now + .seconds(4 - 0.4), clock: .continuous)
            correctTime = true;
            // circle matches sphere
            try? await Task.sleep(until: .now + .seconds(0.8), clock: .continuous)
            correctTime = false;
        }
    }
    
    func changeColor(entity: Entity, color: UIColor) {
        entity.children.removeAll()
        let sphere = MeshResource.generateSphere(radius: 0.05) // Sphere with radius of 0.1 meters
        let material = SimpleMaterial(color: color, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        entity.addChild(sphereEntity)
    }
    
   var body: some View {
       
       // Scoreboard
       ZStack() {
           HStack(alignment: .top) {
               VStack(spacing: 0) {
                   HStack(alignment: .top) {
                       Button {
                           Task {
                               await dismissImmersiveSpace()
                           }
                       } label: {
                           Label("Back", systemImage: "chevron.backward")
                               .labelStyle(.iconOnly)
                       }
                       .offset(x: -23)
                       
                       VStack {
                           Text(String(score))
                               .font(.system(size: 60))
                               .bold()
                               .accessibilityLabel(Text("Score"))
                               .accessibilityValue(String(score))
                           Text("Score")
                               .font(.system(size: 30))
                               .bold()
                               .accessibilityHidden(true)
                               .offset(y: -5)
                       }
                       .padding(.leading, 0)
                       .padding(.trailing, 60)
                   }
                   HStack {
                       Button {
                       } label: {
                           Label(
                            "Play music",
                            systemImage: "speaker.wave.3.fill"
                           )
                           .labelStyle(.iconOnly)
                       }
                       .padding(.leading, 12)
                       .padding(.trailing, 10)
                       ProgressView(value: 5, total: 10)
                           .contentShape(.accessibility, Capsule().offset(y: -3))
                           .accessibilityLabel("")
                           .accessibilityValue(Text("10 seconds remaining"))
                           .tint(Color(uiColor: UIColor(red: 15 / 255, green: 68 / 255, blue: 15 / 255, alpha: 1.0)))
                           .padding(.vertical, 30)
                       Button {
                       } label: {
                           Label("Play", systemImage: "play.fill")
                               .labelStyle(.iconOnly)
                           
                       }
                       .padding(.trailing, 12)
                       .padding(.leading, 10)
                   }
                   .background(
                    .regularMaterial,
                    in: .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 12,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 0,
                        style: .continuous
                    )
                   )
                   .frame(width: 260, height: 70)
                   .offset(y: 15)
               }
               .padding(.vertical, 12)
           }
           .frame(width: 260)
           .glassBackgroundEffect(
            in: RoundedRectangle(
                cornerRadius: 32,
                style: .continuous
            )
           )
           .offset(x: 300, y: -1500)
       }
       // Scoreboard

       
       RealityView { content in
           guard let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
               fatalError("Unable to load immersive model")
           }
           
           let spatialAudioEntityGuitar = immersiveEntity.findEntity(named: "AcousticGuitar")
           spatialAudioEntityGuitar?.spatialAudio = SpatialAudioComponent()
           
           let spatialAudioEntityDrums = immersiveEntity.findEntity(named: "DrumKit")
           spatialAudioEntityDrums?.spatialAudio = SpatialAudioComponent()
           
           let spatialAudioEntityVocals = immersiveEntity.findEntity(named: "MovieBoomMicrophone")
           spatialAudioEntityVocals?.spatialAudio = SpatialAudioComponent()
           
           guard let instrumentResource = try? await AudioFileResource(named: "/Root/instruments_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           guard let drumsResource = try? await AudioFileResource(named: "/Root/drums_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           guard let vocalsResource = try? await AudioFileResource(named: "/Root/vocals_mp3", from: "Immersive.usda", in: realityKitContentBundle) else {
               fatalError("Unable to load audio resource")
           }
           
           audioControllerGuitar = spatialAudioEntityGuitar?.prepareAudio(instrumentResource)
           audioControllerDrums = spatialAudioEntityDrums?.prepareAudio(drumsResource)
           audioControllerVocals = spatialAudioEntityDrums?.prepareAudio(vocalsResource)
           audioControllerGuitar?.play()
           audioControllerDrums?.play()
           audioControllerVocals?.play()
           // Add the immersiveEntity to the scene
           content.add(immersiveEntity)
           
           //orbSpawner.position = [0, 0, 0]
           content.add(orbSpawner)
           
           Task {
               dismissWindow(id: "windowGroup")
           }
           // content.installGestures([.rotation, .translation], for: sphereEntity)
       }
       .onReceive(timer) {time in
           tick()
       }
       .onDisappear(perform: {
           audioControllerGuitar?.stop()
           audioControllerDrums?.stop()
           audioControllerVocals?.stop()
       })
       .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
           // Change color to green or red
           //value.entity.children.removeAll()
           //let sphere = MeshResource.generateSphere(radius: 0.05) // Sphere with radius of 0.1 meters
           
           if (correctTime) {
               changeColor(entity: value.entity, color: .green)
               score += 1
           } else {
               changeColor(entity: value.entity, color: .red)
           }
       }))
   }
}
