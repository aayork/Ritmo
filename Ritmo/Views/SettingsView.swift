//
//  SettingsView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    // State for slider value
    @State private var volume: Double = 50
    
    var body: some View {
        ZStack {
            BlurredBackground()
            VStack {
                Text("SETTINGS")
                    .font(.custom("Soulcraft_Wide", size: 50.0))
                    .padding()
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.electricLime)
                
                VStack {
                    // Volume Slider
                    Text("Master Volume")
                        .font(.custom("FormaDJRMicro-Light", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    Slider(value: $volume, in: 0...100)
                        .tint(Color.electricLime)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    // Control Buttons
                    Text("Controls")
                        .font(.custom("FormaDJRMicro-Light", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 30)
                    HStack {
                        Button("GESTURES") {}
                        Button("AUDIO") {}
                        Button("GUIDES") {}
                    }
                    .font(.custom("Soulcraft_Wide", size: 30.0))
                    .foregroundColor(Color.electricLime)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .frame(width: 1000, height: 400)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)).opacity(0.6))
                .cornerRadius(20)
                
                HStack {
                    Button{
                    } label: {
                        Text("CREDITS")
                            .foregroundColor(.white)
                            .font(.custom("Soulcraft_Wide", size: 30.0))
                            .frame(maxWidth: 225, minHeight: 52)
                    }
                    .offset(x: 325)
                    .padding(.horizontal)
                    Spacer()
                    
                    Button {
                    } label: {
                        Text("TUTORIAL")
                            .foregroundColor(.white)
                            .font(.custom("Soulcraft_Wide", size: 30.0))
                            .frame(maxWidth: 225, minHeight: 52)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
    
}

struct BlurredBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.ritmoBlue, Color.ritmoOrange]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blur(radius: 50) // Adjust the blur radius as needed
        .ignoresSafeArea() // Ensures the background extends to the edges of the display
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
