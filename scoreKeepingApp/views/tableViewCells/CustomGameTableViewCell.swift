//
//  CustomGameTableViewCell.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/8/21.
//

import UIKit

class CustomGameTableViewCell: UITableViewCell {
    
    var gameId: UUID?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentWinnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureGameCell(gameId: UUID, gameTitle: String, currentWinner: Player?) {
        self.gameId = gameId
        titleLabel.text = gameTitle
        if let currentWinner = currentWinner {
            currentWinnerLabel.text = "Current Winner: \(currentWinner.name)"
        } else {
            currentWinnerLabel.text = "Current Winner: None"
        }
    }

}
