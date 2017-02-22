//
//  SpellcastingViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class SpellcastingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Spell Attack
    @IBOutlet weak var saView: UIView!
    @IBOutlet weak var saTitle: UILabel!
    @IBOutlet weak var saValue: UILabel!
    @IBOutlet weak var saButton: UIButton!
    
    // Spell DC
    @IBOutlet weak var sdcView: UIView!
    @IBOutlet weak var sdcTitle: UILabel!
    @IBOutlet weak var sdcValue: UILabel!
    @IBOutlet weak var sdcButton: UIButton!
    
    // Caster Level
    @IBOutlet weak var clView: UIView!
    @IBOutlet weak var clTitle: UILabel!
    @IBOutlet weak var clValue: UILabel!
    @IBOutlet weak var clButton: UIButton!
    
    // Resource
    @IBOutlet weak var resourceView: UIView!
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var resourceValue: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    
    // Spell TableView
    @IBOutlet weak var spellsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var spellcastingDict: JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        spellsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        spellcastingDict = appDelegate.character.spellcasting
        
        self.setMiscDisplayData()
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setMiscDisplayData() {
        // Spell Attack
        var spellAttack = appDelegate.character.proficiencyBonus
        var spellDC = 8+appDelegate.character.proficiencyBonus
        let spellAbility = spellcastingDict["spell_ability"].string!
        switch spellAbility {
        case "STR":
            spellAttack += appDelegate.character.strBonus //Add STR bonus
            spellDC += appDelegate.character.strBonus
        case "DEX":
            spellAttack += appDelegate.character.dexBonus //Add DEX bonus
            spellDC += appDelegate.character.dexBonus
        case "CON":
            spellAttack += appDelegate.character.conBonus //Add CON bonus
            spellDC += appDelegate.character.conBonus
        case "INT":
            spellAttack += appDelegate.character.intBonus //Add INT bonus
            spellDC += appDelegate.character.intBonus
        case "WIS":
            spellAttack += appDelegate.character.wisBonus //Add WIS bonus
            spellDC += appDelegate.character.wisBonus
        case "CHA":
            spellAttack += appDelegate.character.chaBonus //Add CHA bonus
            spellDC += appDelegate.character.chaBonus
        default: break
        }
        
        spellAttack += spellcastingDict["spell_attack_misc_bonus"].int!
        spellDC += spellcastingDict["spell_dc_misc_bonus"].int!
        
        saValue.text = String(spellAttack)
        
        // Spell DC
        sdcValue.text = String(spellDC)
        
        // Caster Level
        clValue.text = String(spellcastingDict["caster_level"].int!)
        
        // Resource
        resourceTitle.text = appDelegate.character.spellcastingResource["name"].string
        
        let currentResourceValue: Int = appDelegate.character.spellcastingResource["current_value"].int!
        let maxResourceValue: Int = appDelegate.character.spellcastingResource["max_value"].int!
        let dieType: Int = appDelegate.character.spellcastingResource["die_type"].int!
        
        var resourceDisplay = ""
        if dieType == 0 {
            if maxResourceValue == 0 {
                resourceDisplay = String(currentResourceValue)
            }
            else {
                resourceDisplay = String(currentResourceValue)+"/"+String(maxResourceValue)
            }
        }
        else {
            if maxResourceValue == 0 {
                resourceDisplay = String(currentResourceValue)+"d"+String(dieType)
            }
            else {
                resourceDisplay = String(currentResourceValue)+"d"+String(dieType)+"/"+String(maxResourceValue)+"d"+String(dieType)
            }
        }
        
        resourceValue.text = resourceDisplay
        
        saView.layer.borderWidth = 1.0
        saView.layer.borderColor = UIColor.black.cgColor
        
        sdcView.layer.borderWidth = 1.0
        sdcView.layer.borderColor = UIColor.black.cgColor
        
        clView.layer.borderWidth = 1.0
        clView.layer.borderColor = UIColor.black.cgColor
        
        resourceView.layer.borderWidth = 1.0
        resourceView.layer.borderColor = UIColor.black.cgColor
        
        spellsTable.layer.borderWidth = 1.0
        spellsTable.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Edit Spell Attack
    @IBAction func saAction(button: UIButton) {
        
    }
    
    // Edit Spell DC
    @IBAction func sdcAction(button: UIButton) {
        
    }
    
    // Edit Caster Level
    @IBAction func clAction(button: UIButton) {
        
    }
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return spellcastingDict["spells"].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != spellcastingDict["spells"].count {
            let spellLevelDict = spellcastingDict["spells"][section]
            
            return spellLevelDict["prepared_spells"].count+1 // your number of cell here
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != spellcastingDict["spells"].count {
            if indexPath.row == 0 {
                // spell level cell
                return 30
            }
            else {
                // spell cell
                let spellLevelDict = spellcastingDict["spells"][indexPath.section]
                let spellDict = spellLevelDict["prepared_spells"][indexPath.row-1]
                let nameHeight = spellDict["name"].string?.heightWithConstrainedWidth(width: view.frame.width-40, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold))
                let schoolHeight = spellDict["school"].string?.heightWithConstrainedWidth(width: view.frame.width-40, font: UIFont.systemFont(ofSize: 17))
                let castingHeight = spellDict["casting_time"].string?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                let rangeHeight = spellDict["range"].string?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                let componentsHeight = spellDict["components"].string?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                let durationHeight = spellDict["duration"].string?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                var descriptionHeight: CGFloat = 0
                if spellDict["higher_level"].string! == "" {
                    descriptionHeight = (spellDict["description"].string?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17)))!
                    descriptionHeight += 70
                }
                else {
                    let boldText = "At Higher Levels."
                    let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
                    let attributedString = NSMutableAttributedString(string:spellDict["description"].string!+"\n", attributes:attrs)
                    let attributedHeight = attributedString.heightWithConstrainedWidth(width: view.frame.width-10)
                    
                    let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
                    let boldString = NSMutableAttributedString(string:boldText, attributes:boldAttrs)
                    let boldHeight = boldString.heightWithConstrainedWidth(width: view.frame.width-10)
                    
                    attributedString.append(boldString)
                    let attributedString2 = NSMutableAttributedString(string:" "+spellDict["higher_level"].string!, attributes:attrs)
                    let attributedHeight2 = attributedString2.heightWithConstrainedWidth(width: view.frame.width-10)
                    attributedString.append(attributedString2)
                    
                    descriptionHeight = attributedHeight + boldHeight + attributedHeight2
                }
                
                var height = nameHeight! + schoolHeight!
                height += castingHeight!
                height += rangeHeight!
                height += componentsHeight!
                height += durationHeight!
                height += descriptionHeight
                height += 35
                
                return height//540
            }
        }
        else {
            // new spell cell
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != spellcastingDict["spells"].count {
            let spellLevelDict = spellcastingDict["spells"][indexPath.section]
            let spellLevel = spellLevelDict["level"].int!
            let remainingSlots = spellLevelDict["remaining_slots"].int!
            let totalSlots = spellLevelDict["total_slots"].int!
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpellLevelTableViewCell", for: indexPath) as! SpellLevelTableViewCell
                
                // 1st, 2nd, 3rd, 4th, 5th, 6th, 7th, 8th, 9th
                var suffix = ""
                switch spellLevel {
                case 1:
                    suffix = "st"
                case 2:
                    suffix = "nd"
                case 3:
                    suffix = "rd"
                default:
                    suffix = "th"
                }
                if spellLevel == 0 {
                    cell.spellLevel.text = "Cantrips"
                    cell.spellSlots.isHidden = true
                }
                else {
                    cell.spellLevel.text = String(spellLevel)+suffix+" Level Spells"
                    cell.spellSlots.setTitle(String(remainingSlots)+"/"+String(totalSlots), for: UIControlState.normal)
                }
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpellTableViewCell", for: indexPath) as! SpellTableViewCell
                
                let spellDict = spellLevelDict["prepared_spells"][indexPath.row-1]
                cell.spellName.text = spellDict["name"].string
                cell.spellSchool.text = spellDict["school"].string
                cell.castingTime.text = spellDict["casting_time"].string!
                cell.range.text = spellDict["range"].string!
                cell.components.text = spellDict["components"].string!
                cell.duration.text = spellDict["duration"].string!
                cell.concentration.isHidden = !spellDict["concentration"].bool!
                if spellDict["higher_level"].string! == "" {
                    cell.spellDescription.text = spellDict["description"].string!
                }
                else {
                    let boldText = "At Higher Levels."
                    let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
                    let attributedString = NSMutableAttributedString(string:spellDict["description"].string!+"\n")
                    let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
                    attributedString.append(boldString)
                    let attributedString2 = NSMutableAttributedString(string:" "+spellDict["higher_level"].string!)
                    attributedString.append(attributedString2)
                    cell.spellDescription.attributedText = attributedString
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit selected skill value
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
