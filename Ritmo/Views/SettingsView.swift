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
        VStack {
            Text("SETTINGS")
                .font(.custom("Soulcraft_Wide", size: 50.0))
                .padding()
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .top)
                .foregroundStyle(Color.electricLime)
            
            VStack {
                // Volume Slider
                Slider(value: $volume, in: 0...100)
                    .accentColor(Color.electricLime)
                    .padding()
                
                // Control Buttons
                HStack {
                    Button("GESTURES") {}
                    Button("AUDIO") {}
                    Button("GUIDES") {}
                }
                .font(.custom("Soulcraft_Wide", size: 30.0))
                .foregroundColor(Color.electricLime)
            }
            .frame(width: 1000, height: 400)
            .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
            .cornerRadius(20)
            .opacity(0.5)
            
            HStack {
                Button("CREDITS") {}
                    .font(.custom("Soulcraft_Wide", size: 30.0))
                    .padding(20)
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .clipShape(Capsule())
                    .offset(x: 325)
                Spacer()
                
                Button("TUTORIAL") {}
                    .font(.custom("Soulcraft_Wide", size: 30.0))
                    .padding(20)
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .clipShape(Capsule())
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
