//
//  CustomBlandPlayerTableViewCell.swift
//  scoreKeepingApp
//
//  Created by Brayden Lemke on 11/12/21.
//

import UIKit

class CustomBlandPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(player: Player) {
        playerLabel.text = player.name
    }

}
