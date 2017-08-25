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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))

        equipmentTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))

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
        let currency = Character.Selected.equipment!.currency!
        // Platinum
        platinumValue.text = String(currency.platinum)

        // Gold
        goldValue.text = String(currency.gold)

        // Electrum
        electrumValue.text = String(currency.electrum)

        // Silver
        silverValue.text = String(currency.silver)

        // Copper
        copperValue.text = String(currency.copper)

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
        if segControl.tag == 0 {
            equipmentTable.reloadData()
        }
        else {
            let parentView:UIScrollView = segControl.superview! as! UIScrollView
            let baseTag = parentView.superview!.tag
            
            var bonus = ""
            var title = ""
            switch segControl.selectedSegmentIndex {
            case 0:
                // STR
                bonus = String(Character.Selected.strBonus)
                title = "Strength"
                break
            case 1:
                // DEX
                bonus = String(Character.Selected.dexBonus)
                title = "Dexterity"
                break
            case 2:
                // CON
                bonus = String(Character.Selected.conBonus)
                title = "Constitution"
                break
            case 3:
                // INT
                bonus = String(Character.Selected.intBonus)
                title = "Intelligence"
                break
            case 4:
                // WIS
                bonus = String(Character.Selected.wisBonus)
                title = "Wisdom"
                break
            case 5:
                // CHA
                bonus = String(Character.Selected.chaBonus)
                title = "Charisma"
                break
            default:
                break
            }
            
            for case let view in parentView.subviews {
                if view.tag == baseTag + 10 {
                    // Attribute Label
                    let attributeLabel = view as! UILabel
                    attributeLabel.text = title+"\nBonus"
                }
                else if view.tag == baseTag + 11 {
                    // Attribute Textfield
                    let attributeTextField = view as! UITextField
                    attributeTextField.text = bonus
                }
            }
        }
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                return Character.Selected.equipment!.weapons!.count
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                return Character.Selected.equipment!.armor!.count
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                return Character.Selected.equipment!.tools!.count
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                return Character.Selected.equipment!.other!.count
            }
            else {
                // All
                return Character.Selected.equipment!.weapons!.count + Character.Selected.equipment!.armor!.count + Character.Selected.equipment!.tools!.count + Character.Selected.equipment!.other!.count
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
        
            let weapons = Character.Selected.equipment!.weapons
            let allArmor = Character.Selected.equipment!.armor
            let tools = Character.Selected.equipment!.tools
            let other = Character.Selected.equipment!.other
            
            var all_equipment:[Any] = []
            all_equipment.append(contentsOf:weapons!.allObjects)
            all_equipment.append(contentsOf:allArmor!.allObjects)
            all_equipment.append(contentsOf:tools!.allObjects)
            all_equipment.append(contentsOf:other!.allObjects)
            all_equipment.sort {($0 as AnyObject).name < ($1 as AnyObject).name}
            
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                let weapon = weapons?.allObjects[indexPath.row] as! Weapon
        
                let description = weapon.info! + "\nWeight: " + weapon.weight! + "\nCost: " + weapon.cost!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                let height = 30+5+30+5+21+descriptionHeight
                return height//165
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let armor = allArmor?.allObjects[indexPath.row] as! Armor
        
                var stealthDisadvantage = ""
                if armor.stealth_disadvantage {
                    stealthDisadvantage = "Yes"
                }
                else {
                    stealthDisadvantage = "No"
                }
        
                var equipped = ""
                if armor.equipped {
                    equipped = "Yes"
                }
                else {
                    equipped = "No"
                }
        
                var description = armor.info
                description = description! + "\nMinimum Strength: " + String(armor.str_requirement)
                description = description! + "\nStealth Disadvantage: " + stealthDisadvantage
                description = description! + "\nEquipped: " + equipped
                description = description! + "\nWeight: " + armor.weight!
                description = description! + "\nCost: " + armor.cost!
                let descriptionHeight = description!.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                let height = 30+5+21+5+21+descriptionHeight
                return height
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let tool = tools?.allObjects[indexPath.row] as! Tool
        
                let description = tool.info! + "\nWeight: " + tool.weight! + "\nCost: " + tool.cost!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                let height = 30+5+21+5+21+descriptionHeight
                return height
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let otherItem = other?.allObjects[indexPath.row] as! Item
        
                let description = otherItem.info! + "\nWeight: " + otherItem.weight! + "\nCost: " + otherItem.cost!
                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                let height = 30+5+21+descriptionHeight
                return height
            }
            else {
                // All equipment
                let item = all_equipment[indexPath.row]

                if item is Weapon {
                    // Weapon
                    let weaponItem = item as! Weapon
                    
                    let description = weaponItem.info! + "\nWeight: " + weaponItem.weight! + "\nCost: " + weaponItem.cost!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                    let height = 30+5+30+5+21+descriptionHeight
                    return height//165
                }
                else if item is Armor {
                    // Armor
                    let armorItem = item as! Armor
                    
                    var stealthDisadvantage = ""
                    if armorItem.stealth_disadvantage {
                        stealthDisadvantage = "Yes"
                    }
                    else {
                        stealthDisadvantage = "No"
                    }
        
                    var equipped = ""
                    if armorItem.equipped {
                        equipped = "Yes"
                    }
                    else {
                        equipped = "No"
                    }
        
                    let description = armorItem.info! + "\nMinimum Strength: " + String(armorItem.str_requirement) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + armorItem.weight! + "\nCost: " + armorItem.cost!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                    let height = 30+5+21+5+21+descriptionHeight
                    return height//165
                }
                else if item is Tool {
                    // Tools
                    let toolItem = item as! Tool
                    let description = toolItem.info! + "\nWeight: " + toolItem.weight! + "\nCost: " + toolItem.cost!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                    let height = 30+5+21+5+21+descriptionHeight
                    return height//165
                }
                else if item is Item {
                    // Other
                    let otherItem = item as! Item
                    let description = otherItem.info! + "\nWeight: " + otherItem.weight! + "\nCost: " + otherItem.cost!
                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
        
                    let height = 30+5+21+descriptionHeight
                    return height//165
                }
                else {
                    return 0
                }
            }
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let weapons = Character.Selected.equipment!.weapons
            let allArmor = Character.Selected.equipment!.armor
            let tools = Character.Selected.equipment!.tools
            let other = Character.Selected.equipment!.other
            
            var all_equipment:[Any] = []
            all_equipment.append(contentsOf:weapons!.allObjects)
            all_equipment.append(contentsOf:allArmor!.allObjects)
            all_equipment.append(contentsOf:tools!.allObjects)
            all_equipment.append(contentsOf:other!.allObjects)
            all_equipment.sort {($0 as AnyObject).name < ($1 as AnyObject).name}
            
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
                let weapon:Weapon = weapons?.allObjects[indexPath.row] as! Weapon
                let damage:Damage = weapon.damage!
        
                var attackBonus: Int32 = 0
                var damageBonus: Int32 = 0
                let abilityType: String = weapon.ability!.name!
                switch abilityType {
                case "STR":
                    attackBonus = attackBonus + Character.Selected.strBonus //Add STR bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.strBonus
                    }
                case "DEX":
                    attackBonus = attackBonus + Character.Selected.dexBonus //Add DEX bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.dexBonus
                    }
                case "CON":
                    attackBonus = attackBonus + Character.Selected.conBonus //Add CON bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.conBonus
                    }
                case "INT":
                    attackBonus = attackBonus + Character.Selected.intBonus //Add INT bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.intBonus
                    }
                case "WIS":
                    attackBonus = attackBonus + Character.Selected.wisBonus //Add WIS bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.wisBonus
                    }
                case "CHA":
                    attackBonus = attackBonus + Character.Selected.chaBonus //Add CHA bonus
                    if damage.mod_damage {
                        damageBonus = damageBonus + Character.Selected.chaBonus
                    }
                default: break
                }
        
                attackBonus = attackBonus + weapon.magic_bonus + weapon.misc_bonus
                damageBonus = damageBonus + damage.magic_bonus + damage.misc_bonus
        
                var damageDieNumber = damage.die_number
                var damageDie = damage.die_type
                let extraDie = damage.extra_die
                if (extraDie) {
                    damageDieNumber = damageDieNumber + damage.extra_die_number
                    damageDie = damageDie + damage.extra_die_type
                }
        
                let damageType = damage.damage_type
        
                cell.weaponName.text = weapon.name?.capitalized
                cell.weaponReach.text = "Range: "+weapon.range!
                cell.weaponModifier.text = "+"+String(attackBonus)
                let dieDamage = String(damageDieNumber)+"d"+String(damageDie)
                cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
        
                cell.descView.text = weapon.info! + "\nWeight: " + weapon.weight! + "\nCost: " + weapon.cost!
                if weapon.quantity <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(weapon.quantity)
                }
        
                return cell
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
                let armor:Armor = allArmor?.allObjects[indexPath.row] as! Armor
                cell.armorName.text = armor.name
        
                var armorValue = armor.value
                armorValue += armor.magic_bonus
                armorValue += armor.misc_bonus
        
                if (armor.ability_mod?.name != "") {
                    cell.armorValue.text = String(armorValue) + "+" + (armor.ability_mod?.name!)!
                }
                else {
                    cell.armorValue.text = String(armorValue)
                }
        
                var stealthDisadvantage = ""
                if armor.stealth_disadvantage {
                    stealthDisadvantage = "Yes"
                }
                else {
                    stealthDisadvantage = "No"
                }
        
                var equipped = ""
                if armor.equipped {
                    equipped = "Yes"
                }
                else {
                    equipped = "No"
                }
                
                var armorDescription = armor.info
                armorDescription = armorDescription! + "\nMinimum Strength: " + String(armor.str_requirement)
                armorDescription = armorDescription! + "\nStealth Disadvantage: " + stealthDisadvantage
                armorDescription = armorDescription! + "\nEquipped: " + equipped
                armorDescription = armorDescription! + "\nWeight: " + armor.weight!
                armorDescription = armorDescription! + "\nCost: " + armor.cost!
                cell.descView.text = armorDescription
                if armor.quantity <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(armor.quantity)
                }
        
                return cell
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
                let tool:Tool = tools?.allObjects[indexPath.row] as! Tool
        
                var toolValue: Int32 = 0
                if tool.proficient {
                    toolValue += Character.Selected.proficiencyBonus
                }
        
                let abilityType: String = tool.ability!.name!
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
        
                cell.toolName.text = tool.name
                cell.toolValue.text = "+"+String(toolValue)
                cell.descView.text = tool.info! + "\nWeight: " + tool.weight! + "\nCost: " + tool.cost!
                if tool.quantity <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(tool.quantity)
                }
                return cell
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
                let otherItem:Item = other?.allObjects[indexPath.row] as! Item
        
                cell.equipmentName.text = otherItem.name
                cell.descView.text = otherItem.info! + "\nWeight: " + otherItem.weight! + "\nCost: " + otherItem.cost!
                if otherItem.quantity <= 1 {
                    cell.amountLabel.text = ""
                }
                else {
                    cell.amountLabel.text = "x"+String(otherItem.quantity)
                }
        
                return cell
            }
            else {
                // All equipment
                let item = all_equipment[indexPath.row]
                
                if item is Weapon {
                    // Weapon
                    let weaponItem = item as! Weapon
                    let damage:Damage = weaponItem.damage!
                    
                    var attackBonus: Int32 = 0
                    var damageBonus: Int32 = 0
                    let abilityType: String = weaponItem.ability!.name!
                    switch abilityType {
                    case "STR":
                        attackBonus = attackBonus + Character.Selected.strBonus //Add STR bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.strBonus
                        }
                    case "DEX":
                        attackBonus = attackBonus + Character.Selected.dexBonus //Add DEX bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.dexBonus
                        }
                    case "CON":
                        attackBonus = attackBonus + Character.Selected.conBonus //Add CON bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.conBonus
                        }
                    case "INT":
                        attackBonus = attackBonus + Character.Selected.intBonus //Add INT bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.intBonus
                        }
                    case "WIS":
                        attackBonus = attackBonus + Character.Selected.wisBonus //Add WIS bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.wisBonus
                        }
                    case "CHA":
                        attackBonus = attackBonus + Character.Selected.chaBonus //Add CHA bonus
                        if damage.mod_damage {
                            damageBonus = damageBonus + Character.Selected.chaBonus
                        }
                    default: break
                    }
                    
                    attackBonus = attackBonus + weaponItem.magic_bonus + weaponItem.misc_bonus
                    damageBonus = damageBonus + damage.magic_bonus + damage.misc_bonus
                    
                    var damageDieNumber = damage.die_number
                    var damageDie = damage.die_type
                    let extraDie = damage.extra_die
                    if (extraDie) {
                        damageDieNumber = damageDieNumber + damage.extra_die_number
                        damageDie = damageDie + damage.extra_die_type
                    }
                    
                    let damageType = damage.damage_type
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
                    cell.weaponName.text = weaponItem.name?.capitalized
                    cell.weaponReach.text = "Range: "+weaponItem.range!
                    cell.weaponModifier.text = "+"+String(attackBonus)
                    let dieDamage = String(damageDieNumber)+"d"+String(damageDie)
                    cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
                    
                    cell.descView.text = weaponItem.info! + "\nWeight: " + weaponItem.weight! + "\nCost: " + weaponItem.cost!
                    if weaponItem.quantity <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(weaponItem.quantity)
                    }
                    
                    return cell
                }
                else if item is Armor {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
                    let armorItem = item as! Armor
                    cell.armorName.text = armorItem.name
                    
                    var armorValue = armorItem.value
                    armorValue += armorItem.magic_bonus
                    armorValue += armorItem.misc_bonus
                    
                    if (armorItem.ability_mod?.name != "") {
                        cell.armorValue.text = String(armorValue) + "+" + (armorItem.ability_mod?.name!)!
                    }
                    else {
                        cell.armorValue.text = String(armorValue)
                    }
                    
                    var stealthDisadvantage = ""
                    if armorItem.stealth_disadvantage {
                        stealthDisadvantage = "Yes"
                    }
                    else {
                        stealthDisadvantage = "No"
                    }
                    
                    var equipped = ""
                    if armorItem.equipped {
                        equipped = "Yes"
                    }
                    else {
                        equipped = "No"
                    }
                    
                    var armorDescription = armorItem.info
                    armorDescription = armorDescription! + "\nMinimum Strength: " + String(armorItem.str_requirement)
                    armorDescription = armorDescription! + "\nStealth Disadvantage: " + stealthDisadvantage
                    armorDescription = armorDescription! + "\nEquipped: " + equipped
                    armorDescription = armorDescription! + "\nWeight: " + armorItem.weight!
                    armorDescription = armorDescription! + "\nCost: " + armorItem.cost!
                    cell.descView.text = armorDescription
                    if armorItem.quantity <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(armorItem.quantity)
                    }
                    
                    return cell
                }
                else if item is Tool {
                    // Tools
                    let toolItem = item as! Tool
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
                    
                    var toolValue: Int32 = 0
                    if toolItem.proficient {
                        toolValue = toolValue + Character.Selected.proficiencyBonus
                    }
                    
                    let abilityType: String = toolItem.ability!.name!
                    switch abilityType {
                    case "STR":
                        toolValue = toolValue + Character.Selected.strBonus //Add STR bonus
                    case "DEX":
                        toolValue = toolValue + Character.Selected.dexBonus //Add DEX bonus
                    case "CON":
                        toolValue = toolValue + Character.Selected.conBonus //Add CON bonus
                    case "INT":
                        toolValue = toolValue + Character.Selected.intBonus //Add INT bonus
                    case "WIS":
                        toolValue = toolValue + Character.Selected.wisBonus //Add WIS bonus
                    case "CHA":
                        toolValue = toolValue + Character.Selected.chaBonus //Add CHA bonus
                    default: break
                    }
                    
                    cell.toolName.text = toolItem.name
                    cell.toolValue.text = "+"+String(toolValue)
                    cell.descView.text = toolItem.info! + "\nWeight: " + toolItem.weight! + "\nCost: " + toolItem.cost!
                    if toolItem.quantity <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(toolItem.quantity)
                    }
                    return cell
                }
                else if item is Item {
                    let otherItem = item as! Item
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
                    
                    cell.equipmentName.text = otherItem.name
                    cell.descView.text = otherItem.info! + "\nWeight: " + otherItem.weight! + "\nCost: " + otherItem.cost!
                    if otherItem.quantity <= 1 {
                        cell.amountLabel.text = ""
                    }
                    else {
                        cell.amountLabel.text = "x"+String(otherItem.quantity)
                    }
                    
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
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
            let weapons = Character.Selected.equipment!.weapons
            let allArmor = Character.Selected.equipment!.armor
            let tools = Character.Selected.equipment!.tools
            let other = Character.Selected.equipment!.other
            
            var all_equipment:[Any] = []
            all_equipment.append(contentsOf:weapons!.allObjects)
            all_equipment.append(contentsOf:allArmor!.allObjects)
            all_equipment.append(contentsOf:tools!.allObjects)
            all_equipment.append(contentsOf:other!.allObjects)
            all_equipment.sort {($0 as AnyObject).name < ($1 as AnyObject).name}
            
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                createWeaponDetailView(indexPath: indexPath)
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
            }
            else {
                // All equipment
                let item = all_equipment[indexPath.row]
                
                if item is Weapon {
                    
                }
                else if item is Armor {
                    
                }
                else if item is Tool {
                    
                }
                else if item is Item {
                    
                }
                else {
                    
                }
            }
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
        
        let baseTag = parentView.tag
        let index = baseTag/100
        
        let weapon = Character.Selected.equipment?.weapons?.allObjects[index] as! Weapon
        let damage = weapon.damage! as Damage
        
        for case let view in parentView.subviews {
            if let scrollView = view as? UIScrollView {
                for case let view in scrollView.subviews {
                    if view.tag == baseTag + 1 {
                        // Name - TF
                        let textField = view as! UITextField
                        weapon.name = textField.text
                    }
                    else if view.tag == baseTag + 3 {
                        // Range - TF
                        let textField = view as! UITextField
                        weapon.range = textField.text
                    }
                    else if view.tag == baseTag + 5 {
                        // Damage Type - Picker
                        let picker = view as! UIPickerView
                        damage.damage_type = Types.DamageStrings[picker.selectedRow(inComponent: 0)]
                    }
                    else if view.tag == baseTag + 7 {
                        // Attack Ability Mod - Segmented Control
                        let segControl = view as! UISegmentedControl
                        switch segControl.selectedSegmentIndex {
                        case 0:
                            // STR
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                            break
                        case 1:
                            // DEX
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                            break
                        case 2:
                            // CON
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                            break
                        case 3:
                            // INT
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                            break
                        case 4:
                            // WIS
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                            break
                        case 5:
                            // CHA
                            weapon.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                            break
                        default:
                            break
                        }
                    }
                    else if view.tag == baseTag + 13 {
                        // Magic Attack Bonus - TF
                        let textField = view as! UITextField
                        weapon.magic_bonus = Int32(textField.text!)!
                        
                    }
                    else if view.tag == baseTag + 15 {
                        // Misc Attack Bonus - TF
                        let textField = view as! UITextField
                        weapon.misc_bonus = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 17 {
                        // TODO: Proficient With Weapon - Switch
                        let profSwitch = view as! UISwitch
                        //                                Character.Selected.weapon_proficiencies
                    }
                    else if view.tag == baseTag + 19 {
                        // Ability Mod to Damage - Switch
                        let amdSwitch = view as! UISwitch
                        damage.mod_damage = amdSwitch.isOn
                    }
                    else if view.tag == baseTag + 21 {
                        // Magic Damage Bonus - TF
                        let textField = view as! UITextField
                        damage.magic_bonus = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 23 {
                        // Misc Damage Bonus - TF
                        let textField = view as! UITextField
                        damage.misc_bonus = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 26 {
                        // Weapon Damage Die Amount - TF
                        let textField = view as! UITextField
                        damage.die_number = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 28 {
                        // Weapon Damage Die - TF
                        let textField = view as! UITextField
                        damage.die_type = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 29 {
                        // Extra Die - Switch
                        let extraDieSwitch = view as! UISwitch
                        damage.extra_die = extraDieSwitch.isOn
                    }
                    else if view.tag == baseTag + 30 {
                        // Extra Die Amount - TF
                        let textField = view as! UITextField
                        damage.extra_die_number = Int32(textField.text!)!
                    }
                    else if view.tag == baseTag + 32 {
                        // Extra Die - TF
                        let textField = view as! UITextField
                        damage.extra_die_type = Int32(textField.text!)!
                    }
                }
            }
        }
        
        var attackBonus: Int32 = 0
        var damageBonus: Int32 = 0
        let modDamage = damage.mod_damage
        let abilityType: String = (weapon.ability?.name)!
        switch abilityType {
        case "STR":
            attackBonus = attackBonus + Character.Selected.strBonus //Add STR bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.strBonus
            }
        case "DEX":
            attackBonus = attackBonus + Character.Selected.dexBonus //Add DEX bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.dexBonus
            }
        case "CON":
            attackBonus = attackBonus + Character.Selected.conBonus //Add CON bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.conBonus
            }
        case "INT":
            attackBonus = attackBonus + Character.Selected.intBonus //Add INT bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.intBonus
            }
        case "WIS":
            attackBonus = attackBonus + Character.Selected.wisBonus //Add WIS bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.wisBonus
            }
        case "CHA":
            attackBonus = attackBonus + Character.Selected.chaBonus //Add CHA bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.chaBonus
            }
        default: break
        }
        
        attackBonus = attackBonus + weapon.magic_bonus + weapon.misc_bonus
        damageBonus = damageBonus + damage.magic_bonus + damage.misc_bonus
        
        var damageDieNumber = damage.die_number
        var damageDie = damage.die_type
        let extraDie = damage.extra_die
        if (extraDie) {
            damageDieNumber = damageDieNumber + damage.extra_die_number
            damageDie = damageDie + damage.extra_die_type
        }
        
        weapon.damage = damage
        Character.Selected.equipment?.removeFromWeapons(Character.Selected.equipment?.weapons?.allObjects[index] as! Weapon)
        Character.Selected.equipment?.addToWeapons(weapon)
        
        equipmentTable.reloadData()
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func createWeaponDetailView(indexPath: IndexPath) {
        let tempView = createBasicView()
        let baseTag = indexPath.row * 100
        tempView.tag = baseTag
        
        let weapon = Character.Selected.equipment?.weapons?.allObjects[indexPath.row] as! Weapon
        let damage = weapon.damage! as Damage
        
        var attackBonus: Int32 = 0
        var damageBonus: Int32 = 0
        let modDamage = damage.mod_damage
        let abilityType: String = (weapon.ability?.name)!
        switch abilityType {
        case "STR":
            attackBonus = attackBonus + Character.Selected.strBonus //Add STR bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.strBonus
            }
        case "DEX":
            attackBonus = attackBonus + Character.Selected.dexBonus //Add DEX bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.dexBonus
            }
        case "CON":
            attackBonus = attackBonus + Character.Selected.conBonus //Add CON bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.conBonus
            }
        case "INT":
            attackBonus = attackBonus + Character.Selected.intBonus //Add INT bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.intBonus
            }
        case "WIS":
            attackBonus = attackBonus + Character.Selected.wisBonus //Add WIS bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.wisBonus
            }
        case "CHA":
            attackBonus = attackBonus + Character.Selected.chaBonus //Add CHA bonus
            if modDamage {
                damageBonus = damageBonus + Character.Selected.chaBonus
            }
        default: break
        }
        
        attackBonus = attackBonus + weapon.magic_bonus + weapon.misc_bonus
        damageBonus = damageBonus + damage.magic_bonus + damage.misc_bonus
        
        var damageDieNumber = damage.die_number
        var damageDie = damage.die_type
        let extraDie = damage.extra_die
        if (extraDie) {
            damageDieNumber = damageDieNumber + damage.extra_die_number
            damageDie = damageDie + damage.extra_die_type
        }
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = weapon.name?.capitalized
        title.textAlignment = NSTextAlignment.center
        title.tag = baseTag + 1
        title.layer.borderWidth = 1.0
        title.layer.borderColor = UIColor.black.cgColor
        scrollView.addSubview(title)
        
        let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: tempView.frame.size.width/2-15, height: 30))
        reachLabel.text = "Range"
        reachLabel.textAlignment = NSTextAlignment.center
        reachLabel.tag = baseTag + 2
        scrollView.addSubview(reachLabel)
        
        let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 55, width: tempView.frame.size.width/2-15, height: 40))
        reachField.text = weapon.range
        reachField.textAlignment = NSTextAlignment.center
        reachField.layer.borderWidth = 1.0
        reachField.layer.borderColor = UIColor.black.cgColor
        reachField.tag = baseTag + 3
        scrollView.addSubview(reachField)
        
        let damageTypeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 30, width: tempView.frame.size.width/2-15, height: 30))
        damageTypeLabel.text = "Damage Type"
        damageTypeLabel.textAlignment = NSTextAlignment.center
        damageTypeLabel.tag = baseTag + 4
        scrollView.addSubview(damageTypeLabel)
        
        let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 55, width: tempView.frame.size.width/2-15, height: 40))
        damageTypePickerView.dataSource = self
        damageTypePickerView.delegate = self
        damageTypePickerView.layer.borderWidth = 1.0
        damageTypePickerView.layer.borderColor = UIColor.black.cgColor
        damageTypePickerView.tag = baseTag + 5
        let row = Types.DamageStrings.index(of: damage.damage_type!)
        damageTypePickerView.selectRow(row!, inComponent: 0, animated: false)
        scrollView.addSubview(damageTypePickerView)
        
        let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
        attackLabel.text = "Attack Ability"
        attackLabel.textAlignment = NSTextAlignment.center
        attackLabel.tag = baseTag + 6
        scrollView.addSubview(attackLabel)
        
        var aaIndex = 0
        var abilityName = ""
        var abilityMod: Int32 = 0
        switch abilityType {
        case "STR":
            aaIndex = 0
            abilityName = "Strength"
            abilityMod = Character.Selected.strBonus
        case "DEX":
            aaIndex = 1
            abilityName = "Dexterity"
            abilityMod = Character.Selected.dexBonus
        case "CON":
            aaIndex = 2
            abilityName = "Constitution"
            abilityMod = Character.Selected.conBonus
        case "INT":
            aaIndex = 3
            abilityName = "Intelligence"
            abilityMod = Character.Selected.intBonus
        case "WIS":
            aaIndex = 4
            abilityName = "Wisdom"
            abilityMod = Character.Selected.wisBonus
        case "CHA":
            aaIndex = 5
            abilityName = "Charisma"
            abilityMod = Character.Selected.chaBonus
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
        aa.tag = baseTag + 7
        scrollView.addSubview(aa)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 145, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = baseTag + 8
        scrollView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:170, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = baseTag + 9
        scrollView.addSubview(profField)
        
        let abilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
        abilityLabel.text = abilityName+"\nBonus"
        abilityLabel.font = UIFont.systemFont(ofSize: 10)
        abilityLabel.textAlignment = NSTextAlignment.center
        abilityLabel.numberOfLines = 2
        abilityLabel.tag = baseTag + 10
        scrollView.addSubview(abilityLabel)
        
        let abilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
        abilityField.text = String(abilityMod)
        abilityField.textAlignment = NSTextAlignment.center
        abilityField.isEnabled = false
        abilityField.textColor = UIColor.darkGray
        abilityField.layer.borderWidth = 1.0
        abilityField.layer.borderColor = UIColor.black.cgColor
        abilityField.tag = baseTag + 11
        scrollView.addSubview(abilityField)
        
        let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
        magicLabel.text = "Magic Item\nAttack Bonus"
        magicLabel.font = UIFont.systemFont(ofSize: 10)
        magicLabel.textAlignment = NSTextAlignment.center
        magicLabel.numberOfLines = 2
        magicLabel.tag = baseTag + 12
        scrollView.addSubview(magicLabel)
        
        let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
        magicField.text = String(weapon.magic_bonus)
        magicField.textAlignment = NSTextAlignment.center
        magicField.layer.borderWidth = 1.0
        magicField.layer.borderColor = UIColor.black.cgColor
        magicField.tag = baseTag + 13
        scrollView.addSubview(magicField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 145, width: 90, height: 30))
        miscLabel.text = "Misc\nAttack Bonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = baseTag + 14
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:170, width:40, height:30))
        miscField.text = String(weapon.misc_bonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = baseTag + 15
        scrollView.addSubview(miscField)
        
        let profWithLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 205, width: 90, height: 40))
        profWithLabel.text = "Proficient\nWith\nWeapon"
        profWithLabel.font = UIFont.systemFont(ofSize: 10)
        profWithLabel.textAlignment = NSTextAlignment.center
        profWithLabel.numberOfLines = 3
        profWithLabel.tag = baseTag + 16
        scrollView.addSubview(profWithLabel)
        
        let profWithSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 245, width:51, height:31))
        if (Character.Selected.weapon_proficiencies?.lowercased().contains(weapon.category!))! {
            profWithSwitch.isOn = true
        }
        else {
            profWithSwitch.isOn = false
        }
        profWithSwitch.tag = baseTag + 17
        scrollView.addSubview(profWithSwitch)
        
        let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 205, width: 90, height: 40))
        abilityDmgLabel.text = "Ability\nMod to\nDamage"
        abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
        abilityDmgLabel.textAlignment = NSTextAlignment.center
        abilityDmgLabel.numberOfLines = 3
        abilityDmgLabel.tag = baseTag + 18
        scrollView.addSubview(abilityDmgLabel)
        
        let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 245, width:51, height:31))
        abilityDmgSwitch.isOn = damage.mod_damage
        
        abilityDmgSwitch.tag = baseTag + 19
        scrollView.addSubview(abilityDmgSwitch)
        
        let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
        magicDmgLabel.text = "Magic Item\nDamage\nBonus"
        magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
        magicDmgLabel.textAlignment = NSTextAlignment.center
        magicDmgLabel.numberOfLines = 3
        magicDmgLabel.tag = baseTag + 20
        scrollView.addSubview(magicDmgLabel)
        
        let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
        magicDmgField.text = String(damage.magic_bonus)
        magicDmgField.textAlignment = NSTextAlignment.center
        magicDmgField.layer.borderWidth = 1.0
        magicDmgField.layer.borderColor = UIColor.black.cgColor
        magicDmgField.tag = baseTag + 21
        scrollView.addSubview(magicDmgField)
        
        let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
        miscDmgLabel.text = "Misc\nDamage\nBonus"
        miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
        miscDmgLabel.textAlignment = NSTextAlignment.center
        miscDmgLabel.numberOfLines = 3
        miscDmgLabel.tag = baseTag + 22
        scrollView.addSubview(miscDmgLabel)
        
        let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
        miscDmgField.text = String(damage.misc_bonus)
        miscDmgField.textAlignment = NSTextAlignment.center
        miscDmgField.layer.borderWidth = 1.0
        miscDmgField.layer.borderColor = UIColor.black.cgColor
        miscDmgField.tag = baseTag + 23
        scrollView.addSubview(miscDmgField)
        
        let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
        weaponDmgLabel.text = "Weapon Damage Die"
        weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
        weaponDmgLabel.textAlignment = NSTextAlignment.center
        weaponDmgLabel.tag = baseTag + 24
        scrollView.addSubview(weaponDmgLabel)
        
        let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
        extraWeaponDmgLabel.text = "Extra Damage Die"
        extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
        extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
        extraWeaponDmgLabel.tag = baseTag + 25
        scrollView.addSubview(extraWeaponDmgLabel)
        
        let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-140, y:320, width:40, height:30))
        weaponDieAmount.text = String(damage.die_number)
        weaponDieAmount.textAlignment = NSTextAlignment.center
        weaponDieAmount.layer.borderWidth = 1.0
        weaponDieAmount.layer.borderColor = UIColor.black.cgColor
        weaponDieAmount.tag = baseTag + 26
        scrollView.addSubview(weaponDieAmount)
        
        let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-100, y:320, width:20, height:30))
        weaponD.text = "d"
        weaponD.textAlignment = NSTextAlignment.center
        weaponD.tag = baseTag + 27
        scrollView.addSubview(weaponD)
        
        let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:40, height:30))
        weaponDie.text = String(damage.die_type)
        weaponDie.textAlignment = NSTextAlignment.center
        weaponDie.layer.borderWidth = 1.0
        weaponDie.layer.borderColor = UIColor.black.cgColor
        weaponDie.tag = baseTag + 28
        scrollView.addSubview(weaponDie)
        
        let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
        extraDieSwitch.isOn = damage.extra_die
        extraDieSwitch.tag = baseTag + 29
        scrollView.addSubview(extraDieSwitch)
        
        let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
        extraDieAmount.text = String(damage.extra_die_number)
        extraDieAmount.textAlignment = NSTextAlignment.center
        extraDieAmount.layer.borderWidth = 1.0
        extraDieAmount.layer.borderColor = UIColor.black.cgColor
        extraDieAmount.tag = baseTag + 30
        scrollView.addSubview(extraDieAmount)
        
        let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
        extraD.text = "d"
        extraD.textAlignment = NSTextAlignment.center
        extraD.tag = baseTag + 31
        scrollView.addSubview(extraD)
        
        let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
        extraDieField.text = String(damage.extra_die_type)
        extraDieField.textAlignment = NSTextAlignment.center
        extraDieField.layer.borderWidth = 1.0
        extraDieField.layer.borderColor = UIColor.black.cgColor
        extraDieField.tag = baseTag + 32
        scrollView.addSubview(extraDieField)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 380)
        
        view.addSubview(tempView)
    }
    
    // UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Types.DamageStrings.count
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
        
        pickerLabel?.text = Types.DamageStrings[row]
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
