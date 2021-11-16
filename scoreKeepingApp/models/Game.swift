//
//  Game.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/8/21.
//

import Foundation

struct Game: Codable {
    var name: String
    var topPlayer: Player?
    var players: [Player]
    var sortBy: sorting
    var whoWins: winner
    var id: UUID = UUID()
    
    enum sorting: Codable {
        case highestScore, lowestScore
    }
    
    enum winner: Codable {
        case highestScore, lowestScore
    }
}

//Data Saving/Retrieving Static functions for Game

extension Game {
    private static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    private static var archiveURL = documentsDirectory.appendingPathComponent("games_data").appendingPathExtension("plist")
    
    static func saveData(games: [Game]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedGames = try? propertyListEncoder.encode(games)
        try? encodedGames?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadData() -> [Game] {
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedGamesData = try? Data(contentsOf: archiveURL),
           let games = try? propertyListDecoder.decode(Array<Game>.self, from: retrievedGamesData) {
            return games
        }
        
        //Dummy data! Return an empty array when finished testing
        let player1 = Player(name: "Brayden", score: 72)
        let player2 = Player(name: "John", score: 76)
        let player3 = Player(name: "Mike", score: 80)
        return [
            Game(name: "Golf", topPlayer: player1, players: [player1,player2,player3], sortBy: .lowestScore, whoWins: .lowestScore),
            Game(name: "Basketball", topPlayer: player3, players: [player1, player2, player3], sortBy: .highestScore, whoWins: .highestScore)
        ]
    }
}
