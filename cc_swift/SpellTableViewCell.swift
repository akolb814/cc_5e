//
//  SpellTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class SpellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var spellName:UILabel!
    @IBOutlet weak var spellSchool:UILabel!
    @IBOutlet weak var castingTime:UILabel!
    @IBOutlet weak var range:UILabel!
    @IBOutlet weak var components:UILabel!
    @IBOutlet weak var duration:UILabel!
    @IBOutlet weak var concentration:UILabel!
    @IBOutlet weak var spellDescription:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Delete Weapon
    @IBAction func deleteAction(button: UIButton) {
        
    }

}
