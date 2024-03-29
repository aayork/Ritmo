//
//  SnapCarouselView.swift
//  Ritmo
//
//  Created by Aidan York on 3/16/24.
//

import SwiftUI
import MusicKit
import RealityKit
import RealityKitContent

struct SnapCarouselView: View {
    @State private var currentIndex: Int
    @State private var cards: [Item]
    @State private var selectedCardID: UUID?

    init() {
        let recentlyPlayed = RecentlyPlayedManager.shared.getRecentlyPlayedSongs()
        let firstIndex = 0
        _cards = State(initialValue: recentlyPlayed)
        _currentIndex = State(initialValue: max(0, firstIndex)) // Ensure it's not negative
        _selectedCardID = State(initialValue: recentlyPlayed.indices.contains(firstIndex) ? recentlyPlayed[firstIndex].id : nil)
    }
    
    var body: some View {
        VStack {
            if cards.count == 5 {
                Text("RECENTLY PLAYED")
                    .font(.custom("Soulcraft_Wide", size: 50.0))
                    .padding()
                    .padding(.bottom, 8)
                    .frame(alignment: .topLeading)
                    .foregroundStyle(Color.electricLime)
            } else {
                VStack {
                    Text("WELCOME")
                        .font(.custom("Soulcraft_Wide", size: 50.0))
                        .padding()
                        .padding(.bottom, 8)
                        .frame(alignment: .topLeading)
                        .foregroundStyle(Color.electricLime)
                       
                    
                    Model3D(named: "Beethoven", bundle: realityKitContentBundle) { model in
                         model
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             // .rotation3DEffect(Angle(degrees: Double(180.0)), anchor: <#T##UnitPoint3D#>)
                     } placeholder: {
                         Text("Beethoven")
                     }
                     
                    /*
                    
                    RealityView { content in
                        if let beethoven = try? await ModelEntity(named: "Beethoven", in: realityKitContentBundle) {
                                    content.add(beethoven)
                            beethoven.scale /= 10
                                }
                                Task {
                                    
                                }
                            }
                     */
                    
                    
                    Text("Welcome to Ritmo! blurb goes here (or 3d beethoven?)")
                }
            }
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
                                .offset(x: offset, y: 0)
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
                // .blur(radius: distanceFromCenter / 100) // Apply blur based on distance
                .scaleEffect(card.id == selectedCardID ? 1.0 : 0.8)
                // .grayscale(card.id == selectedCardID ? 0.0 : 1.0)
                .opacity(max(0, 1 - (Double(distanceFromCenter) / 450)))
            if (card.id == selectedCardID) {
                HStack {
                    Text(card.name)
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text(" - ")
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                    Text(card.artist)
                        .font(.custom("FormaDJRMicro-Bold", size: 17.0))
                }
                .padding()
            }
        }
    }
}


struct SnapCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselView()
    }
}
