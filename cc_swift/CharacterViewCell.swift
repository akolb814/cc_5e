//
//  CharacterViewCell.swift
//  cc_swift
//
//  Created by Rip Britton on 3/8/17.
//
//

import Foundation
import UIKit

class CharacterViewCell: UITableViewCell {
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        characterNameLabel.text = "Rogue Man"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
