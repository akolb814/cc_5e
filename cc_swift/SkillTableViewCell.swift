//
//  SkillTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/3/17.
//
//

import UIKit

class SkillTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var skillValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
