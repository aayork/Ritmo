//
//  SnapCarouselView.swift
//  Ritmo
//
//  Created by Aidan York on 3/16/24.
//

import SwiftUI

struct SnapCarouselView: View {
    @State private var currentIndex: Int
    
    let cards: [Card] = [
        Card(id: 0, color: Color.red),
        Card(id: 1, color: Color.green),
        Card(id: 2, color: Color.blue),
        Card(id: 3, color: Color.orange),
        Card(id: 4, color: Color.purple)
    ]
    
    // Initialize currentIndex to the middle item
    init() {
        _currentIndex = State(initialValue: cards.count / 2)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ForEach(cards.indices, id: \.self) { index in
                    let card = cards[index]
                    CarouselCardView(card: card, currentIndex: $currentIndex, geometry: geometry)
                        // Calculate offset to center the currently selected card
                        .offset(x: geometry.size.width / 2 - CGFloat(currentIndex) * (geometry.size.width / CGFloat(cards.count)) - (geometry.size.width / CGFloat(cards.count)) / 2 + CGFloat(index) * (geometry.size.width / CGFloat(cards.count)), y: 0)

                        .zIndex(currentIndex == card.id ? 1 : 0) // Ensure current card is on top
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 100 // Adjust as needed for sensitivity
                        let offset = value.translation.width
                        
                        withAnimation(Animation.spring()) {
                            if offset < -threshold {
                                currentIndex = min(currentIndex + 1, cards.count - 1)
                            } else if offset > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct Card: Identifiable {
    var id: Int
    var color: Color
}

struct CarouselCardView: View {
    let card: Card
    @Binding var currentIndex: Int
    let geometry: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(card.color)
            .frame(width: 300, height: 300)
            .opacity(card.id == currentIndex ? 1.0 : 0.6)
            .scaleEffect(card.id == currentIndex ? 1.0 : 0.8)
            .grayscale(card.id == currentIndex ? 0.0 : 1.0)
    }
}

// Preview
struct SnapCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselView()
    }
}
