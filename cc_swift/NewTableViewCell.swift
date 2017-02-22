//
//  NewTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class NewTableViewCell: UITableViewCell {

    @IBOutlet weak var newLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
