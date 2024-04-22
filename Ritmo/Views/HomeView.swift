//
//  HomeView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI
import MusicKit

struct RecentlyPlayedSong: Identifiable {
    var id = UUID()
    var title: String
    var artist: String
    var coverImageName: String
}

struct HomeView: View {
    @State var tabSelection = 1
    @EnvironmentObject var gameModel: GameModel
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State var selectedSong: Item?
    @State var currentIndex: Int
    @State private var cards: [Item]
    @State private var selectedCardID: UUID?
    @State private var showWelcomeModal = false
    
    @State private var highScores: [SongScore] = HighScoreManager.shared.getHighScores()
    
    init() {
        let recentlyPlayed = RecentlyPlayedManager.shared.getRecentlyPlayedSongs()
        let firstIndex = 0
        _cards = State(initialValue: recentlyPlayed)
        _currentIndex = State(initialValue: max(0, firstIndex)) // Ensure it's not negative
        _selectedCardID = State(initialValue: recentlyPlayed.indices.contains(firstIndex) ? recentlyPlayed[firstIndex].id : nil)
    }
    
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
                        Text("Miley Cyrus")
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
                    VStack {
                        Text("RECENTLY PLAYED")
                            .font(.custom("Soulcraft_Wide", size: 50.0))
                            .padding()
                            .frame(alignment: .topLeading)
                            .foregroundStyle(Color.electricLime)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .center) {
                                if (cards.count == 5) {
                                    ForEach(cards.indices, id: \.self) { index in
                                        let card = cards[index]
                                        let totalWidth = geometry.size.width
                                        let cardWidth = totalWidth / CGFloat(cards.count)
                                        let halfTotalWidth = totalWidth / 2
                                        let halfCardWidth = cardWidth / 2
                                        let currentIndexOffset = CGFloat(currentIndex) * cardWidth
                                        let indexOffset = CGFloat(index) * cardWidth
                                        let offset = halfTotalWidth - currentIndexOffset - halfCardWidth + indexOffset
                                        
                                        // Calculate the distance from the center to adjust opacity and blur
                                        let distanceFromCenter = abs(halfTotalWidth - (offset + halfCardWidth))
                                        
                                        CarouselCardView(card: card, selectedCardID: selectedCardID, geometry: geometry, distanceFromCenter: distanceFromCenter)
                                            .offset(x: offset - 20, y: 0)
                                        // Calculate zIndex based on how close the item is to the currently selected item
                                            .zIndex(Double(cards.count - abs(currentIndex - index)))
                                        
                                    }
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        updateCurrentIndexAndSelectedCardID(with: value.translation.width)
                                    }
                            )
                        }
                        .padding()
                        .offset(x: -110)
                    }
                    .zIndex(2.0)
                    Spacer()
                    
                    Button("PLAY NOW", action: {
                        Task {
                            let song = gameModel.recentlyPlayed.getRecentlyPlayedSongs()[currentIndex]
                            gameModel.selectedSong = song
                            print("selected song:",gameModel.selectedSong!)
                            gameModel.curated = gameModel.immsersiveView?.testJSON(songName: song.name) != nil
                            await openImmersiveSpace(id: "ImmersiveSpace")
                        }
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
    
    private func updateCurrentIndexAndSelectedCardID(with translationWidth: CGFloat) {
        let threshold: CGFloat = 100
        let offset = translationWidth
        
        withAnimation(Animation.spring()) {
            if offset < -threshold {
                currentIndex = min(currentIndex + 1, cards.count - 1)
            } else if offset > threshold {
                currentIndex = max(currentIndex - 1, 0)
            }
            selectedCardID = cards[currentIndex].id
        }
    }
}

struct CarouselCardView: View {
    let card: Item
    let selectedCardID: UUID?
    let geometry: GeometryProxy
    let distanceFromCenter: CGFloat
    
    var body: some View {
        VStack {
            ArtworkImage(card.artwork, width: 400)
                .scaledToFit()
                .frame(width: 400, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .scaleEffect(max(0.4, 1 - (Double(distanceFromCenter) / 700)))
                .opacity(max(0, 1 - (Double(distanceFromCenter) / 600)))
            if (card.id == selectedCardID) {
                HStack {
                    Text("\(card.name) - \(card.artist)")
                        .font(.custom("FormaDJRMicro-Bold", size: 24.0))
                        .frame(width: 400)
                        .lineLimit(2)
                }
                .padding()
            }
        }
    }
}
