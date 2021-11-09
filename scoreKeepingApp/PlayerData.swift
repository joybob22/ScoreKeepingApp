//
//  PlayerData.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 10/19/21.
//

import Foundation

protocol NewPlayerData {
    func movePlayer(start: Int, to: Int)
    func addPlayer(to: Int)
}


struct PlayerData {
    private(set) static var currentPlayers: [Player] = Player.loadData()
    
    static var listener: NewPlayerData? {
        didSet {
            sortPlayers()
        }
    }
    
    static func sortPlayers() {
        currentPlayers = currentPlayers.sorted(by: >)
    }
    
    static func addNew(player: Player) {
        var endIndex = -1
        currentPlayers.append(player)
        sortPlayers()
        for (index, possiblePlayer) in currentPlayers.enumerated() {
            if possiblePlayer.id == player.id {
                endIndex = index
            }
        }
        listener?.addPlayer(to: endIndex)
        Player.saveData(players: currentPlayers)
    }
    
    static func edit(player: Player) {
        var startIndex = -1
        var endIndex = -1
        for (index, possiblePlayer) in currentPlayers.enumerated() {
            if possiblePlayer.id == player.id {
                currentPlayers.remove(at: index)
                currentPlayers.insert(player, at: index)
                startIndex = index
            }
        }
        sortPlayers()
        for (index, possiblePlayer) in currentPlayers.enumerated() {
            if possiblePlayer.id == player.id {
                endIndex = index
            }
        }
        if startIndex != -1 && startIndex != endIndex {
            listener?.movePlayer(start: startIndex, to: endIndex)
        }
        Player.saveData(players: currentPlayers)
    }
    
    static func edit(playerScore: Int, _ playerId: UUID) {
        var startIndex = -1
        var endIndex = -1
        for (index, possiblePlayer) in currentPlayers.enumerated() {
            if possiblePlayer.id == playerId {
                currentPlayers[index].score = playerScore
                startIndex = index
            }
        }
        sortPlayers()
        for (index, possiblePlayer) in currentPlayers.enumerated() {
            if possiblePlayer.id == playerId {
                endIndex = index
            }
        }
        if startIndex != -1 && startIndex != endIndex {
            listener?.movePlayer(start: startIndex, to: endIndex)
        }
        Player.saveData(players: currentPlayers)
    }
    
    static func delete(index: Int) {
        currentPlayers.remove(at: index)
        Player.saveData(players: currentPlayers)
    }
    
}
