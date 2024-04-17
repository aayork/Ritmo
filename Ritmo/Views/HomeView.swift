//
//  HomeView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

/*
 IF YOU NEED TO USE A CUSTOM FONT; THESE ARE THEIR NAMES:
 
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
    var coverImageName: String
}

struct HomeView: View {
    @Binding var tabSelection: Int
    
    @State private var highScores: [SongScore] = HighScoreManager.shared.getHighScores()
    
    var body: some View {
        ZStack {
            BlurredBackground()
            contentStack
        }
        .padding()
    }
    
    private var contentStack: some View {
        HStack {
            if (RecentlyPlayedManager.shared.getRecentlyPlayedSongs().count >= 5) {
                VStack {
                    Image("ritmoYellow")
                    Button("HOW TO PLAY", action: {
                        // Open tutorial here
                    })
                    .buttonStyle(GrayButtonStyle())
                    
                    VStack {
                        Text("HIGH SCORES")
                            .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                            .padding(1)
                        
                        if highScores.isEmpty {
                            Text("There are no high scores yet")
                                .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                                .foregroundStyle(Color.white)
                        } else {
                            ForEach(highScores, id: \.song.id) { score in
                                VStack {
                                    Text("\(score.songName) - \(score.songArtist)")
                                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                                        .foregroundStyle(Color.electricLime)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                    Text("Score: \(score.score)")
                                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                }
                            }
                        }
                    }
                    .frame(width: 300, height: 250.0)
                    .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)).opacity(0.8))
                    .cornerRadius(20)
                    .padding(.vertical, 7)
                    
                    VStack {
                        Text("OUR PICKS")
                            .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                            .padding(1)
                        Text("SOMETHING IN THE ORANGE")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("Zach Bryan")
                            .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("LAKE SHORE DRIVE")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("Aliotta Haynes Jeremiah")
                            .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("PARTY IN THE U.S.A.")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("Miley Cirus")
                            .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                    }
                    .frame(width: 300, height: 250.0)
                    .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)).opacity(0.8))
                    .cornerRadius(20)
                }
                .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                VStack(alignment: .center) {
                    SnapCarouselView()
                        .zIndex(2.0)
                    Spacer()
                    
                    Button("PLAY NOW", action: {
                        tabSelection = 2
                    })
                    .buttonStyle(YellowButtonStyle())
                    Spacer()
                }
            } else {
                HStack {
                    VStack {
                        Spacer()
                        Text("Welcome to")
                            .font(.custom("Soulcraft_Slanted-Wide", size: 40.0))
                            .multilineTextAlignment(.center) // Ensure text is centered if it wraps
                        Image("ritmoYellow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 600)
                        Spacer()
                        Button("Get Started", action: {
                            tabSelection = 3
                        })
                        .buttonStyle(YellowButtonStyle())
                        .padding(.vertical)
                        Button("PLAY NOW", action: {
                            tabSelection = 2
                        })
                        .buttonStyle(GrayButtonStyle())
                        Spacer()
                    }
                    .frame(maxWidth: .infinity) // Use all available horizontal space
                }
                .frame(maxWidth: .infinity, alignment: .center) // Ensure HStack uses all available space and centers content
            }
            
            Spacer()
        }
    }
    
    struct GrayButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .frame(width: 300)
                .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)).opacity(0.8))
                .hoverEffect()
                .cornerRadius(20)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: configuration.isPressed ? 3 : 0)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    struct YellowButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.custom("Soulcraft_Wide", size: 40.0))
                .padding()
                .background(Rectangle().fill(Color.electricLime))
                .hoverEffect()
                .cornerRadius(20)
                .foregroundStyle(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: configuration.isPressed ? 3 : 0)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
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
}
