//
//  GameTableViewController.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/12/21.
//

import UIKit

class GameTableViewController: UITableViewController, AddGameDelegate, EditedGameDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GameData.currentGames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! CustomGameTableViewCell

        let currentGame = GameData.currentGames[indexPath.row]
        
        cell.configureGameCell(gameId: currentGame.id, gameTitle: currentGame.name, currentWinner: currentGame.topPlayer)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delegate methods
    
    func gameAdded(game: Game) {
        GameData.addGame(game: game)
        tableView.insertRows(at: [IndexPath(row: GameData.currentGames.count - 1, section: 0)], with: .left)
    }
    
    func gameEdited(game: Game) {
        tableView.reloadData()
    }
    
    //Actions

    @IBSegueAction func addGameSegue(_ coder: NSCoder) -> AddEditGameViewController? {
        let viewController = AddEditGameViewController(coder: coder, game: nil)
        viewController?.delegate = self
        return viewController
    }
    
    @IBSegueAction func playerListSegue(_ coder: NSCoder, sender: Any?) -> PlayerTableViewController? {
        if let cell = sender as? CustomGameTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let vc = PlayerTableViewController(coder: coder, game: GameData.currentGames[indexPath.row])
            vc?.delegate = self
            return vc
        }
        let vc = PlayerTableViewController(coder: coder, game: nil)
        vc?.delegate = self
        return vc
    }
    


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            GameData.deleteGame(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
