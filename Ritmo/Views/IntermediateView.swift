//
//  IntermediateView.swift
//  Ritmo
//
//  Created by Aidan York on 3/15/24.
//

import SwiftUI

struct IntermediateView: View {
    var body: some View {
        TabView {
            VStack {
                Text("R!TMO")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HomeView()
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            MusicView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Play")
                }
            FriendsView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Friends")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    IntermediateView()
        .environment(GameModel().self)
}
