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
    
    
    
    @State var letterWidths: [Int:Double] = [:]
    
        
    @State var title = "RECENTLY PLAYED"
    
    let letterAngle = 500 * ((2 * .pi) / 1256.64) // Cumulative width of letters up to this point times the angle per unit

    
    var lettersOffset: [(offset: Int, element: Character)] {
        return Array(title.enumerated())
    }
    var radius = 700.0
    
    
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
            VStack { // Info Stack
                Image("ritmoYellow")
                    // .offset(y: -200)
                Button(action: {
                    Task {
                        SettingsView()
                    }
                }) {
                    Text("HOW TO PLAY")
                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                        .padding()
                        .frame(width: 300)
                        .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                        .cornerRadius(20)
                }
                .frame(width: 300)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                .buttonStyle(PlainButtonStyle())
                .font(.largeTitle)
                .cornerRadius(20)
                // .offset(y: -200)
                
                
                
                VStack {
                    Text("HIGH SCORES")
                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                        .padding()
                }
                .frame(width: 300, height: 250.0)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)))
                .cornerRadius(20)
                // .offset(y: -200)
               
                
                VStack {
                    Text("POPULAR TRACKS")
                        .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                        .padding()
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
                // .offset(y: -200)
              
                
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
                    
                    
                    /* My attempt at curved lettering:
                    
                    
                    ZStack {
                        ForEach(lettersOffset, id: \.offset) { index, letter in // Mark 1
                            VStack {
                                Text(String(letter))
                                    .font(.custom("Soulcraft_Wide", size: 50.0))
                                    .foregroundColor(.electricLime)
                                    .kerning(700)
                                    .background(LetterWidthSize()) // Mark 2
                                    .onPreferenceChange(WidthLetterPreferenceKey.self, perform: { width in  // Mark 2
                                        letterWidths[index] = width
                                    })
                                        Spacer() // Mark 1
                                    }
                                    .rotationEffect(fetchAngle(at: index)) // Mark 3
                                }
                            }
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(240))
                    */ // It was a failed attempt.
                    
                    
                    
                    SnapCarouselView()
                        .zIndex(2.0)
                    
                    Button(action: {
                        tabSelection = 2
                    }) {
                        Text("PLAY NOW!")
                            .font(.custom("Soulcraft_Wide", size: 50.0))
                            .padding()
                            .background(Rectangle().fill(Color.electricLime))
                            .foregroundStyle(Color.black)
                            .cornerRadius(20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .font(.largeTitle)
                    .cornerRadius(20)
                }
            }
        } // HStack
        
        
        
    }
    
    func fetchAngle(at letterPosition: Int) -> Angle {
            let times2pi: (Double) -> Double = { $0 * 2 * .pi }
            
            let circumference = times2pi(radius)
                            
            let finalAngle = times2pi(letterWidths.filter{$0.key <= letterPosition}.map(\.value).reduce(0, +) / circumference)
            
            return .radians(finalAngle)
        }
    
    
    struct WidthLetterPreferenceKey: PreferenceKey {
        static var defaultValue: Double = 0
        static func reduce(value: inout Double, nextValue: () -> Double) {
            value = nextValue()
        }
    }

    struct LetterWidthSize: View {
        var body: some View {
            GeometryReader { geometry in // using this to get the width of EACH letter
                Color
                    .clear
                    .preference(key: WidthLetterPreferenceKey.self,
                                value: geometry.size.width)
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
