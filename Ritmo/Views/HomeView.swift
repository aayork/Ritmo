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
            VStack(alignment: .center) {
                Text("Recent Songs")
                    .font(.title3)
                    .padding(.bottom, 8)
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(recentlyPlayedSongs) { song in
                            ZStack {
                                // Background circle with the song's cover art
                                
                                Circle()
                                    .foregroundColor(.black) // Set the circle's color to black
                                    .opacity(0.5) // Make the circle slightly transparent
                                    .frame(width: 500, height: 500) // Set the size of the circle
                                // Overlay with song title and play button
                                
                                // Cover image on top of the black circle
                                Image("coverart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 500, height: 500) // Ensure the image is the same size as the circle
                                    .clipShape(Circle())
                                
                                VStack {
                                    Text(song.title)
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .shadow(radius: 10)
                                    Button(action: {
                                        // Handle play button action
                                        print("Play \(song.title)")
                                    }){
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .font(.largeTitle)
                                    .cornerRadius(360)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
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
