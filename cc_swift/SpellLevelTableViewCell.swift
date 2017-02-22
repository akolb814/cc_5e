//
//  SpellLevelTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class SpellLevelTableViewCell: UITableViewCell {

    @IBOutlet weak var spellLevel:UILabel!
    @IBOutlet weak var spellSlots:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func spellSlotAction(button: UIButton) {
        
    }
}
