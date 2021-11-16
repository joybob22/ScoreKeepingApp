//
//  AddEditGameViewController.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/12/21.
//

import UIKit

protocol AddGameDelegate {
    func gameAdded(game: Game)
}

protocol EditedGameDelegate {
    func gameEdited(game: Game)
}

class AddEditGameViewController: UIViewController, UITableViewDataSource, AddEditPlayerDelegate, UITableViewDelegate {
    
    var game: Game?
    var newPlayers: [Player] = []
    var delegate: AddGameDelegate?
    var editedDelegate: EditedGameDelegate?
    
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var whoWinsSegmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let game = game {
            gameTitleTextField?.text = game.name
            sortBySegmentedControl.selectedSegmentIndex = game.sortBy == .highestScore ? 0 : 1
            whoWinsSegmentedControl.selectedSegmentIndex = game.whoWins == .highestScore ? 0 : 1
            title = "Edit Game"
        }
    }
    
    init?(coder: NSCoder, game: Game?) {
        super.init(coder: coder)
        if let game = game {
            self.game = game
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Table View Specific functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let game = game {
            return game.players.count
        } else {
            return newPlayers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blandPlayerCell", for: indexPath) as! CustomBlandPlayerTableViewCell
        
        if let game = game {
            cell.configureCell(player: game.players[indexPath.row])
        } else {
            cell.configureCell(player: newPlayers[indexPath.row])
        }
        
        return cell
    }
    
    //MARK: - Delegate methods
    
    func playerCreated(player: Player) {
        if let game = game {
            self.game?.players.append(player)
            tableView.insertRows(at: [IndexPath(row: game.players.count, section: 0)], with: .left)
        } else {
            newPlayers.append(player)
            tableView.insertRows(at: [IndexPath(row: newPlayers.count - 1, section: 0)], with: .left)
        }
        
    }
    
    func editedPlayer(player: Player) {
        if let game1 = game{
            for (index, possiblePlayer) in game1.players.enumerated() {
                if possiblePlayer.id == player.id {
                    game?.players.remove(at: index)
                    game?.players.insert(player, at: index)
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        } else {
            for (index, possiblePlayer) in newPlayers.enumerated() {
                if possiblePlayer.id == player.id {
                    newPlayers.remove(at: index)
                    newPlayers.insert(player, at: index)
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let title = gameTitleTextField.text {
            if !title.isEmpty {
                if var game = game {
                    //Edit existing game
                    let sorting: Game.sorting = sortBySegmentedControl.selectedSegmentIndex == 0 ? .highestScore : .lowestScore
                    let whoWins: Game.winner = whoWinsSegmentedControl.selectedSegmentIndex == 0 ? .highestScore : .lowestScore
                    
                    game.name = title
                    game.sortBy = sorting
                    game.whoWins = whoWins
                    let updatedGame = GameData.sortPlayersAndSave(game: game)
                    editedDelegate?.gameEdited(game: updatedGame)
                    navigationController?.popViewController(animated: true)
                } else {
                    //Add new game
                    let sorting: Game.sorting = sortBySegmentedControl.selectedSegmentIndex == 0 ? .highestScore : .lowestScore
                    let whoWins: Game.winner = whoWinsSegmentedControl.selectedSegmentIndex == 0 ? .highestScore : .lowestScore
                    
                    
                    var newGame = Game(name: title, topPlayer: nil, players: newPlayers, sortBy: sorting, whoWins: whoWins)
                    
                    if newGame.players.count > 0 {
                        newGame = GameData.sortPlayersInNewGame(game: newGame)
                    }
                    
                    delegate?.gameAdded(game: newGame)
                    
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    @IBSegueAction func addNewPlayer(_ coder: NSCoder, sender: Any?) -> AddEditPlayerViewController? {
        let viewController = AddEditPlayerViewController(coder: coder, player: nil)
        
        viewController?.delegate = self
        
        return viewController
    }
    
    @IBSegueAction func editExistingPlayerSegue(_ coder: NSCoder, sender: Any?) -> AddEditPlayerViewController? {
        if let cell = sender as? CustomBlandPlayerTableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            tableView.deselectRow(at: indexPath, animated: true)
            if game != nil {
                let vc = AddEditPlayerViewController(coder: coder, player: self.game?.players[indexPath.row])
                vc?.delegate = self
                return vc
            } else {
                let vc = AddEditPlayerViewController(coder: coder, player: newPlayers[indexPath.row])
                vc?.delegate = self
                return vc
            }
            
        }
        
        return AddEditPlayerViewController(coder: coder, player: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
