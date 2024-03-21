//
//  SettingsView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("SETTINGS")
                .font(.custom("Soulcraft_Wide", size: 50.0))
                .padding()
                .padding(.bottom, 8)
                .frame(alignment: .topTrailing)
                .foregroundStyle(Color.electricLime)
            VStack {
                
            }
            .frame(width: 1000, height: 400)
            .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
            .cornerRadius(20)
            .opacity(0.5)
            
            HStack {
                Button("CREDITS") {
                    
                }
                .font(.custom("Soulcraft_Wide", size: 30.0))
                .padding(20)
                .padding(.horizontal)
                .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                .foregroundColor(.white)
                .opacity(0.5)
                Spacer()
                
                Button("TUTORIAL") {
                    
                }
                .font(.custom("Soulcraft_Wide", size: 30.0))
                .padding(20)
                .padding(.horizontal)
                .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                .foregroundColor(.white)
                .opacity(0.5)
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}
