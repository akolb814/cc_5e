//
//  ArmorTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class ArmorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var armorName: UILabel!
    @IBOutlet weak var armorValue: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descView: UITextView!
    @IBOutlet weak var amountLabel: UILabel!
    
    // Delete Armor
    @IBAction func deleteAction(button: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
