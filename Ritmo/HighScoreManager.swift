//
//  HighScoreManager.swift
//  Ritmo
//
//  Created by Aidan York on 3/30/24.
//

import Foundation

class HighScoreManager {
    static let shared = HighScoreManager()
    private let key = "HighScores"

    func addSong(song: Item) {
        var scores = getHighScores()
        
        scores.insert(song, at: 0) // Add new score at beginning of list
        
        // Store the updated list of scores
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scores) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func getHighScores() -> [Item] {
        if let savedScores = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedScores = try? decoder.decode([Item].self, from: savedScores) {
                return loadedScores
            }
        }
        return []
    }
}
