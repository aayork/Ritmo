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
                .padding(.bottom, 45)

            Text("Hi Team! Can't wait to get started with this new app -AY")
                .font(.extraLargeTitle)
                .opacity(0.5)}
                .padding(.horizontal, 50)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
