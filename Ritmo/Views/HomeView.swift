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
    
    @State var title = "RECENTLY PLAYED"
    
    @State private var highScores: [SongScore] = HighScoreManager.shared.getHighScores()
    
    var body: some View {
        ZStack {
            contentStack
        }
        .padding()
        .background(Color.gunmetalGray.opacity(0.5))
    }
    
    private var contentStack: some View {
        HStack {
            VStack {
//                Image("ritmoYellow")
//                Button("HOW TO PLAY", action: {
//                    // Open tutorial here
//                })
//                .buttonStyle(GrayButtonStyle())
                
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
                                Text("Score: \(score.score)")
                                    .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                                    .foregroundStyle(Color.electricLime)
                                Text("\(score.songName) - \(score.songArtist)")
                                    .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    Spacer()
                }
                .frame(width: 300)
                .padding(.vertical)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                .cornerRadius(20)
                .padding(.vertical)
                
                VStack {
                    Text("OUR PICKS")
                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                        .padding(1)
                    Text("SOMETHING IN THE ORANGE")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Zach Bryan")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text("LAKE SHORE DRIVE")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Aliotta Haynes Jeremiah")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text("PARTY IN THE U.S.A.")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Miley Cirus")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                }
                .frame(width: 300, height: 250.0)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                .cornerRadius(20)
            }
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            //if (RecentlyPlayedManager.shared.getRecentlyPlayedSongs().count >= 5) {
            if (true) {
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
                VStack {
                    Spacer()
                    Text("Welcome to")
                        .font(.custom("Soulcraft_Slanted-Wide", size: 40.0))
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
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
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
}
