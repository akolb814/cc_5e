//
//  SpellLevelTableViewCell.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit

class SpellLevelTableViewCell: UITableViewCell {
    
    var spellLevelContent: Spells_by_Level!
    var parentViewController: UIViewController!
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
        let title = "Level " + String(spellLevelContent.level) + " Spells"
        let alertController = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
        if spellLevelContent.remaining_slots != 0 {
            alertController.addAction(UIAlertAction.init(title: "Use spell slot", style: .default, handler: { (action:UIAlertAction) in
                self.spellLevelContent.remaining_slots -= 1
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"SpellSlotUpdate"), object: nil, userInfo: nil)
            }))
        }
        
        if spellLevelContent.remaining_slots != spellLevelContent.total_slots {
            alertController.addAction(UIAlertAction.init(title: "Regain spell slot", style: .default, handler: { (action:UIAlertAction) in
                self.spellLevelContent.remaining_slots += 1
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"SpellSlotUpdate"), object: nil, userInfo: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction.init(title: "Reset spell slots", style: .default, handler: { (action:UIAlertAction) in
            self.spellLevelContent.remaining_slots = self.spellLevelContent.total_slots
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"SpellSlotUpdate"), object: nil, userInfo: nil)
        }))
        
        parentViewController.present(alertController, animated:true, completion: nil)
    }
}
