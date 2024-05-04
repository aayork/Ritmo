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
    var coverImageName: String
}

struct HomeView: View {
    @Binding var tabSelection: Int
    @Environment(GameModel.self) var gameModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    var carousel = SnapCarouselView()
    
    @State private var highScores: [SongScore] = HighScoreManager.shared.getHighScores()
    @State var showTutorial = false
    
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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                    Button("HOW TO PLAY", action: {
                        self.showTutorial = true
                    })
                    .buttonStyle(GrayButtonStyle())
                    .sheet(isPresented: $showTutorial) {
                        TutorialView(showTutorial: $showTutorial)
                    }
                    
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
                        Text("LAKE SHORE DRIVE")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("Aliotta Haynes Jeremiah")
                            .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("BACK ON 74")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("Jungle")
                            .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("BACK IN BLACK")
                            .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                        Text("AC/DC")
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
                    carousel
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
                            self.showTutorial = true
                        })
                        .buttonStyle(YellowButtonStyle())
                        .padding(.vertical)
                        .sheet(isPresented: $showTutorial) {
                            TutorialView(showTutorial: $showTutorial)
                        }
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
                gradient: Gradient(colors: [Color.ritmoLightBlue, Color.ritmoOrange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 50) // Adjust the blur radius as needed
            .ignoresSafeArea() // Ensures the background extends to the edges of the display
        }
    }
    
    struct TutorialView: View {
        @Binding var showTutorial: Bool
        
        var body: some View {
            VStack {
                HStack {
                    Text("Welcome!").font(.custom("Soulcraft", size: 35.0))
                        .foregroundStyle(Color.electricLime)
                    Button("Done") {
                        self.showTutorial = false
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                VStack {
                    Text("To get started, please be sure you're signed in to an Apple Music account with an active subscription on your Apple Vision pro. From there, simply search for any song in the music tab to get started! Match your hands to the gestures on screen to earn points. Enjoy!")
                        .font(.custom("FormaDJRMicro-Medium", size: 17.0))
                }
            }
            .padding()
            .frame(width: 400, height: 300)
        }
    }
}
