//
//  EquipmentViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

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
        
                var attackBonus = 0
                var damageBonus = 0
                let abilityType: String = weapon.ability!.name!
                switch abilityType {
                case "STR":
                    attackBonus += Character.Selected.strBonus //Add STR bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.strBonus
                    }
                case "DEX":
                    attackBonus += Character.Selected.dexBonus //Add DEX bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.dexBonus
                    }
                case "CON":
                    attackBonus += Character.Selected.conBonus //Add CON bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.conBonus
                    }
                case "INT":
                    attackBonus += Character.Selected.intBonus //Add INT bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.intBonus
                    }
                case "WIS":
                    attackBonus += Character.Selected.wisBonus //Add WIS bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.wisBonus
                    }
                case "CHA":
                    attackBonus += Character.Selected.chaBonus //Add CHA bonus
                    if damage.mod_damage {
                        damageBonus += Character.Selected.chaBonus
                    }
                default: break
                }
        
                attackBonus = attackBonus + Int(weapon.magic_bonus) + Int(weapon.misc_bonus)
                damageBonus = damageBonus + Int(damage.magic_bonus) + Int(damage.misc_bonus)
        
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
        
                var toolValue = 0
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
                    
                    var attackBonus = 0
                    var damageBonus = 0
                    let abilityType: String = weaponItem.ability!.name!
                    switch abilityType {
                    case "STR":
                        attackBonus += Character.Selected.strBonus //Add STR bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.strBonus
                        }
                    case "DEX":
                        attackBonus += Character.Selected.dexBonus //Add DEX bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.dexBonus
                        }
                    case "CON":
                        attackBonus += Character.Selected.conBonus //Add CON bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.conBonus
                        }
                    case "INT":
                        attackBonus += Character.Selected.intBonus //Add INT bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.intBonus
                        }
                    case "WIS":
                        attackBonus += Character.Selected.wisBonus //Add WIS bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.wisBonus
                        }
                    case "CHA":
                        attackBonus += Character.Selected.chaBonus //Add CHA bonus
                        if damage.mod_damage {
                            damageBonus += Character.Selected.chaBonus
                        }
                    default: break
                    }
                    
                    attackBonus = attackBonus + Int(weaponItem.magic_bonus) + Int(weaponItem.misc_bonus)
                    damageBonus = damageBonus + Int(damage.magic_bonus) + Int(damage.misc_bonus)
                    
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
                    
                    var toolValue = 0
                    if toolItem.proficient {
                        toolValue += Character.Selected.proficiencyBonus
                    }
                    
                    let abilityType: String = toolItem.ability!.name!
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
