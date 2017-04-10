//
//  EquipmentViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // Platinum
    @IBOutlet weak var platinumView: UIView!
    @IBOutlet weak var platinumTitle: UILabel!
    @IBOutlet weak var platinumValue: UITextField!
    
    // Gold
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var goldTitle: UILabel!
    @IBOutlet weak var goldValue: UITextField!
    
    // Electrum
    @IBOutlet weak var electrumView: UIView!
    @IBOutlet weak var electrumTitle: UILabel!
    @IBOutlet weak var electrumValue: UITextField!
    
    // Silver
    @IBOutlet weak var silverView: UIView!
    @IBOutlet weak var silverTitle: UILabel!
    @IBOutlet weak var silverValue: UITextField!
    
    // Copper
    @IBOutlet weak var copperView: UIView!
    @IBOutlet weak var copperTitle: UILabel!
    @IBOutlet weak var copperValue: UITextField!
    
    // Filtered Equipment
    @IBOutlet weak var equipmentView: UIView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var equipmentTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var equipmentDict: JSON = [:]
    var allEquipment: JSON = []
    
    let damageTypes = ["Bludgeoning", "Piercing", "Slashing", "Acid", "Cold", "Fire", "Force", "Lightning", "Necrotic", "Poison", "Psychic", "Radiant", "Thunder"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        equipmentTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        equipmentDict = Character.Selected.equipment
        allEquipment = equipmentDict["weapons"]
        do {
            allEquipment = try allEquipment.merged(with: equipmentDict["armor"])
            allEquipment = try allEquipment.merged(with: equipmentDict["tools"])
            allEquipment = try allEquipment.merged(with: equipmentDict["other"])
        }
        catch {
            print(error)
        }
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
        let currency = equipmentDict["currency"]
        // Platinum
        platinumValue.tag = 100
        platinumValue.text = String(currency["platinum"].int!)
        
        // Gold
        goldValue.tag = 200
        goldValue.text = String(currency["gold"].int!)
        
        // Electrum
        electrumValue.tag = 300
        electrumValue.text = String(currency["electrum"].int!)
        
        // Silver
        silverValue.tag = 400
        silverValue.text = String(currency["silver"].int!)
        
        // Copper
        copperValue.tag = 500
        copperValue.text = String(currency["copper"].int!)
        
        platinumView.layer.borderWidth = 1.0
        platinumView.layer.borderColor = UIColor.black.cgColor
        
        goldView.layer.borderWidth = 1.0
        goldView.layer.borderColor = UIColor.black.cgColor
        
        electrumView.layer.borderWidth = 1.0
        electrumView.layer.borderColor = UIColor.black.cgColor
        
        silverView.layer.borderWidth = 1.0
        silverView.layer.borderColor = UIColor.black.cgColor
        
        copperView.layer.borderWidth = 1.0
        copperView.layer.borderColor = UIColor.black.cgColor
        
        equipmentView.layer.borderWidth = 1.0
        equipmentView.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(segControl: UISegmentedControl) {
        equipmentTable.reloadData()
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                return equipmentDict["weapons"].count
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                return equipmentDict["armor"].count
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                return equipmentDict["tools"].count
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                return equipmentDict["other"].count
            }
            else {
                // All
                return allEquipment.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            
            let weapons = equipmentDict["weapons"]
            let allArmor = equipmentDict["armor"]
            let tools = equipmentDict["tools"]
            let other = equipmentDict["other"]
            
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                let weapon = weapons[indexPath.row]
                
                let description = weapon["description"].string! + "\nWeight: " + weapon["weight"].string! + "\nCost: " + weapon["cost"].string!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                
                let height = 30+5+30+5+21+descriptionHeight
                return height//165
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let armor = allArmor[indexPath.row]
                
                var stealthDisadvantage = ""
                if armor["stealth_disadvantage"].bool! {
                    stealthDisadvantage = "Yes"
                }
                else {
                    stealthDisadvantage = "No"
                }
                
                var equipped = ""
                if armor["equipped"].bool! {
                    equipped = "Yes"
                }
                else {
                    equipped = "No"
                }
                
                let description = armor["description"].string! + "\nMinimum Strength: " + String(armor["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + armor["weight"].string! + "\nCost: " + armor["cost"].string!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                
                let height = 30+5+21+5+21+descriptionHeight
                return height//165
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let tool = tools[indexPath.row]
                
                let description = tool["description"].string! + "\nWeight: " + tool["weight"].string! + "\nCost: " + tool["cost"].string!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                
                let height = 30+5+21+5+21+descriptionHeight
                return height//165
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let otherItem = other[indexPath.row]
                
                let description = otherItem["description"].string! + "\nWeight: " + otherItem["weight"].string! + "\nCost: " + otherItem["cost"].string!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                
                let height = 30+5+21+descriptionHeight
                return height//165
            }
            else {
                // All equipment
                let equipment = allEquipment[indexPath.row]
                if equipment["attack_bonus"].exists() {
                    // Weapon
                    let description = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                    
                    let height = 30+5+30+5+21+descriptionHeight
                    return height//165
                }
                else if equipment["str_requirement"].exists() {
                    // Armor
                    var stealthDisadvantage = ""
                    if equipment["stealth_disadvantage"].bool! {
                        stealthDisadvantage = "Yes"
                    }
                    else {
                        stealthDisadvantage = "No"
                    }
                    
                    var equipped = ""
                    if equipment["equipped"].bool! {
                        equipped = "Yes"
                    }
                    else {
                        equipped = "No"
                    }
                    
                    let description = equipment["description"].string! + "\nMinimum Strength: " + String(equipment["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                    
                    let height = 30+5+21+5+21+descriptionHeight
                    return height//165
                }
                else if equipment["ability"].exists() {
                    // Tools
                    let description = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                    
                    let height = 30+5+21+5+21+descriptionHeight
                    return height//165
                }
                else {
                    // Other
                    let description = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
                    
                    let height = 30+5+21+descriptionHeight
                    return height//165
                }
            }
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let weapons = equipmentDict["weapons"]
            let allArmor = equipmentDict["armor"]
            let tools = equipmentDict["tools"]
            let other = equipmentDict["other"]
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
                let weapon = weapons[indexPath.row]
                let attackBonusDict = weapon["attack_bonus"]
                let damageDict = weapon["damage"]
                
                var attackBonus = 0
                var damageBonus = 0
                let modDamage = damageDict["mod_damage"].bool
                let abilityType: String = attackBonusDict["ability"].string!
                switch abilityType {
                case "STR":
                    attackBonus += Character.Selected.strBonus //Add STR bonus
                    if modDamage! {
                        damageBonus += Character.Selected.strBonus
                    }
                case "DEX":
                    attackBonus += Character.Selected.dexBonus //Add DEX bonus
                    if modDamage! {
                        damageBonus += Character.Selected.dexBonus
                    }
                case "CON":
                    attackBonus += Character.Selected.conBonus //Add CON bonus
                    if modDamage! {
                        damageBonus += Character.Selected.conBonus
                    }
                case "INT":
                    attackBonus += Character.Selected.intBonus //Add INT bonus
                    if modDamage! {
                        damageBonus += Character.Selected.intBonus
                    }
                case "WIS":
                    attackBonus += Character.Selected.wisBonus //Add WIS bonus
                    if modDamage! {
                        damageBonus += Character.Selected.wisBonus
                    }
                case "CHA":
                    attackBonus += Character.Selected.chaBonus //Add CHA bonus
                    if modDamage! {
                        damageBonus += Character.Selected.chaBonus
                    }
                default: break
                }
                
                attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
                damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
                
                var damageDieNumber = damageDict["die_number"].int
                var damageDie = damageDict["die_type"].int
                let extraDie = damageDict["extra_die"].bool
                if (extraDie)! {
                    damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
                    damageDie = damageDie! + damageDict["extra_die_type"].int!
                }
                
                let damageType = damageDict["damage_type"].string
                
                cell.weaponName.text = weapon["name"].string?.capitalized
                cell.weaponReach.text = "Range: "+weapon["range"].string!
                cell.weaponModifier.text = "+"+String(attackBonus)
                let dieDamage = String(damageDieNumber!)+"d"+String(damageDie!)
                cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
                
                cell.descView.text = weapon["description"].string! + "\nWeight: " + weapon["weight"].string! + "\nCost: " + weapon["cost"].string!
                if weapon["quantity"].int! <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(weapon["quantity"].int!)
                }
                
                return cell
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
                let armor = allArmor[indexPath.row]
                cell.armorName.text = armor["name"].string
                
                var armorValue = armor["value"].int!
                armorValue += armor["magic_bonus"].int!
                armorValue += armor["misc_bonus"].int!
                
                if (armor["mod"].string != "") {
                    cell.armorValue.text = String(armorValue) + "+" + armor["mod"].string!
                }
                else {
                    cell.armorValue.text = String(armorValue)
                }
                
                var stealthDisadvantage = ""
                if armor["stealth_disadvantage"].bool! {
                    stealthDisadvantage = "Yes"
                }
                else {
                    stealthDisadvantage = "No"
                }
                
                var equipped = ""
                if armor["equipped"].bool! {
                    equipped = "Yes"
                }
                else {
                    equipped = "No"
                }
                
                cell.descView.text = armor["description"].string! + "\nMinimum Strength: " + String(armor["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + armor["weight"].string! + "\nCost: " + armor["cost"].string!
                if armor["quantity"].int! <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(armor["quantity"].int!)
                }
                
                return cell
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
                let tool = tools[indexPath.row]
                
                var toolValue = 0
                if tool["proficient"].bool! {
                    toolValue += Character.Selected.proficiencyBonus
                }
                
                let abilityType: String = tool["ability"].string!
                switch abilityType {
                case "STR":
                    toolValue += Character.Selected.strBonus //Add STR bonus
                case "DEX":
                    toolValue += Character.Selected.dexBonus //Add DEX bonus
                case "CON":
                    toolValue += Character.Selected.conBonus //Add CON bonus
                case "INT":
                    toolValue += Character.Selected.intBonus //Add INT bonus
                case "WIS":
                    toolValue += Character.Selected.wisBonus //Add WIS bonus
                case "CHA":
                    toolValue += Character.Selected.chaBonus //Add CHA bonus
                default: break
                }
                
                cell.toolName.text = tool["name"].string
                cell.toolValue.text = "+"+String(toolValue)
                cell.descView.text = tool["description"].string! + "\nWeight: " + tool["weight"].string! + "\nCost: " + tool["cost"].string!
                if tool["quantity"].int! <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(tool["quantity"].int!)
                }
                return cell
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
                let otherItem = other[indexPath.row]
                
                cell.equipmentName.text = otherItem["name"].string!
                cell.descView.text = otherItem["description"].string! + "\nWeight: " + otherItem["weight"].string! + "\nCost: " + otherItem["cost"].string!
                if otherItem["quantity"].int! <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(otherItem["quantity"].int!)
                }
                
                return cell
            }
            else {
                // All equipment
                let equipment = allEquipment[indexPath.row]
                if equipment["attack_bonus"].exists() {
                    // Weapons
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
                    let attackBonusDict = equipment["attack_bonus"]
                    let damageDict = equipment["damage"]
                    
                    var attackBonus = 0
                    var damageBonus = 0
                    let modDamage = damageDict["mod_damage"].bool
                    let abilityType: String = attackBonusDict["ability"].string!
                    switch abilityType {
                    case "STR":
                        attackBonus += Character.Selected.strBonus //Add STR bonus
                        if modDamage! {
                            damageBonus += Character.Selected.strBonus
                        }
                    case "DEX":
                        attackBonus += Character.Selected.dexBonus //Add DEX bonus
                        if modDamage! {
                            damageBonus += Character.Selected.dexBonus
                        }
                    case "CON":
                        attackBonus += Character.Selected.conBonus //Add CON bonus
                        if modDamage! {
                            damageBonus += Character.Selected.conBonus
                        }
                    case "INT":
                        attackBonus += Character.Selected.intBonus //Add INT bonus
                        if modDamage! {
                            damageBonus += Character.Selected.intBonus
                        }
                    case "WIS":
                        attackBonus += Character.Selected.wisBonus //Add WIS bonus
                        if modDamage! {
                            damageBonus += Character.Selected.wisBonus
                        }
                    case "CHA":
                        attackBonus += Character.Selected.chaBonus //Add CHA bonus
                        if modDamage! {
                            damageBonus += Character.Selected.chaBonus
                        }
                    default: break
                    }
                    
                    attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
                    damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
                    
                    var damageDieNumber = damageDict["die_number"].int
                    var damageDie = damageDict["die_type"].int
                    let extraDie = damageDict["extra_die"].bool
                    if (extraDie)! {
                        damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
                        damageDie = damageDie! + damageDict["extra_die_type"].int!
                    }
                    
                    let damageType = damageDict["damage_type"].string
                    
                    cell.weaponName.text = equipment["name"].string?.capitalized
                    cell.weaponReach.text = "Range: "+equipment["range"].string!
                    cell.weaponModifier.text = "+"+String(attackBonus)
                    let dieDamage = String(damageDieNumber!)+"d"+String(damageDie!)
                    cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
                    
                    cell.descView.text = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    if equipment["quantity"].int! <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
                    }
                    
                    return cell
                }
                else if equipment["str_requirement"].exists() {
                    // Armor
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
                    cell.armorName.text = equipment["name"].string
                    
                    var armorValue = equipment["value"].int!
                    armorValue += equipment["magic_bonus"].int!
                    armorValue += equipment["misc_bonus"].int!
                    
                    if (equipment["mod"].string != "") {
                        cell.armorValue.text = String(armorValue) + "+" + equipment["mod"].string!
                    }
                    else {
                        cell.armorValue.text = String(armorValue)
                    }
                    
                    var stealthDisadvantage = ""
                    if equipment["stealth_disadvantage"].bool! {
                        stealthDisadvantage = "Yes"
                    }
                    else {
                        stealthDisadvantage = "No"
                    }
                    
                    var equipped = ""
                    if equipment["equipped"].bool! {
                        equipped = "Yes"
                    }
                    else {
                        equipped = "No"
                    }
                    
                    cell.descView.text = equipment["description"].string! + "\nMinimum Strength: " + String(equipment["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    if equipment["quantity"].int! <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
                    }
                    
                    return cell
                }
                else if equipment["ability"].exists() {
                    // Tools
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
                    
                    var toolValue = 0
                    if equipment["proficient"].bool! {
                        toolValue += Character.Selected.proficiencyBonus
                    }
                    
                    let abilityType: String = equipment["ability"].string!
                    switch abilityType {
                    case "STR":
                        toolValue += Character.Selected.strBonus //Add STR bonus
                    case "DEX":
                        toolValue += Character.Selected.dexBonus //Add DEX bonus
                    case "CON":
                        toolValue += Character.Selected.conBonus //Add CON bonus
                    case "INT":
                        toolValue += Character.Selected.intBonus //Add INT bonus
                    case "WIS":
                        toolValue += Character.Selected.wisBonus //Add WIS bonus
                    case "CHA":
                        toolValue += Character.Selected.chaBonus //Add CHA bonus
                    default: break
                    }
                    
                    cell.toolName.text = equipment["name"].string
                    cell.toolValue.text = "+"+String(toolValue)
                    cell.descView.text = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    if equipment["quantity"].int! <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
                    
                    cell.equipmentName.text = equipment["name"].string!
                    cell.descView.text = equipment["description"].string! + "\nWeight: " + equipment["weight"].string! + "\nCost: " + equipment["cost"].string!
                    if equipment["quantity"].int! <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
                    }
                    
                    return cell
                }
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
        
        if indexPath.section == 0 {
            let weapons = equipmentDict["weapons"]
            let allArmor = equipmentDict["armor"]
            let tools = equipmentDict["tools"]
            let other = equipmentDict["other"]
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                let weapon = weapons[indexPath.row]
                let attackBonusDict = weapon["attack_bonus"]
                let damageDict = weapon["damage"]
                
                var attackBonus = 0
                var damageBonus = 0
                let modDamage = damageDict["mod_damage"].bool
                let abilityType: String = attackBonusDict["ability"].string!
                switch abilityType {
                case "STR":
                    attackBonus += appDelegate.character.strBonus //Add STR bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.strBonus
                    }
                case "DEX":
                    attackBonus += appDelegate.character.dexBonus //Add DEX bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.dexBonus
                    }
                case "CON":
                    attackBonus += appDelegate.character.conBonus //Add CON bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.conBonus
                    }
                case "INT":
                    attackBonus += appDelegate.character.intBonus //Add INT bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.intBonus
                    }
                case "WIS":
                    attackBonus += appDelegate.character.wisBonus //Add WIS bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.wisBonus
                    }
                case "CHA":
                    attackBonus += appDelegate.character.chaBonus //Add CHA bonus
                    if modDamage! {
                        damageBonus += appDelegate.character.chaBonus
                    }
                default: break
                }
                
                attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
                damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
                
                var damageDieNumber = damageDict["die_number"].int
                var damageDie = damageDict["die_type"].int
                let extraDie = damageDict["extra_die"].bool
                if (extraDie)! {
                    damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
                    damageDie = damageDie! + damageDict["extra_die_type"].int!
                }
                
                let damageType = damageDict["damage_type"].string
                var damageTypeIndex = 0
                for i in 0 ..< damageTypes.count {
                    let dmgType = damageTypes[i]
                    if dmgType == damageType {
                        damageTypeIndex = i
                    }
                }
                
                let tempView = createBasicView()
                tempView.tag = 600 + (100 * indexPath.row)
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                tempView.addSubview(scrollView)
                
                let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                title.text = weapon["name"].string?.capitalized
                title.textAlignment = NSTextAlignment.center
                title.tag = 600 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                reachLabel.text = "Range"
                reachLabel.textAlignment = NSTextAlignment.center
                reachLabel.tag = 600 + (indexPath.row * 100) + 2
                scrollView.addSubview(reachLabel)
                
                let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                reachField.text = weapon["range"].string!
                reachField.textAlignment = NSTextAlignment.center
                reachField.layer.borderWidth = 1.0
                reachField.layer.borderColor = UIColor.black.cgColor
                reachField.tag = 600 + (indexPath.row * 100) + 3
                scrollView.addSubview(reachField)
                
                let damageTypeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                damageTypeLabel.text = "Damage Type"
                damageTypeLabel.textAlignment = NSTextAlignment.center
                damageTypeLabel.tag = 600 + (indexPath.row * 100) + 4
                scrollView.addSubview(damageTypeLabel)
                
                let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                damageTypePickerView.dataSource = self
                damageTypePickerView.delegate = self
                damageTypePickerView.selectedRow(inComponent: damageTypeIndex)
                damageTypePickerView.layer.borderWidth = 1.0
                damageTypePickerView.layer.borderColor = UIColor.black.cgColor
                damageTypePickerView.tag = 600 + (indexPath.row * 100) + 5
                scrollView.addSubview(damageTypePickerView)
                
                let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
                attackLabel.text = "Attack Ability"
                attackLabel.textAlignment = NSTextAlignment.center
                attackLabel.tag = 600 + (indexPath.row * 100) + 6
                scrollView.addSubview(attackLabel)
                
                var aaIndex = 0
                switch abilityType {
                case "STR":
                    aaIndex = 0
                //                attributeField.text = String(appDelegate.character.strBonus)
                case "DEX":
                    aaIndex = 1
                //                attributeField.text = String(appDelegate.character.dexBonus)
                case "CON":
                    aaIndex = 2
                //                attributeField.text = String(appDelegate.character.conBonus)
                case "INT":
                    aaIndex = 3
                //                attributeField.text = String(appDelegate.character.intBonus)
                case "WIS":
                    aaIndex = 4
                //                attributeField.text = String(appDelegate.character.wisBonus)
                case "CHA":
                    aaIndex = 5
                //                attributeField.text = String(appDelegate.character.chaBonus)
                default: break
                }
                
                let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:115, width:tempView.frame.size.width-20, height:30))
                aa.insertSegment(withTitle:"STR", at:0, animated:false)
                aa.insertSegment(withTitle:"DEX", at:1, animated:false)
                aa.insertSegment(withTitle:"CON", at:2, animated:false)
                aa.insertSegment(withTitle:"INT", at:3, animated:false)
                aa.insertSegment(withTitle:"WIS", at:4, animated:false)
                aa.insertSegment(withTitle:"CHA", at:5, animated:false)
                aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
                aa.selectedSegmentIndex = aaIndex
                aa.tag = 600 + (indexPath.row * 100) + 7
                scrollView.addSubview(aa)
                
                let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 145, width: 90, height: 30))
                profLabel.text = "Proficiency\nBonus"
                profLabel.font = UIFont.systemFont(ofSize: 10)
                profLabel.textAlignment = NSTextAlignment.center
                profLabel.numberOfLines = 2
                profLabel.tag = 600 + (indexPath.row * 100) + 8
                scrollView.addSubview(profLabel)
                
                let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:170, width:40, height:30))
                profField.text = String(appDelegate.character.proficiencyBonus)
                profField.textAlignment = NSTextAlignment.center
                profField.isEnabled = false
                profField.textColor = UIColor.darkGray
                profField.layer.borderWidth = 1.0
                profField.layer.borderColor = UIColor.darkGray.cgColor
                profField.tag = 600 + (indexPath.row * 100) + 9
                scrollView.addSubview(profField)
                
                let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
                dexLabel.text = "Dexterity\nBonus"
                dexLabel.font = UIFont.systemFont(ofSize: 10)
                dexLabel.textAlignment = NSTextAlignment.center
                dexLabel.numberOfLines = 2
                dexLabel.tag = 600 + (indexPath.row * 100) + 10
                scrollView.addSubview(dexLabel)
                
                let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
                dexField.text = String(appDelegate.character.dexBonus)
                dexField.textAlignment = NSTextAlignment.center
                dexField.layer.borderWidth = 1.0
                dexField.layer.borderColor = UIColor.black.cgColor
                dexField.tag = 600 + (indexPath.row * 100) + 11
                scrollView.addSubview(dexField)
                
                let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
                magicLabel.text = "Magic Item\nAttack Bonus"
                magicLabel.font = UIFont.systemFont(ofSize: 10)
                magicLabel.textAlignment = NSTextAlignment.center
                magicLabel.numberOfLines = 2
                magicLabel.tag = 600 + (indexPath.row * 100) + 12
                scrollView.addSubview(magicLabel)
                
                let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
                magicField.text = String(0)//String(appDelegate.character.miscInitBonus)
                magicField.textAlignment = NSTextAlignment.center
                magicField.layer.borderWidth = 1.0
                magicField.layer.borderColor = UIColor.black.cgColor
                magicField.tag = 600 + (indexPath.row * 100) + 13
                scrollView.addSubview(magicField)
                
                let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 145, width: 90, height: 30))
                miscLabel.text = "Misc\nAttack Bonus"
                miscLabel.font = UIFont.systemFont(ofSize: 10)
                miscLabel.textAlignment = NSTextAlignment.center
                miscLabel.numberOfLines = 2
                miscLabel.tag = 600 + (indexPath.row * 100) + 14
                scrollView.addSubview(miscLabel)
                
                let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:170, width:40, height:30))
                miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
                miscField.textAlignment = NSTextAlignment.center
                miscField.layer.borderWidth = 1.0
                miscField.layer.borderColor = UIColor.black.cgColor
                miscField.tag = 600 + (indexPath.row * 100) + 15
                scrollView.addSubview(miscField)
                
                let profWithLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 205, width: 90, height: 40))
                profWithLabel.text = "Proficient\nWith\nWeapon"
                profWithLabel.font = UIFont.systemFont(ofSize: 10)
                profWithLabel.textAlignment = NSTextAlignment.center
                profWithLabel.numberOfLines = 3
                profWithLabel.tag = 600 + (indexPath.row * 100) + 16
                scrollView.addSubview(profWithLabel)
                
                let profWithSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 245, width:51, height:31))
                profWithSwitch.isOn = false
                profWithSwitch.tag = 600 + (indexPath.row * 100) + 17
                scrollView.addSubview(profWithSwitch)
                
                let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 205, width: 90, height: 40))
                abilityDmgLabel.text = "Ability\nMod to\nDamage"
                abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
                abilityDmgLabel.textAlignment = NSTextAlignment.center
                abilityDmgLabel.numberOfLines = 3
                abilityDmgLabel.tag = 600 + (indexPath.row * 100) + 18
                scrollView.addSubview(abilityDmgLabel)
                
                let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 245, width:51, height:31))
                abilityDmgSwitch.isOn = false
                abilityDmgSwitch.tag = 600 + (indexPath.row * 100) + 19
                scrollView.addSubview(abilityDmgSwitch)
                
                let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
                magicDmgLabel.text = "Magic Item\nDamage\nBonus"
                magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
                magicDmgLabel.textAlignment = NSTextAlignment.center
                magicDmgLabel.numberOfLines = 3
                magicDmgLabel.tag = 600 + (indexPath.row * 100) + 20
                scrollView.addSubview(magicDmgLabel)
                
                let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
                magicDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
                magicDmgField.textAlignment = NSTextAlignment.center
                magicDmgField.layer.borderWidth = 1.0
                magicDmgField.layer.borderColor = UIColor.black.cgColor
                magicDmgField.tag = 600 + (indexPath.row * 100) + 21
                scrollView.addSubview(magicDmgField)
                
                let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
                miscDmgLabel.text = "Misc\nDamage\nBonus"
                miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
                miscDmgLabel.textAlignment = NSTextAlignment.center
                miscDmgLabel.numberOfLines = 3
                miscDmgLabel.tag = 600 + (indexPath.row * 100) + 22
                scrollView.addSubview(miscDmgLabel)
                
                let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
                miscDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
                miscDmgField.textAlignment = NSTextAlignment.center
                miscDmgField.layer.borderWidth = 1.0
                miscDmgField.layer.borderColor = UIColor.black.cgColor
                miscDmgField.tag = 600 + (indexPath.row * 100) + 23
                scrollView.addSubview(miscDmgField)
                
                let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                weaponDmgLabel.text = "Weapon Damage Die"
                weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                weaponDmgLabel.textAlignment = NSTextAlignment.center
                weaponDmgLabel.tag = 600 + (indexPath.row * 100) + 24
                scrollView.addSubview(weaponDmgLabel)
                
                let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                extraWeaponDmgLabel.text = "Extra Damage Die"
                extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
                extraWeaponDmgLabel.tag = 600 + (indexPath.row * 100) + 25
                scrollView.addSubview(extraWeaponDmgLabel)
                
                let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:320, width:40, height:30))
                weaponDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
                weaponDieAmount.textAlignment = NSTextAlignment.center
                weaponDieAmount.layer.borderWidth = 1.0
                weaponDieAmount.layer.borderColor = UIColor.black.cgColor
                weaponDieAmount.tag = 600 + (indexPath.row * 100) + 26
                scrollView.addSubview(weaponDieAmount)
                
                let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:20, height:30))
                weaponD.text = "d"
                weaponD.textAlignment = NSTextAlignment.center
                weaponD.tag = 600 + (indexPath.row * 100) + 27
                scrollView.addSubview(weaponD)
                
                let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:320, width:40, height:30))
                weaponDie.text = String(6)//String(appDelegate.character.miscInitBonus)
                weaponDie.textAlignment = NSTextAlignment.center
                weaponDie.layer.borderWidth = 1.0
                weaponDie.layer.borderColor = UIColor.black.cgColor
                weaponDie.tag = 600 + (indexPath.row * 100) + 28
                scrollView.addSubview(weaponDie)
                
                let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
                extraDieSwitch.isOn = false
                extraDieSwitch.tag = 600 + (indexPath.row * 100) + 29
                scrollView.addSubview(extraDieSwitch)
                
                let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
                extraDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
                extraDieAmount.textAlignment = NSTextAlignment.center
                extraDieAmount.layer.borderWidth = 1.0
                extraDieAmount.layer.borderColor = UIColor.black.cgColor
                extraDieAmount.tag = 600 + (indexPath.row * 100) + 30
                scrollView.addSubview(extraDieAmount)
                
                let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
                extraD.text = "d"
                extraD.textAlignment = NSTextAlignment.center
                extraD.tag = 600 + (indexPath.row * 100) + 31
                scrollView.addSubview(extraD)
                
                let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
                extraDieField.text = String(6)//String(appDelegate.character.miscInitBonus)
                extraDieField.textAlignment = NSTextAlignment.center
                extraDieField.layer.borderWidth = 1.0
                extraDieField.layer.borderColor = UIColor.black.cgColor
                extraDieField.tag = 600 + (indexPath.row * 100) + 32
                scrollView.addSubview(extraDieField)
                
                let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 380, width: 80, height: 30))
                weightLabel.text = "Weight"
                weightLabel.tag = 600 + (indexPath.row * 100) + 33
                scrollView.addSubview(weightLabel)
                
                let weightField = UITextField.init(frame: CGRect.init(x:90, y:380, width:tempView.frame.size.width - 100, height:30))
                weightField.text = weapon["weight"].string
                weightField.textAlignment = NSTextAlignment.center
                weightField.layer.borderWidth = 1.0
                weightField.layer.borderColor = UIColor.black.cgColor
                weightField.tag = 600 + (indexPath.row * 100) + 34
                scrollView.addSubview(weightField)
                
                let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 420, width: 80, height: 30))
                costLabel.text = "Cost"
                costLabel.tag = 600 + (indexPath.row * 100) + 35
                scrollView.addSubview(costLabel)
                
                let costField = UITextField.init(frame: CGRect.init(x:90, y:420, width:tempView.frame.size.width - 100, height:30))
                costField.text = weapon["cost"].string
                costField.textAlignment = NSTextAlignment.center
                costField.layer.borderWidth = 1.0
                costField.layer.borderColor = UIColor.black.cgColor
                costField.tag = 600 + (indexPath.row * 100) + 36
                scrollView.addSubview(costField)
                
                let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 460, width: 80, height: 30))
                amountLabel.text = "Amount"
                amountLabel.tag = 600 + (indexPath.row * 100) + 37
                scrollView.addSubview(amountLabel)
                
                let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:460, width:60, height:30))
                quantityLabel.text = weapon["amount"].string
                quantityLabel.textAlignment = NSTextAlignment.center
                quantityLabel.layer.borderWidth = 1.0
                quantityLabel.layer.borderColor = UIColor.black.cgColor
                quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                scrollView.addSubview(quantityLabel)
                
                let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 460, width:94, height:29))
                amountStepper.value = 0//weapon["amount"].double!
                amountStepper.minimumValue = 0
                amountStepper.maximumValue = 1000
                amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                amountStepper.tag = 600 + (indexPath.row * 100) + 39
                scrollView.addSubview(amountStepper)
                
                let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 500, width: 100, height: 30))
                descriptionLabel.text = "Description"
                descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                scrollView.addSubview(descriptionLabel)
                
                let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 530, width: tempView.frame.size.width-10, height: 100))
                descriptionView.text = weapon["description"].string
                descriptionView.layer.borderWidth = 1.0
                descriptionView.layer.borderColor = UIColor.black.cgColor
                descriptionView.tag = 600 + (indexPath.row * 100) + 41
                scrollView.addSubview(descriptionView)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 640)
                
                view.addSubview(tempView)
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let armor = allArmor[indexPath.row]
            
                let tempView = createBasicView()
                tempView.tag = 600 + (100 * indexPath.row)
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                tempView.addSubview(scrollView)
                
                let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                title.text = armor["name"].string?.capitalized
                title.textAlignment = NSTextAlignment.center
                title.tag = 600 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                let armorBaseValueLabel = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: 60, height: 40))
                armorBaseValueLabel.text = "Base\nValue"
                armorBaseValueLabel.textAlignment = NSTextAlignment.center
                armorBaseValueLabel.font = UIFont.systemFont(ofSize: 10)
                armorBaseValueLabel.numberOfLines = 2
                armorBaseValueLabel.tag = 600 + (indexPath.row * 100) + 2
                scrollView.addSubview(armorBaseValueLabel)
                
                let armorBaseValueField = UITextField.init(frame: CGRect.init(x: 10, y: 65, width: 40, height: 30))
                armorBaseValueField.text = String(armor["value"].int!)
                armorBaseValueField.textAlignment = NSTextAlignment.center
                armorBaseValueField.tag = 600 + (indexPath.row * 100) + 3
                armorBaseValueField.layer.borderWidth = 1.0
                armorBaseValueField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(armorBaseValueField)
                
                let dexterityBonusLabel = UILabel.init(frame: CGRect.init(x: 50, y: 30, width: 60, height: 40))
                dexterityBonusLabel.text = "Dexterity\nBonus"
                dexterityBonusLabel.textAlignment = NSTextAlignment.center
                dexterityBonusLabel.font = UIFont.systemFont(ofSize: 10)
                dexterityBonusLabel.numberOfLines = 2
                dexterityBonusLabel.tag = 600 + (indexPath.row * 100) + 4
                scrollView.addSubview(dexterityBonusLabel)
                
                let dexterityBonusField = UITextField.init(frame: CGRect.init(x:60, y:65, width:40, height:30))
                dexterityBonusField.text = String(appDelegate.character.dexBonus)
                dexterityBonusField.textAlignment = NSTextAlignment.center
                dexterityBonusField.tag = 600 + (indexPath.row * 100) + 5
                dexterityBonusField.layer.borderWidth = 1.0
                dexterityBonusField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(dexterityBonusField)
                
                let maxDexLabel = UILabel.init(frame: CGRect.init(x: 100, y: 30, width: 60, height: 40))
                maxDexLabel.text = "Max\nDex"
                maxDexLabel.textAlignment = NSTextAlignment.center
                maxDexLabel.font = UIFont.systemFont(ofSize: 10)
                maxDexLabel.numberOfLines = 2
                maxDexLabel.tag = 600 + (indexPath.row * 100) + 6
                scrollView.addSubview(maxDexLabel)
                
                let maxDexField = UITextField.init(frame: CGRect.init(x:110, y:65, width:40, height:30))
                maxDexField.text = String(armor["max_dex"].int!)
                maxDexField.textAlignment = NSTextAlignment.center
                maxDexField.tag = 600 + (indexPath.row * 100) + 7
                maxDexField.layer.borderWidth = 1.0
                maxDexField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(maxDexField)
                
                let magicBonusLabel = UILabel.init(frame: CGRect.init(x: 150, y: 30, width: 60, height: 40))
                magicBonusLabel.text = "Magic\nBonus"
                magicBonusLabel.textAlignment = NSTextAlignment.center
                magicBonusLabel.font = UIFont.systemFont(ofSize: 10)
                magicBonusLabel.numberOfLines = 2
                magicBonusLabel.tag = 600 + (indexPath.row * 100) + 8
                scrollView.addSubview(magicBonusLabel)
                
                let magicBonusField = UITextField.init(frame: CGRect.init(x:160, y:65, width:40, height:30))
                magicBonusField.text = String(armor["magic_bonus"].int!)
                magicBonusField.textAlignment = NSTextAlignment.center
                magicBonusField.tag = 600 + (indexPath.row * 100) + 9
                magicBonusField.layer.borderWidth = 1.0
                magicBonusField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(magicBonusField)
                
                let miscBonusLabel = UILabel.init(frame: CGRect.init(x: 200, y: 30, width: 60, height: 40))
                miscBonusLabel.text = "Misc\nBonus"
                miscBonusLabel.textAlignment = NSTextAlignment.center
                miscBonusLabel.font = UIFont.systemFont(ofSize: 10)
                miscBonusLabel.numberOfLines = 2
                miscBonusLabel.tag = 600 + (indexPath.row * 100) + 10
                scrollView.addSubview(miscBonusLabel)
                
                let miscBonusField = UITextField.init(frame: CGRect.init(x:210, y:65, width:40, height:30))
                miscBonusField.text = String(armor["misc_bonus"].int!)
                miscBonusField.textAlignment = NSTextAlignment.center
                miscBonusField.tag = 600 + (indexPath.row * 100) + 11
                miscBonusField.layer.borderWidth = 1.0
                miscBonusField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(miscBonusField)
                
                let minimumStrLabel = UILabel.init(frame: CGRect.init(x: 10, y: 100, width: 200, height: 30))
                minimumStrLabel.text = "Minimum Strength"
                    minimumStrLabel.tag = 600 + (indexPath.row * 100) + 12
                scrollView.addSubview(minimumStrLabel)
                
                let minimumStrField = UITextField.init(frame: CGRect.init(x:160, y:100, width:40, height:30))
                minimumStrField.text = String(armor["str_requirement"].int!)
                minimumStrField.textAlignment = NSTextAlignment.center
                minimumStrField.tag = 600 + (indexPath.row * 100) + 13
                minimumStrField.layer.borderWidth = 1.0
                minimumStrField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(minimumStrField)
                
                let stealthDisadvantageLabel = UILabel.init(frame: CGRect.init(x: 10, y: 140, width: 200, height: 30))
                stealthDisadvantageLabel.text = "Stealth Disadvantage"
                stealthDisadvantageLabel.tag = 600 + (indexPath.row * 100) + 14
                scrollView.addSubview(stealthDisadvantageLabel)
                
                let stealthDisadvantageSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:140, width:51, height:31))
                stealthDisadvantageSwitch.isOn = armor["stealth_disadvantage"].bool!
                stealthDisadvantageSwitch.tag = 600 + (indexPath.row * 100) + 15
                scrollView.addSubview(stealthDisadvantageSwitch)
                
                let equippedLabel = UILabel.init(frame: CGRect.init(x: 10, y: 180, width: 200, height: 30))
                equippedLabel.text = "Equipped"
                equippedLabel.tag = 600 + (indexPath.row * 100) + 16
                scrollView.addSubview(equippedLabel)
                
                let equippedSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:180, width:51, height:31))
                equippedSwitch.isOn = armor["equipped"].bool!
                equippedSwitch.tag = 600 + (indexPath.row * 100) + 17
                scrollView.addSubview(equippedSwitch)
                
                let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 220, width: 80, height: 30))
                weightLabel.text = "Weight"
                weightLabel.tag = 600 + (indexPath.row * 100) + 18
                scrollView.addSubview(weightLabel)
                
                let weightField = UITextField.init(frame: CGRect.init(x:90, y:220, width:tempView.frame.size.width - 100, height:30))
                weightField.text = armor["weight"].string
                weightField.textAlignment = NSTextAlignment.center
                weightField.layer.borderWidth = 1.0
                weightField.layer.borderColor = UIColor.black.cgColor
                weightField.tag = 600 + (indexPath.row * 100) + 34
                scrollView.addSubview(weightField)
                
                let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 260, width: 80, height: 30))
                costLabel.text = "Cost"
                costLabel.tag = 600 + (indexPath.row * 100) + 35
                scrollView.addSubview(costLabel)
                
                let costField = UITextField.init(frame: CGRect.init(x:90, y:260, width:tempView.frame.size.width - 100, height:30))
                costField.text = armor["cost"].string
                costField.textAlignment = NSTextAlignment.center
                costField.layer.borderWidth = 1.0
                costField.layer.borderColor = UIColor.black.cgColor
                costField.tag = 600 + (indexPath.row * 100) + 36
                scrollView.addSubview(costField)
                
                let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 300, width: 80, height: 30))
                amountLabel.text = "Amount"
                amountLabel.tag = 600 + (indexPath.row * 100) + 37
                scrollView.addSubview(amountLabel)
                
                let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:300, width:60, height:30))
                quantityLabel.text = armor["amount"].string
                quantityLabel.textAlignment = NSTextAlignment.center
                quantityLabel.layer.borderWidth = 1.0
                quantityLabel.layer.borderColor = UIColor.black.cgColor
                quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                scrollView.addSubview(quantityLabel)
                
                let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 300, width:94, height:29))
                amountStepper.value = 0//weapon["amount"].double!
                amountStepper.minimumValue = 0
                amountStepper.maximumValue = 1000
                amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                amountStepper.tag = 600 + (indexPath.row * 100) + 39
                scrollView.addSubview(amountStepper)
                
                let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 340, width: 100, height: 30))
                descriptionLabel.text = "Description"
                descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                scrollView.addSubview(descriptionLabel)
                
                let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 380, width: tempView.frame.size.width-10, height: 100))
                descriptionView.text = armor["description"].string
                descriptionView.layer.borderWidth = 1.0
                descriptionView.layer.borderColor = UIColor.black.cgColor
                descriptionView.tag = 600 + (indexPath.row * 100) + 41
                scrollView.addSubview(descriptionView)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 490)
                
                view.addSubview(tempView)
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let tool = tools[indexPath.row]
                
                let tempView = createBasicView()
                tempView.tag = 600 + (100 * indexPath.row)
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                tempView.addSubview(scrollView)
                
                let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                title.text = tool["name"].string?.capitalized
                title.textAlignment = NSTextAlignment.center
                title.tag = 600 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                // proficient switch
                let proficientLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: 200, height: 30))
                proficientLabel.text = "Proficient"
                proficientLabel.tag = 600 + (indexPath.row * 100) + 2
                scrollView.addSubview(proficientLabel)
                
                let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:45, width:51, height:31))
                proficientSwitch.isOn = tool["proficient"].bool!
                proficientSwitch.tag = 600 + (indexPath.row * 100) + 3
                scrollView.addSubview(proficientSwitch)
                
                // Ability Bonus
                let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:80, width:tempView.frame.size.width-20, height:30))
                aa.insertSegment(withTitle:"STR", at:0, animated:false)
                aa.insertSegment(withTitle:"DEX", at:1, animated:false)
                aa.insertSegment(withTitle:"CON", at:2, animated:false)
                aa.insertSegment(withTitle:"INT", at:3, animated:false)
                aa.insertSegment(withTitle:"WIS", at:4, animated:false)
                aa.insertSegment(withTitle:"CHA", at:5, animated:false)
                aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
                aa.tag = 600 + (indexPath.row * 100) + 4
                scrollView.addSubview(aa)
                
                let abilityLabel = UILabel.init(frame: CGRect.init(x: 10, y: 120, width: 200, height: 30))
                abilityLabel.tag = 600 + (indexPath.row * 100) + 5
                scrollView.addSubview(abilityLabel)
                
                let abilityField = UITextField.init(frame: CGRect.init(x:160, y:120, width:40, height:30))
                abilityField.textAlignment = NSTextAlignment.center
                abilityField.tag = 600 + (indexPath.row * 100) + 6
                abilityField.layer.borderWidth = 1.0
                abilityField.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(abilityField)
                
                let abilityType: String = tool["ability"].string!
                switch abilityType {
                case "STR":
                    abilityLabel.text = "Strength Bonus"
                    abilityField.text = String(appDelegate.character.strBonus)
                    aa.selectedSegmentIndex = 0
                case "DEX":
                    abilityLabel.text = "Dexterity Bonus"
                    abilityField.text = String(appDelegate.character.dexBonus)
                    aa.selectedSegmentIndex = 1
                case "CON":
                    abilityLabel.text = "Constitution Bonus"
                    abilityField.text = String(appDelegate.character.conBonus)
                    aa.selectedSegmentIndex = 2
                case "INT":
                    abilityLabel.text = "Intelligence Bonus"
                    abilityField.text = String(appDelegate.character.intBonus)
                    aa.selectedSegmentIndex = 3
                case "WIS":
                    abilityLabel.text = "Wisdom Bonus"
                    abilityField.text = String(appDelegate.character.wisBonus)
                    aa.selectedSegmentIndex = 4
                case "CHA":
                    abilityLabel.text = "Charisma Bonus"
                    abilityField.text = String(appDelegate.character.chaBonus)
                    aa.selectedSegmentIndex = 5
                default: break
                }
                
                // weight
                let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 160, width: 80, height: 30))
                weightLabel.text = "Weight"
                weightLabel.tag = 600 + (indexPath.row * 100) + 18
                scrollView.addSubview(weightLabel)
                
                let weightField = UITextField.init(frame: CGRect.init(x:90, y:160, width:tempView.frame.size.width - 100, height:30))
                weightField.text = tool["weight"].string
                weightField.textAlignment = NSTextAlignment.center
                weightField.layer.borderWidth = 1.0
                weightField.layer.borderColor = UIColor.black.cgColor
                weightField.tag = 600 + (indexPath.row * 100) + 34
                scrollView.addSubview(weightField)
                
                // cost
                let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 200, width: 80, height: 30))
                costLabel.text = "Cost"
                costLabel.tag = 600 + (indexPath.row * 100) + 35
                scrollView.addSubview(costLabel)
                
                let costField = UITextField.init(frame: CGRect.init(x:90, y:200, width:tempView.frame.size.width - 100, height:30))
                costField.text = tool["cost"].string
                costField.textAlignment = NSTextAlignment.center
                costField.layer.borderWidth = 1.0
                costField.layer.borderColor = UIColor.black.cgColor
                costField.tag = 600 + (indexPath.row * 100) + 36
                scrollView.addSubview(costField)
                
                // amount
                let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 240, width: 80, height: 30))
                amountLabel.text = "Amount"
                amountLabel.tag = 600 + (indexPath.row * 100) + 37
                scrollView.addSubview(amountLabel)
                
                let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:240, width:60, height:30))
                quantityLabel.text = tool["amount"].string
                quantityLabel.textAlignment = NSTextAlignment.center
                quantityLabel.layer.borderWidth = 1.0
                quantityLabel.layer.borderColor = UIColor.black.cgColor
                quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                scrollView.addSubview(quantityLabel)
                
                let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 240, width:94, height:29))
                amountStepper.value = 0//weapon["amount"].double!
                amountStepper.minimumValue = 0
                amountStepper.maximumValue = 1000
                amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                amountStepper.tag = 600 + (indexPath.row * 100) + 39
                scrollView.addSubview(amountStepper)
                
                // description
                let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: 100, height: 30))
                descriptionLabel.text = "Description"
                descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                scrollView.addSubview(descriptionLabel)
                
                let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 280, width: tempView.frame.size.width-10, height: 100))
                descriptionView.text = tool["description"].string
                descriptionView.layer.borderWidth = 1.0
                descriptionView.layer.borderColor = UIColor.black.cgColor
                descriptionView.tag = 600 + (indexPath.row * 100) + 41
                scrollView.addSubview(descriptionView)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 390)
                
                view.addSubview(tempView)
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let otherItem = other[indexPath.row]
                
                let tempView = createBasicView()
                tempView.tag = 600 + (100 * indexPath.row)
                
                let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                tempView.addSubview(scrollView)
                
                // name
                let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                title.text = otherItem["name"].string?.capitalized
                title.textAlignment = NSTextAlignment.center
                title.tag = 600 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                // weight
                let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: 80, height: 30))
                weightLabel.text = "Weight"
                weightLabel.tag = 600 + (indexPath.row * 100) + 2
                scrollView.addSubview(weightLabel)
                
                let weightField = UITextField.init(frame: CGRect.init(x:90, y:45, width:tempView.frame.size.width - 100, height:30))
                weightField.text = otherItem["weight"].string
                weightField.textAlignment = NSTextAlignment.center
                weightField.layer.borderWidth = 1.0
                weightField.layer.borderColor = UIColor.black.cgColor
                weightField.tag = 600 + (indexPath.row * 100) + 3
                scrollView.addSubview(weightField)
                
                // cost
                let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 85, width: 80, height: 30))
                costLabel.text = "Cost"
                costLabel.tag = 600 + (indexPath.row * 100) + 4
                scrollView.addSubview(costLabel)
                
                let costField = UITextField.init(frame: CGRect.init(x:90, y:85, width:tempView.frame.size.width - 100, height:30))
                costField.text = otherItem["cost"].string
                costField.textAlignment = NSTextAlignment.center
                costField.layer.borderWidth = 1.0
                costField.layer.borderColor = UIColor.black.cgColor
                costField.tag = 600 + (indexPath.row * 100) + 5
                scrollView.addSubview(costField)
                
                // amount
                let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 125, width: 80, height: 30))
                amountLabel.text = "Amount"
                amountLabel.tag = 600 + (indexPath.row * 100) + 6
                scrollView.addSubview(amountLabel)
                
                let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:125, width:60, height:30))
                quantityLabel.text = otherItem["amount"].string
                quantityLabel.textAlignment = NSTextAlignment.center
                quantityLabel.layer.borderWidth = 1.0
                quantityLabel.layer.borderColor = UIColor.black.cgColor
                quantityLabel.tag = 600 + (indexPath.row * 100) + 7
                scrollView.addSubview(quantityLabel)
                
                let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 125, width:94, height:29))
                amountStepper.value = 0//weapon["amount"].double!
                amountStepper.minimumValue = 0
                amountStepper.maximumValue = 1000
                amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                amountStepper.tag = 600 + (indexPath.row * 100) + 8
                scrollView.addSubview(amountStepper)
                
                // description
                let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 165, width: 100, height: 30))
                descriptionLabel.text = "Description"
                descriptionLabel.tag = 600 + (indexPath.row * 100) + 9
                scrollView.addSubview(descriptionLabel)
                
                let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 205, width: tempView.frame.size.width-10, height: 100))
                descriptionView.text = otherItem["description"].string
                descriptionView.layer.borderWidth = 1.0
                descriptionView.layer.borderColor = UIColor.black.cgColor
                descriptionView.tag = 600 + (indexPath.row * 100) + 10
                scrollView.addSubview(descriptionView)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 315)
                
                view.addSubview(tempView)
            }
            else {
                // All equipment
                let equipment = allEquipment[indexPath.row]
                if equipment["attack_bonus"].exists() {
                    // Weapon
                    let attackBonusDict = equipment["attack_bonus"]
                    let damageDict = equipment["damage"]
                    
                    var attackBonus = 0
                    var damageBonus = 0
                    let modDamage = damageDict["mod_damage"].bool
                    let abilityType: String = attackBonusDict["ability"].string!
                    switch abilityType {
                    case "STR":
                        attackBonus += appDelegate.character.strBonus //Add STR bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.strBonus
                        }
                    case "DEX":
                        attackBonus += appDelegate.character.dexBonus //Add DEX bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.dexBonus
                        }
                    case "CON":
                        attackBonus += appDelegate.character.conBonus //Add CON bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.conBonus
                        }
                    case "INT":
                        attackBonus += appDelegate.character.intBonus //Add INT bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.intBonus
                        }
                    case "WIS":
                        attackBonus += appDelegate.character.wisBonus //Add WIS bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.wisBonus
                        }
                    case "CHA":
                        attackBonus += appDelegate.character.chaBonus //Add CHA bonus
                        if modDamage! {
                            damageBonus += appDelegate.character.chaBonus
                        }
                    default: break
                    }
                    
                    attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
                    damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
                    
                    var damageDieNumber = damageDict["die_number"].int
                    var damageDie = damageDict["die_type"].int
                    let extraDie = damageDict["extra_die"].bool
                    if (extraDie)! {
                        damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
                        damageDie = damageDie! + damageDict["extra_die_type"].int!
                    }
                    
                    let damageType = damageDict["damage_type"].string
                    var damageTypeIndex = 0
                    for i in 0 ..< damageTypes.count {
                        let dmgType = damageTypes[i]
                        if dmgType == damageType {
                            damageTypeIndex = i
                        }
                    }
                    
                    let tempView = createBasicView()
                    tempView.tag = 600 + (100 * indexPath.row)
                    
                    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                    tempView.addSubview(scrollView)
                    
                    let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                    title.text = equipment["name"].string?.capitalized
                    title.textAlignment = NSTextAlignment.center
                    title.tag = 600 + (indexPath.row * 100) + 1
                    title.layer.borderWidth = 1.0
                    title.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(title)
                    
                    let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                    reachLabel.text = "Range"
                    reachLabel.textAlignment = NSTextAlignment.center
                    reachLabel.tag = 600 + (indexPath.row * 100) + 2
                    scrollView.addSubview(reachLabel)
                    
                    let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                    reachField.text = equipment["range"].string!
                    reachField.textAlignment = NSTextAlignment.center
                    reachField.layer.borderWidth = 1.0
                    reachField.layer.borderColor = UIColor.black.cgColor
                    reachField.tag = 600 + (indexPath.row * 100) + 3
                    scrollView.addSubview(reachField)
                    
                    let damageTypeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                    damageTypeLabel.text = "Damage Type"
                    damageTypeLabel.textAlignment = NSTextAlignment.center
                    damageTypeLabel.tag = 600 + (indexPath.row * 100) + 4
                    scrollView.addSubview(damageTypeLabel)
                    
                    let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                    damageTypePickerView.dataSource = self
                    damageTypePickerView.delegate = self
                    damageTypePickerView.selectedRow(inComponent: damageTypeIndex)
                    damageTypePickerView.layer.borderWidth = 1.0
                    damageTypePickerView.layer.borderColor = UIColor.black.cgColor
                    damageTypePickerView.tag = 600 + (indexPath.row * 100) + 5
                    scrollView.addSubview(damageTypePickerView)
                    
                    let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
                    attackLabel.text = "Attack Ability"
                    attackLabel.textAlignment = NSTextAlignment.center
                    attackLabel.tag = 600 + (indexPath.row * 100) + 6
                    scrollView.addSubview(attackLabel)
                    
                    var aaIndex = 0
                    switch abilityType {
                    case "STR":
                        aaIndex = 0
                    //                attributeField.text = String(appDelegate.character.strBonus)
                    case "DEX":
                        aaIndex = 1
                    //                attributeField.text = String(appDelegate.character.dexBonus)
                    case "CON":
                        aaIndex = 2
                    //                attributeField.text = String(appDelegate.character.conBonus)
                    case "INT":
                        aaIndex = 3
                    //                attributeField.text = String(appDelegate.character.intBonus)
                    case "WIS":
                        aaIndex = 4
                    //                attributeField.text = String(appDelegate.character.wisBonus)
                    case "CHA":
                        aaIndex = 5
                    //                attributeField.text = String(appDelegate.character.chaBonus)
                    default: break
                    }
                    
                    let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:115, width:tempView.frame.size.width-20, height:30))
                    aa.insertSegment(withTitle:"STR", at:0, animated:false)
                    aa.insertSegment(withTitle:"DEX", at:1, animated:false)
                    aa.insertSegment(withTitle:"CON", at:2, animated:false)
                    aa.insertSegment(withTitle:"INT", at:3, animated:false)
                    aa.insertSegment(withTitle:"WIS", at:4, animated:false)
                    aa.insertSegment(withTitle:"CHA", at:5, animated:false)
                    aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
                    aa.selectedSegmentIndex = aaIndex
                    aa.tag = 600 + (indexPath.row * 100) + 7
                    scrollView.addSubview(aa)
                    
                    let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 145, width: 90, height: 30))
                    profLabel.text = "Proficiency\nBonus"
                    profLabel.font = UIFont.systemFont(ofSize: 10)
                    profLabel.textAlignment = NSTextAlignment.center
                    profLabel.numberOfLines = 2
                    profLabel.tag = 600 + (indexPath.row * 100) + 8
                    scrollView.addSubview(profLabel)
                    
                    let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:170, width:40, height:30))
                    profField.text = String(appDelegate.character.proficiencyBonus)
                    profField.textAlignment = NSTextAlignment.center
                    profField.isEnabled = false
                    profField.textColor = UIColor.darkGray
                    profField.layer.borderWidth = 1.0
                    profField.layer.borderColor = UIColor.darkGray.cgColor
                    profField.tag = 600 + (indexPath.row * 100) + 9
                    scrollView.addSubview(profField)
                    
                    let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
                    dexLabel.text = "Dexterity\nBonus"
                    dexLabel.font = UIFont.systemFont(ofSize: 10)
                    dexLabel.textAlignment = NSTextAlignment.center
                    dexLabel.numberOfLines = 2
                    dexLabel.tag = 600 + (indexPath.row * 100) + 10
                    scrollView.addSubview(dexLabel)
                    
                    let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
                    dexField.text = String(appDelegate.character.dexBonus)
                    dexField.textAlignment = NSTextAlignment.center
                    dexField.layer.borderWidth = 1.0
                    dexField.layer.borderColor = UIColor.black.cgColor
                    dexField.tag = 600 + (indexPath.row * 100) + 11
                    scrollView.addSubview(dexField)
                    
                    let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
                    magicLabel.text = "Magic Item\nAttack Bonus"
                    magicLabel.font = UIFont.systemFont(ofSize: 10)
                    magicLabel.textAlignment = NSTextAlignment.center
                    magicLabel.numberOfLines = 2
                    magicLabel.tag = 600 + (indexPath.row * 100) + 12
                    scrollView.addSubview(magicLabel)
                    
                    let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
                    magicField.text = String(0)//String(appDelegate.character.miscInitBonus)
                    magicField.textAlignment = NSTextAlignment.center
                    magicField.layer.borderWidth = 1.0
                    magicField.layer.borderColor = UIColor.black.cgColor
                    magicField.tag = 600 + (indexPath.row * 100) + 13
                    scrollView.addSubview(magicField)
                    
                    let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 145, width: 90, height: 30))
                    miscLabel.text = "Misc\nAttack Bonus"
                    miscLabel.font = UIFont.systemFont(ofSize: 10)
                    miscLabel.textAlignment = NSTextAlignment.center
                    miscLabel.numberOfLines = 2
                    miscLabel.tag = 600 + (indexPath.row * 100) + 14
                    scrollView.addSubview(miscLabel)
                    
                    let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:170, width:40, height:30))
                    miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
                    miscField.textAlignment = NSTextAlignment.center
                    miscField.layer.borderWidth = 1.0
                    miscField.layer.borderColor = UIColor.black.cgColor
                    miscField.tag = 600 + (indexPath.row * 100) + 15
                    scrollView.addSubview(miscField)
                    
                    let profWithLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 205, width: 90, height: 40))
                    profWithLabel.text = "Proficient\nWith\nWeapon"
                    profWithLabel.font = UIFont.systemFont(ofSize: 10)
                    profWithLabel.textAlignment = NSTextAlignment.center
                    profWithLabel.numberOfLines = 3
                    profWithLabel.tag = 600 + (indexPath.row * 100) + 16
                    scrollView.addSubview(profWithLabel)
                    
                    let profWithSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 245, width:51, height:31))
                    profWithSwitch.isOn = false
                    profWithSwitch.tag = 600 + (indexPath.row * 100) + 17
                    scrollView.addSubview(profWithSwitch)
                    
                    let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 205, width: 90, height: 40))
                    abilityDmgLabel.text = "Ability\nMod to\nDamage"
                    abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
                    abilityDmgLabel.textAlignment = NSTextAlignment.center
                    abilityDmgLabel.numberOfLines = 3
                    abilityDmgLabel.tag = 600 + (indexPath.row * 100) + 18
                    scrollView.addSubview(abilityDmgLabel)
                    
                    let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 245, width:51, height:31))
                    abilityDmgSwitch.isOn = false
                    abilityDmgSwitch.tag = 600 + (indexPath.row * 100) + 19
                    scrollView.addSubview(abilityDmgSwitch)
                    
                    let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
                    magicDmgLabel.text = "Magic Item\nDamage\nBonus"
                    magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
                    magicDmgLabel.textAlignment = NSTextAlignment.center
                    magicDmgLabel.numberOfLines = 3
                    magicDmgLabel.tag = 600 + (indexPath.row * 100) + 20
                    scrollView.addSubview(magicDmgLabel)
                    
                    let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
                    magicDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
                    magicDmgField.textAlignment = NSTextAlignment.center
                    magicDmgField.layer.borderWidth = 1.0
                    magicDmgField.layer.borderColor = UIColor.black.cgColor
                    magicDmgField.tag = 600 + (indexPath.row * 100) + 21
                    scrollView.addSubview(magicDmgField)
                    
                    let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
                    miscDmgLabel.text = "Misc\nDamage\nBonus"
                    miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
                    miscDmgLabel.textAlignment = NSTextAlignment.center
                    miscDmgLabel.numberOfLines = 3
                    miscDmgLabel.tag = 600 + (indexPath.row * 100) + 22
                    scrollView.addSubview(miscDmgLabel)
                    
                    let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
                    miscDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
                    miscDmgField.textAlignment = NSTextAlignment.center
                    miscDmgField.layer.borderWidth = 1.0
                    miscDmgField.layer.borderColor = UIColor.black.cgColor
                    miscDmgField.tag = 600 + (indexPath.row * 100) + 23
                    scrollView.addSubview(miscDmgField)
                    
                    let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                    weaponDmgLabel.text = "Weapon Damage Die"
                    weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                    weaponDmgLabel.textAlignment = NSTextAlignment.center
                    weaponDmgLabel.tag = 600 + (indexPath.row * 100) + 24
                    scrollView.addSubview(weaponDmgLabel)
                    
                    let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                    extraWeaponDmgLabel.text = "Extra Damage Die"
                    extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                    extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
                    extraWeaponDmgLabel.tag = 600 + (indexPath.row * 100) + 25
                    scrollView.addSubview(extraWeaponDmgLabel)
                    
                    let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:320, width:40, height:30))
                    weaponDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
                    weaponDieAmount.textAlignment = NSTextAlignment.center
                    weaponDieAmount.layer.borderWidth = 1.0
                    weaponDieAmount.layer.borderColor = UIColor.black.cgColor
                    weaponDieAmount.tag = 600 + (indexPath.row * 100) + 26
                    scrollView.addSubview(weaponDieAmount)
                    
                    let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:20, height:30))
                    weaponD.text = "d"
                    weaponD.textAlignment = NSTextAlignment.center
                    weaponD.tag = 600 + (indexPath.row * 100) + 27
                    scrollView.addSubview(weaponD)
                    
                    let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:320, width:40, height:30))
                    weaponDie.text = String(6)//String(appDelegate.character.miscInitBonus)
                    weaponDie.textAlignment = NSTextAlignment.center
                    weaponDie.layer.borderWidth = 1.0
                    weaponDie.layer.borderColor = UIColor.black.cgColor
                    weaponDie.tag = 600 + (indexPath.row * 100) + 28
                    scrollView.addSubview(weaponDie)
                    
                    let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
                    extraDieSwitch.isOn = false
                    extraDieSwitch.tag = 600 + (indexPath.row * 100) + 29
                    scrollView.addSubview(extraDieSwitch)
                    
                    let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
                    extraDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
                    extraDieAmount.textAlignment = NSTextAlignment.center
                    extraDieAmount.layer.borderWidth = 1.0
                    extraDieAmount.layer.borderColor = UIColor.black.cgColor
                    extraDieAmount.tag = 600 + (indexPath.row * 100) + 30
                    scrollView.addSubview(extraDieAmount)
                    
                    let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
                    extraD.text = "d"
                    extraD.textAlignment = NSTextAlignment.center
                    extraD.tag = 600 + (indexPath.row * 100) + 31
                    scrollView.addSubview(extraD)
                    
                    let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
                    extraDieField.text = String(6)//String(appDelegate.character.miscInitBonus)
                    extraDieField.textAlignment = NSTextAlignment.center
                    extraDieField.layer.borderWidth = 1.0
                    extraDieField.layer.borderColor = UIColor.black.cgColor
                    extraDieField.tag = 600 + (indexPath.row * 100) + 32
                    scrollView.addSubview(extraDieField)
                    
                    let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 380, width: 80, height: 30))
                    weightLabel.text = "Weight"
                    weightLabel.tag = 600 + (indexPath.row * 100) + 33
                    scrollView.addSubview(weightLabel)
                    
                    let weightField = UITextField.init(frame: CGRect.init(x:90, y:380, width:tempView.frame.size.width - 100, height:30))
                    weightField.text = equipment["weight"].string
                    weightField.textAlignment = NSTextAlignment.center
                    weightField.layer.borderWidth = 1.0
                    weightField.layer.borderColor = UIColor.black.cgColor
                    weightField.tag = 600 + (indexPath.row * 100) + 34
                    scrollView.addSubview(weightField)
                    
                    let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 420, width: 80, height: 30))
                    costLabel.text = "Cost"
                    costLabel.tag = 600 + (indexPath.row * 100) + 35
                    scrollView.addSubview(costLabel)
                    
                    let costField = UITextField.init(frame: CGRect.init(x:90, y:420, width:tempView.frame.size.width - 100, height:30))
                    costField.text = equipment["cost"].string
                    costField.textAlignment = NSTextAlignment.center
                    costField.layer.borderWidth = 1.0
                    costField.layer.borderColor = UIColor.black.cgColor
                    costField.tag = 600 + (indexPath.row * 100) + 36
                    scrollView.addSubview(costField)
                    
                    let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 460, width: 80, height: 30))
                    amountLabel.text = "Amount"
                    amountLabel.tag = 600 + (indexPath.row * 100) + 37
                    scrollView.addSubview(amountLabel)
                    
                    let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:460, width:60, height:30))
                    quantityLabel.text = equipment["amount"].string
                    quantityLabel.textAlignment = NSTextAlignment.center
                    quantityLabel.layer.borderWidth = 1.0
                    quantityLabel.layer.borderColor = UIColor.black.cgColor
                    quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                    scrollView.addSubview(quantityLabel)
                    
                    let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 460, width:94, height:29))
                    amountStepper.value = 0//weapon["amount"].double!
                    amountStepper.minimumValue = 0
                    amountStepper.maximumValue = 1000
                    amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                    amountStepper.tag = 600 + (indexPath.row * 100) + 39
                    scrollView.addSubview(amountStepper)
                    
                    let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 500, width: 100, height: 30))
                    descriptionLabel.text = "Description"
                    descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                    scrollView.addSubview(descriptionLabel)
                    
                    let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 530, width: tempView.frame.size.width-10, height: 100))
                    descriptionView.text = equipment["description"].string
                    descriptionView.layer.borderWidth = 1.0
                    descriptionView.layer.borderColor = UIColor.black.cgColor
                    descriptionView.tag = 600 + (indexPath.row * 100) + 41
                    scrollView.addSubview(descriptionView)
                    
                    scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 640)
                    
                    view.addSubview(tempView)
                }
                else if equipment["str_requirement"].exists() {
                    // Armor
                    let tempView = createBasicView()
                    tempView.tag = 600 + (100 * indexPath.row)
                    
                    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                    tempView.addSubview(scrollView)
                    
                    let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                    title.text = equipment["name"].string?.capitalized
                    title.textAlignment = NSTextAlignment.center
                    title.tag = 600 + (indexPath.row * 100) + 1
                    title.layer.borderWidth = 1.0
                    title.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(title)
                    
                    let armorBaseValueLabel = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: 60, height: 40))
                    armorBaseValueLabel.text = "Base\nValue"
                    armorBaseValueLabel.textAlignment = NSTextAlignment.center
                    armorBaseValueLabel.font = UIFont.systemFont(ofSize: 10)
                    armorBaseValueLabel.numberOfLines = 2
                    armorBaseValueLabel.tag = 600 + (indexPath.row * 100) + 2
                    scrollView.addSubview(armorBaseValueLabel)
                    
                    let armorBaseValueField = UITextField.init(frame: CGRect.init(x: 10, y: 65, width: 40, height: 30))
                    armorBaseValueField.text = String(equipment["value"].int!)
                    armorBaseValueField.textAlignment = NSTextAlignment.center
                    armorBaseValueField.tag = 600 + (indexPath.row * 100) + 3
                    armorBaseValueField.layer.borderWidth = 1.0
                    armorBaseValueField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(armorBaseValueField)
                    
                    let dexterityBonusLabel = UILabel.init(frame: CGRect.init(x: 50, y: 30, width: 60, height: 40))
                    dexterityBonusLabel.text = "Dexterity\nBonus"
                    dexterityBonusLabel.textAlignment = NSTextAlignment.center
                    dexterityBonusLabel.font = UIFont.systemFont(ofSize: 10)
                    dexterityBonusLabel.numberOfLines = 2
                    dexterityBonusLabel.tag = 600 + (indexPath.row * 100) + 4
                    scrollView.addSubview(dexterityBonusLabel)
                    
                    let dexterityBonusField = UITextField.init(frame: CGRect.init(x:60, y:65, width:40, height:30))
                    dexterityBonusField.text = String(appDelegate.character.dexBonus)
                    dexterityBonusField.textAlignment = NSTextAlignment.center
                    dexterityBonusField.tag = 600 + (indexPath.row * 100) + 5
                    dexterityBonusField.layer.borderWidth = 1.0
                    dexterityBonusField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(dexterityBonusField)
                    
                    let maxDexLabel = UILabel.init(frame: CGRect.init(x: 100, y: 30, width: 60, height: 40))
                    maxDexLabel.text = "Max\nDex"
                    maxDexLabel.textAlignment = NSTextAlignment.center
                    maxDexLabel.font = UIFont.systemFont(ofSize: 10)
                    maxDexLabel.numberOfLines = 2
                    maxDexLabel.tag = 600 + (indexPath.row * 100) + 6
                    scrollView.addSubview(maxDexLabel)
                    
                    let maxDexField = UITextField.init(frame: CGRect.init(x:110, y:65, width:40, height:30))
                    maxDexField.text = String(equipment["max_dex"].int!)
                    maxDexField.textAlignment = NSTextAlignment.center
                    maxDexField.tag = 600 + (indexPath.row * 100) + 7
                    maxDexField.layer.borderWidth = 1.0
                    maxDexField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(maxDexField)
                    
                    let magicBonusLabel = UILabel.init(frame: CGRect.init(x: 150, y: 30, width: 60, height: 40))
                    magicBonusLabel.text = "Magic\nBonus"
                    magicBonusLabel.textAlignment = NSTextAlignment.center
                    magicBonusLabel.font = UIFont.systemFont(ofSize: 10)
                    magicBonusLabel.numberOfLines = 2
                    magicBonusLabel.tag = 600 + (indexPath.row * 100) + 8
                    scrollView.addSubview(magicBonusLabel)
                    
                    let magicBonusField = UITextField.init(frame: CGRect.init(x:160, y:65, width:40, height:30))
                    magicBonusField.text = String(equipment["magic_bonus"].int!)
                    magicBonusField.textAlignment = NSTextAlignment.center
                    magicBonusField.tag = 600 + (indexPath.row * 100) + 9
                    magicBonusField.layer.borderWidth = 1.0
                    magicBonusField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(magicBonusField)
                    
                    let miscBonusLabel = UILabel.init(frame: CGRect.init(x: 200, y: 30, width: 60, height: 40))
                    miscBonusLabel.text = "Misc\nBonus"
                    miscBonusLabel.textAlignment = NSTextAlignment.center
                    miscBonusLabel.font = UIFont.systemFont(ofSize: 10)
                    miscBonusLabel.numberOfLines = 2
                    miscBonusLabel.tag = 600 + (indexPath.row * 100) + 10
                    scrollView.addSubview(miscBonusLabel)
                    
                    let miscBonusField = UITextField.init(frame: CGRect.init(x:210, y:65, width:40, height:30))
                    miscBonusField.text = String(equipment["misc_bonus"].int!)
                    miscBonusField.textAlignment = NSTextAlignment.center
                    miscBonusField.tag = 600 + (indexPath.row * 100) + 11
                    miscBonusField.layer.borderWidth = 1.0
                    miscBonusField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(miscBonusField)
                    
                    let minimumStrLabel = UILabel.init(frame: CGRect.init(x: 10, y: 100, width: 200, height: 30))
                    minimumStrLabel.text = "Minimum Strength"
                    minimumStrLabel.tag = 600 + (indexPath.row * 100) + 12
                    scrollView.addSubview(minimumStrLabel)
                    
                    let minimumStrField = UITextField.init(frame: CGRect.init(x:160, y:100, width:40, height:30))
                    minimumStrField.text = String(equipment["str_requirement"].int!)
                    minimumStrField.textAlignment = NSTextAlignment.center
                    minimumStrField.tag = 600 + (indexPath.row * 100) + 13
                    minimumStrField.layer.borderWidth = 1.0
                    minimumStrField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(minimumStrField)
                    
                    let stealthDisadvantageLabel = UILabel.init(frame: CGRect.init(x: 10, y: 140, width: 200, height: 30))
                    stealthDisadvantageLabel.text = "Stealth Disadvantage"
                    stealthDisadvantageLabel.tag = 600 + (indexPath.row * 100) + 14
                    scrollView.addSubview(stealthDisadvantageLabel)
                    
                    let stealthDisadvantageSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:140, width:51, height:31))
                    stealthDisadvantageSwitch.isOn = equipment["stealth_disadvantage"].bool!
                    stealthDisadvantageSwitch.tag = 600 + (indexPath.row * 100) + 15
                    scrollView.addSubview(stealthDisadvantageSwitch)
                    
                    let equippedLabel = UILabel.init(frame: CGRect.init(x: 10, y: 180, width: 200, height: 30))
                    equippedLabel.text = "Equipped"
                    equippedLabel.tag = 600 + (indexPath.row * 100) + 16
                    scrollView.addSubview(equippedLabel)
                    
                    let equippedSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:180, width:51, height:31))
                    equippedSwitch.isOn = equipment["equipped"].bool!
                    equippedSwitch.tag = 600 + (indexPath.row * 100) + 17
                    scrollView.addSubview(equippedSwitch)
                    
                    let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 220, width: 80, height: 30))
                    weightLabel.text = "Weight"
                    weightLabel.tag = 600 + (indexPath.row * 100) + 18
                    scrollView.addSubview(weightLabel)
                    
                    let weightField = UITextField.init(frame: CGRect.init(x:90, y:220, width:tempView.frame.size.width - 100, height:30))
                    weightField.text = equipment["weight"].string
                    weightField.textAlignment = NSTextAlignment.center
                    weightField.layer.borderWidth = 1.0
                    weightField.layer.borderColor = UIColor.black.cgColor
                    weightField.tag = 600 + (indexPath.row * 100) + 34
                    scrollView.addSubview(weightField)
                    
                    let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 260, width: 80, height: 30))
                    costLabel.text = "Cost"
                    costLabel.tag = 600 + (indexPath.row * 100) + 35
                    scrollView.addSubview(costLabel)
                    
                    let costField = UITextField.init(frame: CGRect.init(x:90, y:260, width:tempView.frame.size.width - 100, height:30))
                    costField.text = equipment["cost"].string
                    costField.textAlignment = NSTextAlignment.center
                    costField.layer.borderWidth = 1.0
                    costField.layer.borderColor = UIColor.black.cgColor
                    costField.tag = 600 + (indexPath.row * 100) + 36
                    scrollView.addSubview(costField)
                    
                    let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 300, width: 80, height: 30))
                    amountLabel.text = "Amount"
                    amountLabel.tag = 600 + (indexPath.row * 100) + 37
                    scrollView.addSubview(amountLabel)
                    
                    let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:300, width:60, height:30))
                    quantityLabel.text = equipment["amount"].string
                    quantityLabel.textAlignment = NSTextAlignment.center
                    quantityLabel.layer.borderWidth = 1.0
                    quantityLabel.layer.borderColor = UIColor.black.cgColor
                    quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                    scrollView.addSubview(quantityLabel)
                    
                    let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 300, width:94, height:29))
                    amountStepper.value = 0//weapon["amount"].double!
                    amountStepper.minimumValue = 0
                    amountStepper.maximumValue = 1000
                    amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                    amountStepper.tag = 600 + (indexPath.row * 100) + 39
                    scrollView.addSubview(amountStepper)
                    
                    let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 340, width: 100, height: 30))
                    descriptionLabel.text = "Description"
                    descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                    scrollView.addSubview(descriptionLabel)
                    
                    let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 380, width: tempView.frame.size.width-10, height: 100))
                    descriptionView.text = equipment["description"].string
                    descriptionView.layer.borderWidth = 1.0
                    descriptionView.layer.borderColor = UIColor.black.cgColor
                    descriptionView.tag = 600 + (indexPath.row * 100) + 41
                    scrollView.addSubview(descriptionView)
                    
                    scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 490)
                    
                    view.addSubview(tempView)
                }
                else if equipment["ability"].exists() {
                    // Tools
                    let tempView = createBasicView()
                    tempView.tag = 600 + (100 * indexPath.row)
                    
                    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                    tempView.addSubview(scrollView)
                    
                    let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                    title.text = equipment["name"].string?.capitalized
                    title.textAlignment = NSTextAlignment.center
                    title.tag = 600 + (indexPath.row * 100) + 1
                    title.layer.borderWidth = 1.0
                    title.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(title)
                    
                    // proficient switch
                    let proficientLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: 200, height: 30))
                    proficientLabel.text = "Proficient"
                    proficientLabel.tag = 600 + (indexPath.row * 100) + 2
                    scrollView.addSubview(proficientLabel)
                    
                    let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width-61, y:45, width:51, height:31))
                    proficientSwitch.isOn = equipment["proficient"].bool!
                    proficientSwitch.tag = 600 + (indexPath.row * 100) + 3
                    scrollView.addSubview(proficientSwitch)
                    
                    // Ability Bonus
                    let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:80, width:tempView.frame.size.width-20, height:30))
                    aa.insertSegment(withTitle:"STR", at:0, animated:false)
                    aa.insertSegment(withTitle:"DEX", at:1, animated:false)
                    aa.insertSegment(withTitle:"CON", at:2, animated:false)
                    aa.insertSegment(withTitle:"INT", at:3, animated:false)
                    aa.insertSegment(withTitle:"WIS", at:4, animated:false)
                    aa.insertSegment(withTitle:"CHA", at:5, animated:false)
                    aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
                    aa.tag = 600 + (indexPath.row * 100) + 4
                    scrollView.addSubview(aa)
                    
                    let abilityLabel = UILabel.init(frame: CGRect.init(x: 10, y: 120, width: 200, height: 30))
                    abilityLabel.tag = 600 + (indexPath.row * 100) + 5
                    scrollView.addSubview(abilityLabel)
                    
                    let abilityField = UITextField.init(frame: CGRect.init(x:160, y:120, width:40, height:30))
                    abilityField.textAlignment = NSTextAlignment.center
                    abilityField.tag = 600 + (indexPath.row * 100) + 6
                    abilityField.layer.borderWidth = 1.0
                    abilityField.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(abilityField)
                    
                    let abilityType: String = equipment["ability"].string!
                    switch abilityType {
                    case "STR":
                        abilityLabel.text = "Strength Bonus"
                        abilityField.text = String(appDelegate.character.strBonus)
                        aa.selectedSegmentIndex = 0
                    case "DEX":
                        abilityLabel.text = "Dexterity Bonus"
                        abilityField.text = String(appDelegate.character.dexBonus)
                        aa.selectedSegmentIndex = 1
                    case "CON":
                        abilityLabel.text = "Constitution Bonus"
                        abilityField.text = String(appDelegate.character.conBonus)
                        aa.selectedSegmentIndex = 2
                    case "INT":
                        abilityLabel.text = "Intelligence Bonus"
                        abilityField.text = String(appDelegate.character.intBonus)
                        aa.selectedSegmentIndex = 3
                    case "WIS":
                        abilityLabel.text = "Wisdom Bonus"
                        abilityField.text = String(appDelegate.character.wisBonus)
                        aa.selectedSegmentIndex = 4
                    case "CHA":
                        abilityLabel.text = "Charisma Bonus"
                        abilityField.text = String(appDelegate.character.chaBonus)
                        aa.selectedSegmentIndex = 5
                    default: break
                    }
                    
                    // weight
                    let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 160, width: 80, height: 30))
                    weightLabel.text = "Weight"
                    weightLabel.tag = 600 + (indexPath.row * 100) + 18
                    scrollView.addSubview(weightLabel)
                    
                    let weightField = UITextField.init(frame: CGRect.init(x:90, y:160, width:tempView.frame.size.width - 100, height:30))
                    weightField.text = equipment["weight"].string
                    weightField.textAlignment = NSTextAlignment.center
                    weightField.layer.borderWidth = 1.0
                    weightField.layer.borderColor = UIColor.black.cgColor
                    weightField.tag = 600 + (indexPath.row * 100) + 34
                    scrollView.addSubview(weightField)
                    
                    // cost
                    let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 200, width: 80, height: 30))
                    costLabel.text = "Cost"
                    costLabel.tag = 600 + (indexPath.row * 100) + 35
                    scrollView.addSubview(costLabel)
                    
                    let costField = UITextField.init(frame: CGRect.init(x:90, y:200, width:tempView.frame.size.width - 100, height:30))
                    costField.text = equipment["cost"].string
                    costField.textAlignment = NSTextAlignment.center
                    costField.layer.borderWidth = 1.0
                    costField.layer.borderColor = UIColor.black.cgColor
                    costField.tag = 600 + (indexPath.row * 100) + 36
                    scrollView.addSubview(costField)
                    
                    // amount
                    let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 240, width: 80, height: 30))
                    amountLabel.text = "Amount"
                    amountLabel.tag = 600 + (indexPath.row * 100) + 37
                    scrollView.addSubview(amountLabel)
                    
                    let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:240, width:60, height:30))
                    quantityLabel.text = equipment["amount"].string
                    quantityLabel.textAlignment = NSTextAlignment.center
                    quantityLabel.layer.borderWidth = 1.0
                    quantityLabel.layer.borderColor = UIColor.black.cgColor
                    quantityLabel.tag = 600 + (indexPath.row * 100) + 38
                    scrollView.addSubview(quantityLabel)
                    
                    let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 240, width:94, height:29))
                    amountStepper.value = 0//weapon["amount"].double!
                    amountStepper.minimumValue = 0
                    amountStepper.maximumValue = 1000
                    amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                    amountStepper.tag = 600 + (indexPath.row * 100) + 39
                    scrollView.addSubview(amountStepper)
                    
                    // description
                    let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: 100, height: 30))
                    descriptionLabel.text = "Description"
                    descriptionLabel.tag = 600 + (indexPath.row * 100) + 40
                    scrollView.addSubview(descriptionLabel)
                    
                    let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 280, width: tempView.frame.size.width-10, height: 100))
                    descriptionView.text = equipment["description"].string
                    descriptionView.layer.borderWidth = 1.0
                    descriptionView.layer.borderColor = UIColor.black.cgColor
                    descriptionView.tag = 600 + (indexPath.row * 100) + 41
                    scrollView.addSubview(descriptionView)
                    
                    scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 390)
                    
                    view.addSubview(tempView)
                }
                else {
                    // Other
                    let tempView = createBasicView()
                    tempView.tag = 600 + (100 * indexPath.row)
                    
                    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
                    tempView.addSubview(scrollView)
                    
                    // name
                    let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
                    title.text = equipment["name"].string?.capitalized
                    title.textAlignment = NSTextAlignment.center
                    title.tag = 600 + (indexPath.row * 100) + 1
                    title.layer.borderWidth = 1.0
                    title.layer.borderColor = UIColor.black.cgColor
                    scrollView.addSubview(title)
                    
                    //weight
                    let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: 80, height: 30))
                    weightLabel.text = "Weight"
                    weightLabel.tag = 600 + (indexPath.row * 100) + 2
                    scrollView.addSubview(weightLabel)
                    
                    let weightField = UITextField.init(frame: CGRect.init(x:90, y:45, width:tempView.frame.size.width - 100, height:30))
                    weightField.text = equipment["weight"].string
                    weightField.textAlignment = NSTextAlignment.center
                    weightField.layer.borderWidth = 1.0
                    weightField.layer.borderColor = UIColor.black.cgColor
                    weightField.tag = 600 + (indexPath.row * 100) + 3
                    scrollView.addSubview(weightField)
                    
                    // cost
                    let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 85, width: 80, height: 30))
                    costLabel.text = "Cost"
                    costLabel.tag = 600 + (indexPath.row * 100) + 4
                    scrollView.addSubview(costLabel)
                    
                    let costField = UITextField.init(frame: CGRect.init(x:90, y:85, width:tempView.frame.size.width - 100, height:30))
                    costField.text = equipment["cost"].string
                    costField.textAlignment = NSTextAlignment.center
                    costField.layer.borderWidth = 1.0
                    costField.layer.borderColor = UIColor.black.cgColor
                    costField.tag = 600 + (indexPath.row * 100) + 5
                    scrollView.addSubview(costField)
                    
                    // amount
                    let amountLabel = UILabel.init(frame: CGRect.init(x: 10, y: 125, width: 80, height: 30))
                    amountLabel.text = "Amount"
                    amountLabel.tag = 600 + (indexPath.row * 100) + 6
                    scrollView.addSubview(amountLabel)
                    
                    let quantityLabel = UILabel.init(frame: CGRect.init(x:90, y:125, width:60, height:30))
                    quantityLabel.text = equipment["amount"].string
                    quantityLabel.textAlignment = NSTextAlignment.center
                    quantityLabel.layer.borderWidth = 1.0
                    quantityLabel.layer.borderColor = UIColor.black.cgColor
                    quantityLabel.tag = 600 + (indexPath.row * 100) + 7
                    scrollView.addSubview(quantityLabel)
                    
                    let amountStepper = UIStepper.init(frame: CGRect.init(x: 160, y: 125, width:94, height:29))
                    amountStepper.value = 0//weapon["amount"].double!
                    amountStepper.minimumValue = 0
                    amountStepper.maximumValue = 1000
                    amountStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                    amountStepper.tag = 600 + (indexPath.row * 100) + 8
                    scrollView.addSubview(amountStepper)
                    
                    // description
                    let descriptionLabel = UILabel.init(frame: CGRect.init(x: 10, y: 165, width: 100, height: 30))
                    descriptionLabel.text = "Description"
                    descriptionLabel.tag = 600 + (indexPath.row * 100) + 9
                    scrollView.addSubview(descriptionLabel)
                    
                    let descriptionView = UITextView.init(frame: CGRect.init(x: 5, y: 205, width: tempView.frame.size.width-10, height: 100))
                    descriptionView.text = equipment["description"].string
                    descriptionView.layer.borderWidth = 1.0
                    descriptionView.layer.borderColor = UIColor.black.cgColor
                    descriptionView.tag = 600 + (indexPath.row * 100) + 10
                    scrollView.addSubview(descriptionView)
                    
                    scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 315)
                    
                    view.addSubview(tempView)
                }
            }
        }
        else {
            // New cell
            
        }
    }
    
    func createBasicView() -> UIView {
        let tempView = UIView.init(frame: CGRect.init(x:20, y:10+64, width:view.frame.size.width-40, height:view.frame.size.height/2-20-32))
        tempView.layer.borderWidth = 1.0
        tempView.layer.borderColor = UIColor.black.cgColor
        tempView.backgroundColor = UIColor.white
        
        let applyBtn = UIButton.init(type: UIButtonType.custom)
        applyBtn.frame = CGRect.init(x:10, y:tempView.frame.size.height-45, width:tempView.frame.size.width/2-10, height:30)
        applyBtn.setTitle("Apply", for:UIControlState.normal)
        applyBtn.addTarget(self, action: #selector(self.applyAction), for: UIControlEvents.touchUpInside)
        applyBtn.layer.borderWidth = 1.0
        applyBtn.layer.borderColor = UIColor.black.cgColor
        applyBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
        tempView.addSubview(applyBtn)
        
        let cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x:tempView.frame.size.width/2+10, y:tempView.frame.size.height-45, width:tempView.frame.size.width/2-20, height:30)
        cancelBtn.setTitle("Cancel", for:UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelAction), for: UIControlEvents.touchUpInside)
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
        tempView.addSubview(cancelBtn)
        
        return tempView
    }
    
    func applyAction(button: UIButton) {
        let parentView:UIView = button.superview!
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return damageTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //appDelegate.character. = damageTypes[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.systemFont(ofSize: 17)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = damageTypes[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width-20
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 21.0
    }
    
    @IBAction func typePickerViewSelected(sender: AnyObject) {
        
    }
    
    func stepperChanged(stepper: UIStepper) {
        
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
