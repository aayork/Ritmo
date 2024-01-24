//
//  ContentView.swift
//  vision-app
//
//  Created by Aidan York on 1/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hi Team! Can't wait to get started with this new app -AY")
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
