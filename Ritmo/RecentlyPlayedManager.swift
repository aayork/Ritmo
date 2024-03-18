//
//  RecentlyPlayedManager.swift
//  Ritmo
//
//  Created by Aidan York on 3/18/24.
//

import Foundation

class RecentlyPlayedManager {
    static let shared = RecentlyPlayedManager()
    private let key = "RecentlyPlayedSongs"
    private let maxCount = 5

    func addSong(song: Card) {
        var songs = getRecentlyPlayedSongs()
        songs.insert(song, at: 0) // Add new song at the beginning of the list
        if songs.count > maxCount {
            songs = Array(songs.prefix(maxCount)) // Keep only the first 5 items
        }
        // Store the updated list
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(songs) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    func getRecentlyPlayedSongs() -> [Card] {
        if let savedSongs = UserDefaults.standard.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedSongs = try? decoder.decode([Card].self, from: savedSongs) {
                return loadedSongs
            }
        }
        return []
    }
}

