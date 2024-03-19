//
//  HomeView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

/*
 IF YOU NEED TO USE A CUSTOM FONT, THESE ARE THEIR NAMES:
 
 Family: Forma DJR Micro
    - FormaDJRMicro-Regular
    - FormaDJRMicro-ExtraLight
    - FormaDJRMicro-Light
    - FormaDJRMicro-Medium
    - FormaDJRMicro-Bold
    - FormaDJRMicro-ExtraBold
    - FormaDJRMicro-Black
 
 Family: Soulcraft
    - Soulcraft
    - Soulcraft_Slanted-Condensed
    - Soulcraft_Wide
    - Soulcraft_Slanted-Wide
 
 */

struct RecentlyPlayedSong: Identifiable {
    var id = UUID()
    var title: String
    var artist: String
    // Assume each song has an associated cover art image named in your asset catalog
    var coverImageName: String
}

struct HomeView: View {
    @Binding var tabSelection: Int
    @State private var recentlyPlayedSongs: [RecentlyPlayedSong] = [
        RecentlyPlayedSong(title: "Song 1", artist: "Artist 1", coverImageName: "cover1"),
        RecentlyPlayedSong(title: "Song 2", artist: "Artist 2", coverImageName: "cover2"),
        RecentlyPlayedSong(title: "Song 3", artist: "Artist 3", coverImageName: "cover3"),
        RecentlyPlayedSong(title: "Song 4", artist: "Artist 4", coverImageName: "cover4"),
    ]
    
    var body: some View {
        ZStack {
            contentStack
        }
        .padding()
        .glassBackgroundEffect(
         in: RoundedRectangle(
             cornerRadius: 50,
             style: .continuous
         )
        )
        .background(Color.gunmetalGray.opacity(0.8))
    }
    
    private var contentStack: some View {
        HStack {
            VStack {
                Image("ritmoYellow")
                    .offset(y: -250)
                Button(action: {
                    Task {
                        SettingsView()
                    }
                }) {
                    Text("How to play")
                        .padding()
                        .background(Rectangle().fill(Color.black))
                }
                .buttonStyle(PlainButtonStyle())
                .font(.largeTitle)
                .cornerRadius(20)
                .offset(y: -240)
                .padding(.horizontal)
            }
            HStack {
                VStack(alignment: .center) {
                    Text("Recent Songs")
                        .font(.title3)
                        .padding(.bottom, 8)
                        .frame(alignment: .topLeading)
                    SnapCarouselView()
                    Button(action: {
                        tabSelection = 2
                    }) {
                        Text("Play Now")
                            .padding()
                            .background(Rectangle().fill(Color.green))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.largeTitle)
                    .cornerRadius(20)
                }
            }
        }
    }
    
    private func multicolorBackground() -> some View {
        ZStack {
            WaveAnimation()
        }
        .padding(-15)
    }
}


//#Preview {
    //HomeView()
//}
