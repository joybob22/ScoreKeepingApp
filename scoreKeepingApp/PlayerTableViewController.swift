//
//  PlayerTableViewController.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 10/19/21.
//

import UIKit

class PlayerTableViewController: UITableViewController, NewPlayerData {

    @IBOutlet var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayerData.listener = self
    }
    
    // Delegation methods
    
    func movePlayer(start: Int, to: Int) {
        tableView.moveRow(at: IndexPath(row: start, section: 0), to: IndexPath(row: to, section: 0))
        tableView.reloadRows(at: [IndexPath(row: to, section: 0)], with: .automatic)
    }
    
    func addPlayer(to: Int) {
        tableView.insertRows(at: [IndexPath(row: to, section: 0)], with: .left)
    }
    
    // Segue method
    
    @IBSegueAction func addEditSegue(_ coder: NSCoder, sender: Any?) -> UIViewController? {
        // TODO check to see if we are in the edit segue or the add segue (refer to emoji project) and send the correct player if in the edit segue and nil if in the add segue.
        if let cell = sender as? CustomPlayerTableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            return AddEditPlayerViewController(coder: coder, player: PlayerData.currentPlayers[indexPath.row])
        }
        
        return AddEditPlayerViewController(coder: coder, player: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerData.currentPlayers.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! CustomPlayerTableViewCell
        
        let currentPlayer = PlayerData.currentPlayers[indexPath.row]
        cell.configurePlayerCell(player: currentPlayer)

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            PlayerData.delete(index: indexPath.row)
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "EditPlayer" {
//            segue.destination
//        }
//    }


}
