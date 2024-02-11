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
    
    var body: some View {
        Color(hue: 0.5 + color, saturation: 0.9, brightness: 1.5, opacity: 0.3)
            .onReceive(timer) {time in
                color *= -1;
            }
    }
}

#Preview {
    GameView()
}
