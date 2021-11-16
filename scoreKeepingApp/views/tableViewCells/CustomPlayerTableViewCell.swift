//
//  CustomPlayerTableViewCell.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 10/19/21.
//

import UIKit

class CustomPlayerTableViewCell: UITableViewCell {
    
    var playerId: UUID = UUID()
    var gameId: UUID = UUID()

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurePlayerCell(player: Player, gameId: UUID) {
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
        stepper.value = Double(player.score)
        playerId = player.id
        self.gameId = gameId
    }

    @IBAction func stepperTapped(_ sender: UIStepper) {
        playerScoreLabel.text = String(Int(sender.value))
//        PlayerData.edit(playerScore: Int(sender.value), playerId)
        GameData.updatePlayerAndSort(playerScore: Int(sender.value), playerId, gameId)
    }
}
