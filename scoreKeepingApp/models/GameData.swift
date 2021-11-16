//
//  GameData.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/12/21.
//

import Foundation

protocol UpdatePlayer {
    func movePlayer(start: Int, to: Int, gameIndex: Int)
}


struct GameData {
    private(set) static var currentGames: [Game] = Game.loadData()
    
    static var updatePlayerScoreListener: UpdatePlayer?
    
    static func addGame(game: Game) {
        currentGames.append(game)
        Game.saveData(games: currentGames)
    }
    
    static func deleteGame(index: Int) {
        currentGames.remove(at: index)
        Game.saveData(games: currentGames)
    }
    
    static func sortPlayersInNewGame(game: Game) -> Game {
        var sortedGame = game
        if sortedGame.sortBy == .highestScore {
            sortedGame.players = sortedGame.players.sorted(by: >)
            if sortedGame.whoWins == .highestScore {
                sortedGame.topPlayer = sortedGame.players[0]
            } else {
                sortedGame.topPlayer = sortedGame.players[sortedGame.players.count - 1]
            }
        } else {
            sortedGame.players = sortedGame.players.sorted(by: <)
            if sortedGame.whoWins == .lowestScore {
                sortedGame.topPlayer = sortedGame.players[0]
            } else {
                sortedGame.topPlayer = sortedGame.players[sortedGame.players.count - 1]
            }
        }
        
        return sortedGame
        
    }
    
    static func updatePlayerAndSort(playerScore: Int, _ playerId: UUID, _ gameId: UUID) {
        var gameIndex: Int?
        var startIndex: Int?
        var endIndex: Int?
        for(index, aGame) in currentGames.enumerated() {
            if aGame.id == gameId {
                gameIndex = index
            }
        }
        
        if let gameIndex = gameIndex {
            for(index, aPlayer) in currentGames[gameIndex].players.enumerated() {
                if aPlayer.id == playerId {
                    startIndex = index
                    currentGames[gameIndex].players[index].score = playerScore
                }
            }
            
            if currentGames[gameIndex].sortBy == .highestScore {
                currentGames[gameIndex].players = currentGames[gameIndex].players.sorted(by: >)
                if currentGames[gameIndex].whoWins == .highestScore {
                    currentGames[gameIndex].topPlayer = currentGames[gameIndex].players[0]
                } else {
                    currentGames[gameIndex].topPlayer = currentGames[gameIndex].players[currentGames[gameIndex].players.count - 1]
                }
            } else {
                currentGames[gameIndex].players = currentGames[gameIndex].players.sorted(by: <)
                if currentGames[gameIndex].whoWins == .lowestScore {
                    currentGames[gameIndex].topPlayer = currentGames[gameIndex].players[0]
                } else {
                    currentGames[gameIndex].topPlayer = currentGames[gameIndex].players[currentGames[gameIndex].players.count - 1]
                }
            }
            
            for(index, aPlayer) in currentGames[gameIndex].players.enumerated() {
                if aPlayer.id == playerId {
                    endIndex = index
                }
            }
            if let startIndex = startIndex, let endIndex = endIndex {
                if startIndex != endIndex {
                    updatePlayerScoreListener?.movePlayer(start: startIndex, to: endIndex, gameIndex: gameIndex)
                }
            }
        }
        
        Game.saveData(games: currentGames)
        
        
        
        
    }
    
    static func sortPlayersAndSave(game: Game) -> Game {
        var sortedGame = game
        if sortedGame.sortBy == .highestScore {
            sortedGame.players = sortedGame.players.sorted(by: >)
        } else {
            sortedGame.players = sortedGame.players.sorted(by: <)
        }
        
        sortedGame.topPlayer = sortedGame.players[0]
        
        for(index, possibleGame) in currentGames.enumerated() {
            if possibleGame.id == sortedGame.id {
                currentGames.remove(at: index)
                currentGames.insert(sortedGame, at: index)
                Game.saveData(games: currentGames)
            }
        }
        
        return sortedGame
        
    }
    
}
