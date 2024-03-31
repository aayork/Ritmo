//
//  HighScoreManager.swift
//  Ritmo
//
//  Created by Aidan York on 3/30/24.
//

import Foundation

// Define a struct to hold both the song and its score
struct SongScore: Codable {
    let song: Item  // Assuming Item is Codable
    let score: Int
}

class HighScoreManager {
    static let shared = HighScoreManager()
    private let key = "HighScores"

    func addScore(song: Item, score: Int) {
        var scores = getHighScores()
        
        // Create a new SongScore object and add it at the beginning of the list
        let newScore = SongScore(song: song, score: score)
        scores.insert(newScore, at: 0)
        
        // Store the updated list of SongScore objects
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scores) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func getHighScores() -> [SongScore] {
        if let savedScores = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([SongScore].self, from: savedScores) {
                return loadedScores
            }
        }
        return []
    }
}
