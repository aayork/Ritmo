//
//  HomeView.swift
//  MusicSpace
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct RecentlyPlayedSong: Identifiable {
    var id = UUID()
    var title: String
    var artist: String
}

struct HomeView: View {
    @State private var recentlyPlayedSongs: [RecentlyPlayedSong] = [
        RecentlyPlayedSong(title: "Song 1", artist: "Artist 1"),
        RecentlyPlayedSong(title: "Song 2", artist: "Artist 2"),
        RecentlyPlayedSong(title: "Song 3", artist: "Artist 3"),
        RecentlyPlayedSong(title: "Song 4", artist: "Artist 4"),
    ]
    
    let highScore = 100 // Example high score
    
    @State private var colorCycle = 0.0
    
    var body: some View {
        ZStack {
            multicolorBackground()
            contentStack
        }
        .padding()
    }
    
    private var contentStack: some View {
        HStack {
            VStack(alignment: .center) {
                Text("Welcome to MusicSpace")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                Text("Recent Songs")
                    .font(.title3)
                    .padding(.bottom, 8)
                
                ScrollView {
                    LazyVStack {
                        ForEach(recentlyPlayedSongs) { song in
                            HStack {
                                Text("\(song.title) - \(song.artist)")
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                    // Handle play button action
                                    print("Play \(song.title)")
                                }) {
                                    Image(systemName: "play.circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding()
                                .background(Color.clear.opacity(0.9))
                                .cornerRadius(10)
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.15))
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            
            VStack {
                Text("High Score")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                Text("\(highScore)")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .background(
            Rectangle() // This rectangle serves as the background
                .foregroundColor(.black) // Set the color of the rectangle
                .blur(radius: 25.0) // Apply a blur effect to create a soft look
                .opacity(0.2) // Adjust opacity for a more subtle effect
        )
        .cornerRadius(10) // Apply corner radius if desired
        .padding() // Adjust padding to ensure it aligns well with your layout
        .padding(-32)
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
