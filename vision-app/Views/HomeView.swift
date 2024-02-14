//
//  HomeView.swift
//  vision-app
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
                                .background(Color.clear.opacity(0.8))
                                .cornerRadius(10)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
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
    }
    
    private func multicolorBackground() -> some View {
        ZStack {
            Capsule()
                .fill(Color.pink.opacity(0.5))
                .blur(radius: 50)
                .offset(x: 10, y: -100)
                .rotationEffect(Angle(degrees: colorCycle))
            Circle()
                .fill(Color.green.opacity(0.5))
                .blur(radius: 50)
                .offset(x: 100, y: 100)
                .rotationEffect(Angle(degrees: -colorCycle))
            Rectangle()
                .fill(Color.blue.opacity(0.5))
                .blur(radius: 50)
                .offset(x: -300, y: 50)
                .rotationEffect(Angle(degrees: colorCycle))
            Circle()
                .fill(Color.red.opacity(0.5))
                .blur(radius: 50)
                .offset(x: 300, y: 100)
                .rotationEffect(Angle(degrees: -colorCycle))
            Ellipse()
                .fill(Color.orange.opacity(0.5))
                .blur(radius: 50)
                .offset(x: 175, y: -400)
                .rotationEffect(Angle(degrees: colorCycle))
            Rectangle()
                .fill(Color.teal.opacity(0.5))
                .blur(radius: 50)
                .offset(x: -75, y: 400)
                .rotationEffect(Angle(degrees: -colorCycle))
            Circle()
                .fill(Color.orange.opacity(0.5))
                .blur(radius: 50)
                .offset(x: -110, y: 260)
                .rotationEffect(Angle(degrees: colorCycle))
            Rectangle()
                .fill(Color.green.opacity(0.5))
                .blur(radius: 50)
                .offset(x: -150, y: 275)
                .rotationEffect(Angle(degrees: colorCycle))
            Circle()
                .fill(Color.red.opacity(0.5))
                .blur(radius: 50)
                .offset(x: -250, y: 50)
                .rotationEffect(Angle(degrees: -colorCycle))
            Circle()
                .fill(Color.yellow.opacity(0.5))
                .blur(radius: 50)
                .offset(x: 100, y: 275)
                .rotationEffect(Angle(degrees: colorCycle))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 30).repeatForever()) {
                colorCycle = 720
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

