//
//  AddEditPlayerViewController.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 10/19/21.
//

import UIKit

protocol AddEditPlayerDelegate {
    func playerCreated(player: Player)
    func editedPlayer(player: Player)
}

class AddEditPlayerViewController: UIViewController {
    
    var player: Player?
    var delegate: AddEditPlayerDelegate?

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var currentScoreTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unWrappedPlayer = player {
            playerNameTextField.text = unWrappedPlayer.name
            currentScoreTextField.text = String(unWrappedPlayer.score)
            title = "Edit Player"
        } else {
            title = "Add New Player"
        }
    }
    
    init?(coder: NSCoder, player: Player?) {
        self.player = player
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //Form Validation
        if let playerName = playerNameTextField.text,
           let playerScore = currentScoreTextField.text,
           let intPlayerScore = Int(playerScore) {
            if !playerName.isEmpty {
                if var player = player {
                    //Edit existing player
                    player.name = playerName
                    player.score = intPlayerScore
//                    PlayerData.edit(player: player)
                    delegate?.editedPlayer(player: player)
                    navigationController?.popViewController(animated: true)
                } else {
                    //Create a new player
                    let newPlayer = Player(name: playerName, score: intPlayerScore)
//                    PlayerData.addNew(player: newPlayer)
                    delegate?.playerCreated(player: newPlayer)
                    navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
        
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
