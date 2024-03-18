//
//  SnapCarouselView.swift
//  Ritmo
//
//  Created by Aidan York on 3/16/24.
//

import SwiftUI
import MusicKit

struct SnapCarouselView: View {
    @State private var currentIndex: Int
    @State private var cards: [Item]
    @State private var selectedCardID: UUID?

    init() {
        let recentlyPlayed = RecentlyPlayedManager.shared.getRecentlyPlayedSongs()
        _cards = State(initialValue: recentlyPlayed)
        _selectedCardID = State(initialValue: recentlyPlayed.first?.id)
        _currentIndex = State(initialValue: 0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ForEach(cards.indices, id: \.self) { index in
                    let card = cards[index]
                    // Break down the offset calculation
                    let totalWidth = geometry.size.width
                    let cardWidth = totalWidth / CGFloat(cards.count)
                    let halfTotalWidth = totalWidth / 2
                    let halfCardWidth = cardWidth / 2
                    let currentIndexOffset = CGFloat(currentIndex) * cardWidth
                    let indexOffset = CGFloat(index) * cardWidth
                    let offset = halfTotalWidth - currentIndexOffset - halfCardWidth + indexOffset

                    CarouselCardView(card: card, selectedCardID: selectedCardID, geometry: geometry)
                        .offset(x: offset, y: 0)
                        .zIndex(selectedCardID == card.id ? 1 : 0) // Adjust this if needed based on your selection logic
                }
            }
            .gesture(
                            DragGesture()
                                .onEnded { value in
                                    updateCurrentIndexAndSelectedCardID(with: value.translation.width)
                                }
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
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
    
    var body: some View {
        ArtworkImage(card.artwork, width: 400)
            .scaledToFit()
            .frame(width: 400, height: 400)
            .clipShape(Circle())
            .opacity(card.id == selectedCardID ? 1.0 : 0.7)
            .scaleEffect(card.id == selectedCardID ? 1.0 : 0.8)
            .grayscale(card.id == selectedCardID ? 0.0 : 1.0)
    }
}

struct SnapCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselView()
    }
}
