//
//  WeaponTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class WeaponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weaponName: UILabel!
    @IBOutlet weak var weaponReach: UILabel!
    @IBOutlet weak var weaponModifier: UILabel!
    @IBOutlet weak var weaponDamage: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descView: UITextView!
    @IBOutlet weak var amountLabel: UILabel!
    
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
