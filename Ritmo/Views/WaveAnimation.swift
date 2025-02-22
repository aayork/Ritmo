//
//  WaveAnimation.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct WaveAnimation: View {
    
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    @State private var hue = 0.0
    
    var body: some View {
        ZStack {
            Color(.ritmoBlue).opacity(1.0).ignoresSafeArea()
            ForEach(0..<70) { i in
                Wave(offSet: Angle(degrees: waveOffset.degrees - Double(i) * 10), percent: percent, index: i, direction: i % 2 == 0 ? 1 : -1, hue: hue)
                    .stroke(Color.ritmoLightBlue
                    )
                    .ignoresSafeArea(.all)
                    .blur(radius: 1.5)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
                self.hue = 0.65 // Animate hue from 0 to 1
            }
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct Wave: Shape {
    var offSet: Angle
    var percent: Double
    var index: Int
    var direction: Double // Added direction factor
    var hue: Double // New property for animating color
    
    var animatableData: AnimatablePair<AnimatablePair<Double, Double>, Double> {
        get { AnimatablePair(AnimatablePair(offSet.degrees, direction), hue) }
        set {
            offSet = Angle(degrees: newValue.first.first)
            direction = newValue.first.second
            hue = newValue.second
        }
    }

    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let waveSpacing = 13.5
        
        let waveHeight = rect.height / 40
        let yOffSet = CGFloat(index) * waveSpacing
        
        let adjustedOffset = offSet + Angle(degrees: direction * 360) // Use direction to adjust offset
        let startAngle = adjustedOffset
        let endAngle = adjustedOffset + Angle(degrees: 360)
        
        path.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 1) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            path.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        return path
    }
}

struct WaveAnimation_Previews: PreviewProvider {
    static var previews: some View {
        WaveAnimation()
    }
}
