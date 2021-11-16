//
//  Player.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 10/19/21.
//

import Foundation

struct Player: Equatable, Comparable, Codable {
    var name: String
    var score: Int
    var id: UUID = UUID()
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.score == rhs.score
    }
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.score < rhs.score
    }
    
    private static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static var archiveURL = documentsDirectory.appendingPathComponent("player_data").appendingPathExtension("plist")
    
    static func saveData(players: [Player]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedPlayers = try? propertyListEncoder.encode(players)
        try? encodedPlayers?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadData() -> [Player] {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedPlayersData = try? Data(contentsOf: archiveURL),
           let players = try? propertyListDecoder.decode(Array<Player>.self, from: retrievedPlayersData) {
            return players
        }
        return []
    }
}
