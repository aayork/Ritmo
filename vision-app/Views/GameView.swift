//
//  GameView.swift
//  vision-app
//
//  Created by Max Pelot on 2/9/24.
//

import SwiftUI

struct GameView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var color = 0.25;
    @State private var output = "...";
    @State private var correctTime = false;
    
    func input() {
        if (correctTime) {
            output = "Nice!";
        } else {
            output = "Bad..."
        }
    }
    
    func flip() async {
        output = "..."
        correctTime = true;
        try? await Task.sleep(until: .now + .seconds(0.15), clock: .continuous)
        color *= -1;
        try? await Task.sleep(until: .now + .seconds(0.15), clock: .continuous)
        correctTime = false;
    }
    
    var body: some View {
        ZStack {
            Color(hue: 0.5 + color, saturation: 0.9, brightness: 1.5, opacity: 0.3)
                .onReceive(timer) {time in
                    Task {await flip()}
                }
            VStack {
                Text("Click when the color changes!")
                    .font(.system(size: 40))
                Button {
                    input()
                } label: {
                    Image(systemName: "target")
                }
                .buttonStyle(.borderless)
                .controlSize(.extraLarge)
                Text(output)
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    GameView()
}
