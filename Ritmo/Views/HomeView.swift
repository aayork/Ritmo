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
        
    @State var title = "RECENTLY PLAYED"
    
    var body: some View {
        ZStack {
            contentStack
        }
        .padding()
        .background(Color.gunmetalGray.opacity(0.8))
    }
    
    private var contentStack: some View {
        HStack {
            VStack {
                Image("ritmoYellow")
                Button("HOW TO PLAY", action: {
                    Task {
                        SettingsView()
                    }
                })
                .buttonStyle(StandardButtonStyle())
                
                VStack {
                    Text("HIGH SCORES")
                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                        .padding(1)
                    Text("1000 PTS")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Party in the U.S.A. - Miley Cirus")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text("850 PTS")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Wham bam Shang-A-Lang - Silver")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text("700 PTS")
                        .font(.custom("Soulcraft_Slanted-Condensed", size: 25.0))
                        .foregroundStyle(Color.electricLime)
                    Text("Moon - Kanye West")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                }
                .frame(width: 300, height: 250.0)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                .cornerRadius(20)
                
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
            
            HStack {
                VStack(alignment: .center) {
                    Text("RECENTLY PLAYED")
                        .font(.custom("Soulcraft_Wide", size: 50.0))
                        .padding()
                        .padding(.bottom, 8)
                        .frame(alignment: .topLeading)
                        .foregroundStyle(Color.electricLime)
                    
                    SnapCarouselView()
                        .zIndex(2.0)
                    
                    Button("PLAY NOW", action: {
                        tabSelection = 2
                    })
                    .buttonStyle(PlayButtonStyle())
                }
            }
        }
    }
    
    struct StandardButtonStyle: ButtonStyle {
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
    
    struct PlayButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.custom("Soulcraft_Wide", size: 50.0))
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
