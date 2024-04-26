//
//  HighScoreManager.swift
//  Ritmo
//
//  Created by Aidan York on 3/30/24.
//

import Foundation

// Define a struct to hold both the song and its score
struct SongScore: Codable {
    let song: Item
    var songArtist: String
    var songName: String  // Assuming Item is Codable
    var score: Int
}

class HighScoreManager {
    static let shared = HighScoreManager()
    private let key = "HighScores"
    private let topKey = "TopHighScores"  // Key for top 3 scores

    func addScore(song: Item, score: Int) {
        var scores = getAllScores()
        if let index = scores.firstIndex(where: { $0.songArtist == song.artist && $0.songName == song.name }) {
            // Song exists, update score
            scores[index].score += score  // Use just `score` if you want to replace the score instead of adding
        } else {
            // Song does not exist, create a new entry
            let newScore = SongScore(song: song, songArtist: song.artist, songName: song.name, score: score)
            scores.append(newScore) // Appending then sorting, instead of inserting at 0
        }
        
        // Sort the scores in descending order
        scores.sort { $0.score > $1.score }
        
        // Store the updated list of all SongScore objects
        saveScores(scores, forKey: key)
        
        // Update and store only the top 3 scores
        let topScores = Array(scores.prefix(3))
        saveScores(topScores, forKey: topKey)
    }

    func getAllScores() -> [SongScore] {
        return loadScores(forKey: key)
    }

    func getHighScores() -> [SongScore] {
        return loadScores(forKey: topKey)
    }

    private func saveScores(_ scores: [SongScore], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scores) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadScores(forKey key: String) -> [SongScore] {
        if let savedScores = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([SongScore].self, from: savedScores) {
                return loadedScores
            }
        }
        return []
    }
}
