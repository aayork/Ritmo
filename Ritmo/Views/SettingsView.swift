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
            Color.gunmetalGray.opacity(0.8)
                            .edgesIgnoringSafeArea(.all) 
            VStack {
                Text("SETTINGS")
                    .font(.custom("Soulcraft_Wide", size: 50.0))
                    .padding()
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
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
                Text("Glory, Glory")
                    .font(.custom("Allura", size: 30.0))
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
