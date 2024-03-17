//
//  HomeView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct RecentlyPlayedSong: Identifiable {
    var id = UUID()
    var title: String
    var artist: String
    // Assume each song has an associated cover art image named in your asset catalog
    var coverImageName: String
}

struct HomeView: View {
    @State private var recentlyPlayedSongs: [RecentlyPlayedSong] = [
        RecentlyPlayedSong(title: "Song 1", artist: "Artist 1", coverImageName: "cover1"),
        RecentlyPlayedSong(title: "Song 2", artist: "Artist 2", coverImageName: "cover2"),
        RecentlyPlayedSong(title: "Song 3", artist: "Artist 3", coverImageName: "cover3"),
        RecentlyPlayedSong(title: "Song 4", artist: "Artist 4", coverImageName: "cover4"),
    ]
    
    var body: some View {
        ZStack {
            multicolorBackground()
            contentStack
        }
        .padding()
        .glassBackgroundEffect(
         in: RoundedRectangle(
             cornerRadius: 50,
             style: .continuous
         )
        )
    }
    
    private var contentStack: some View {
        HStack {
            Text("R!TMO")
                .font(.title)
                .padding(100)
                .frame(alignment: .topLeading)
            HStack {
                VStack(alignment: .center) {
                    Text("Recent Songs")
                        .font(.title3)
                        .padding(.bottom, 8)
                        .frame(alignment: .topLeading)
                    SnapCarouselView()
                    Button(action: {
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


#Preview {
    HomeView()
}
