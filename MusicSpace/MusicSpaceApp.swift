//
//  MusicSpaceApp.swift
//  MusicSpace
//
//  Created by Aidan York on 2/8/24.
//

import SwiftUI

@main
struct vision_appApp: App {
    @State private var gameModel = GameModel()
    @State private var immersionState: ImmersionStyle = .mixed
    var body: some Scene {
        WindowGroup(id: "windowGroup") {
            ContentView()
                .environment(self.gameModel)
                .onAppear {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                        return
                    }
                    windowScene.requestGeometryUpdate(.Vision(resizingRestrictions: UIWindowScene.ResizingRestrictions.none))
                }
        } // To make the "glass window" go away, set window group to plain type
        .windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(self.gameModel)
        }
        .immersionStyle(selection: $immersionState, in: .mixed)
        /*
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
         */
    
    }
}
