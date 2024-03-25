//
//  FriendsView.swift
//  Ritmo
//
//  Created by Aidan York on 2/13/24.
//

import SwiftUI

struct FriendsView: View {
    
    struct Song: Identifiable {
        var id = UUID()
        var title: String
        var artist: String
        var score: Int
    }

    let songs = [
        Song(title: "Shape of You", artist: "Ed Sheeran", score: 85),
        Song(title: "Blinding Lights", artist: "The Weeknd", score: 92),
        Song(title: "Levitating", artist: "Dua Lipa", score: 88)
    ]
    
    let users = ["Aynur", "Jax", "Max", "Elisa", "Aidan"]
    
    let randomNumber = Int.random(in: 0...4)

    var body: some View {
        VStack {
            Text("Recent Friend Activity")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(50)
            List(songs) { song in
                HStack {
                    VStack(alignment: .leading) {
                        Text(users[randomNumber])
                            .font(.title3)
                            .foregroundColor(.orange)
                        HStack() {
                            Text(song.title)
                                .fontWeight(.bold)
                            Text("-")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(song.artist)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    Text("Score: \(song.score)")
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                .padding(5)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(20)
        }
    }
}


#Preview {
    FriendsView()
}
