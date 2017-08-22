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
    
    var level: Int!
    var parentViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Delete Spell
    @IBAction func deleteAction(button: UIButton) {
        let message = "Confirm removal of \""+spellName.text!+"\" from spellbook."
        let alertController = UIAlertController.init(title: "Remove Spell", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: { (action:UIAlertAction) in
            let spellcasting = Character.Selected.spellcasting
            let spellLevel = spellcasting?.spells_by_level?.allObjects[self.level] as! Spells_by_Level
            var spellToRemove: Spell!
            for spell: Spell in spellLevel.spells!.allObjects as! [Spell] {
                if spell.name == self.spellName.text {
                    spellToRemove = spell
                }
            }
            spellLevel.removeFromSpells(spellToRemove)
            spellcasting?.removeFromSpells_by_level(spellcasting?.spells_by_level?.allObjects[self.level] as! Spells_by_Level)
            spellcasting?.addToSpells_by_level(spellLevel)
            Character.Selected.spellcasting = spellcasting
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"SpellSlotUpdate"), object: nil)
        }))
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction) in
            
        }))
        
        parentViewController.present(alertController, animated:true, completion: nil)
    }

}
