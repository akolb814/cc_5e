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

    var quantityEffectValue: Int32 = 0
    var strRequirementEffectValue: Int32 = 0
    var newItemTypeIndex = 0
    var newWeaponCustom = false
    var newWeaponSimple = true
    var newWeaponMelee = true
    var newArmorCustom = false
    var newToolCustom = false
    
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
        let parentView = segControl.superview!
        var baseTag = 0
        if parentView is UIScrollView {
            baseTag = parentView.superview!.tag
        }
        else {
            baseTag = parentView.tag
        }
        
        if segControl.tag == 0 {
            equipmentTable.reloadData()
        }
        else if segControl.tag == baseTag + 2 {
            // Get scrollview from parentView
            var scrollView: UIScrollView!
            for case let view in parentView.subviews {
                if view is UIScrollView {
                    scrollView = view as! UIScrollView
                }
            }
            
            for case let view in scrollView.subviews {
                view.removeFromSuperview()
            }
            
            // New Item Type
            if segControl.selectedSegmentIndex == 0 {
                // Weapon
                createNewWeapon(baseTag: baseTag, scrollView: scrollView)
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                createNewArmor(baseTag: baseTag, scrollView: scrollView)
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tool
                createNewTool(baseTag: baseTag, scrollView: scrollView)
            }
            else {
                // Item
                createNewItemDetails(baseTag: baseTag, scrollView: scrollView)
            }
        }
        else if segControl.tag == baseTag + 3 {
            // Armor Type
            for case let view in parentView.subviews {
                if view.tag == baseTag + 4 {
                    // Armor Picker View
                    let pickerView = view as! UIPickerView
                    pickerView.reloadAllComponents()
                }
            }
        }
        else {
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
        
        let baseTag = indexPath.row * 100
        
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
                let weapon:Weapon = Character.Selected.equipment?.weapons?.allObjects[indexPath.row] as! Weapon
                createWeaponDetailView(weapon: weapon, baseTag: baseTag)
            }
            else if segControl.selectedSegmentIndex == 1 {
                // Armor
                let armor:Armor = Character.Selected.equipment?.armor!.allObjects[indexPath.row] as! Armor
                createArmorDetailView(armor: armor, baseTag: baseTag)
            }
            else if segControl.selectedSegmentIndex == 2 {
                // Tools
                let tool:Tool = Character.Selected.equipment?.tools!.allObjects[indexPath.row] as! Tool
                createToolDetailView(tool: tool, baseTag: baseTag)
            }
            else if segControl.selectedSegmentIndex == 3 {
                // Other
                let item:Item = Character.Selected.equipment?.other!.allObjects[indexPath.row] as! Item
                createItemDetailView(item: item, baseTag: baseTag)
            }
            else {
                // All equipment
                let item = all_equipment[indexPath.row]
                
                if item is Weapon {
                    createWeaponDetailView(weapon: item as! Weapon, baseTag: baseTag)
                }
                else if item is Armor {
                    createArmorDetailView(armor: item as! Armor, baseTag: baseTag)
                }
                else if item is Tool {
                    createToolDetailView(tool: item as! Tool, baseTag: baseTag)
                }
                else if item is Item {
                    createItemDetailView(item: item as! Item, baseTag: baseTag)
                }
                else {
                    createItemDetailView(item: item as! Item, baseTag: baseTag)
                }
            }
        }
        else {
            createNewItem(baseTag: baseTag)
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
        
        if segControl.selectedSegmentIndex == 0 {
            // Weapons
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
    //                        Character.Selected.weapon_proficiencies
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
                        else if view.tag == baseTag + 34 {
                            // Quantity - TF
                            let textField = view as! UITextField
                            weapon.quantity = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 36 {
                            // Weight - TF
                            let textField = view as! UITextField
                            weapon.weight = textField.text
                        }
                        else if view.tag == baseTag + 38 {
                            // Cost - TF
                            let textField = view as! UITextField
                            weapon.cost = textField.text
                        }
                        else if view.tag == baseTag + 41 {
                            // Description - TV
                            let textView = view as! UITextView
                            weapon.info = textView.text
                        }
                    }
                }
            }
            
            weapon.damage = damage
            Character.Selected.equipment?.removeFromWeapons(Character.Selected.equipment?.weapons?.allObjects[index] as! Weapon)
            Character.Selected.equipment?.addToWeapons(weapon)
        }
        else if segControl.selectedSegmentIndex == 1 {
            // Armor
            let baseTag = parentView.tag
            let index = baseTag/100
            
            let armor = Character.Selected.equipment?.armor!.allObjects[index] as! Armor
            
            for case let view in parentView.subviews {
                if let scrollView = view as? UIScrollView {
                    for case let view in scrollView.subviews {
                        if view.tag == baseTag + 1 {
                            // Name - TF
                            let textField = view as! UITextField
                            armor.name = textField.text
                        }
                        else if view.tag == baseTag + 7 {
                            // Magic Bonus - TF
                            let textField = view as! UITextField
                            armor.magic_bonus = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 9 {
                            // Misc Bonus - TF
                            let textField = view as! UITextField
                            armor.misc_bonus = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 10 {
                            // Ability Mod - Segmented Control
                            let segControl = view as! UISegmentedControl
                            switch segControl.selectedSegmentIndex {
                            case 0:
                                // STR
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                                break
                            case 1:
                                // DEX
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                                break
                            case 2:
                                // CON
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                                break
                            case 3:
                                // INT
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                                break
                            case 4:
                                // WIS
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                                break
                            case 5:
                                // CHA
                                armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                                break
                            default:
                                break
                            }
                        }
                        else if view.tag == baseTag + 12 {
                            // Stealth Disadvantage - Switch
                            let stealthDisadvantageSwitch = view as! UISwitch
                            armor.stealth_disadvantage = stealthDisadvantageSwitch.isOn
                        }
                        else if view.tag == baseTag + 14 {
                            // Equipped - Switch
                            let equippedSwitch = view as! UISwitch
                            armor.equipped = equippedSwitch.isOn
                        }
                        else if view.tag == baseTag + 16 {
                            // Quantity - TF
                            let textField = view as! UITextField
                            armor.quantity = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 19 {
                            // Str Requirement - TF
                            let textField = view as! UITextField
                            armor.str_requirement = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 22 {
                            // Weight - TF
                            let textField = view as! UITextField
                            armor.weight = textField.text
                        }
                        else if view.tag == baseTag + 24 {
                            // Cost - TF
                            let textField = view as! UITextField
                            armor.cost = textField.text
                        }
                        else if view.tag == baseTag + 26 {
                            // Description - TV
                            let textView = view as! UITextView
                            armor.info = textView.text
                        }
                    }
                }
            }
            
            Character.Selected.equipment?.removeFromArmor(Character.Selected.equipment?.armor!.allObjects[index] as! Armor)
            Character.Selected.equipment?.addToArmor(armor)
        }
        else if segControl.selectedSegmentIndex == 2 {
            // Tool
            let baseTag = parentView.tag
            let index = baseTag/100
            
            let tool = Character.Selected.equipment?.tools!.allObjects[index] as! Tool
            
            for case let view in parentView.subviews {
                if let scrollView = view as? UIScrollView {
                    for case let view in scrollView.subviews {
                        if view.tag == baseTag + 1 {
                            // Name - TF
                            let textField = view as! UITextField
                            tool.name = textField.text
                        }
                        else if view.tag == baseTag + 3 {
                            // Proficient - Switch
                            let proficientSwitch = view as! UISwitch
                            tool.proficient = proficientSwitch.isOn
                        }
                        else if view.tag == baseTag + 7 {
                            // Ability - Segmented Control
                            let segControl = view as! UISegmentedControl
                            switch segControl.selectedSegmentIndex {
                            case 0:
                                // STR
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                                break
                            case 1:
                                // DEX
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                                break
                            case 2:
                                // CON
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                                break
                            case 3:
                                // INT
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                                break
                            case 4:
                                // WIS
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                                break
                            case 5:
                                // CHA
                                tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                                break
                            default:
                                break
                            }
                        }
                        else if view.tag == baseTag + 9 {
                            // Weight - TF
                            let textField = view as! UITextField
                            tool.weight = textField.text
                        }
                        else if view.tag == baseTag + 11 {
                            // Cost - TF
                            let textField = view as! UITextField
                            tool.cost = textField.text
                        }
                        else if view.tag == baseTag + 13 {
                            // Quantity - TF
                            let textField = view as! UITextField
                            tool.quantity = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 16 {
                            // Description - TV
                            let textView = view as! UITextView
                            tool.info = textView.text
                        }
                    }
                }
            }
            
            Character.Selected.equipment?.removeFromTools(Character.Selected.equipment?.tools!.allObjects[index] as! Tool)
            Character.Selected.equipment?.addToTools(tool)
        }
        else if segControl.selectedSegmentIndex == 3 {
            // Item
            let baseTag = parentView.tag
            let index = baseTag/100
            
            let item = Character.Selected.equipment?.other!.allObjects[index] as! Item
            
            for case let view in parentView.subviews {
                if let scrollView = view as? UIScrollView {
                    for case let view in scrollView.subviews {
                        if view.tag == baseTag + 1 {
                            // Name - TF
                            let textField = view as! UITextField
                            item.name = textField.text
                        }
                        else if view.tag == baseTag + 3 {
                            // Weight - TF
                            let textField = view as! UITextField
                            item.weight = textField.text
                        }
                        else if view.tag == baseTag + 5 {
                            // Cost - TF
                            let textField = view as! UITextField
                            item.cost = textField.text
                        }
                        else if view.tag == baseTag + 7 {
                            // Quantity - TF
                            let textField = view as! UITextField
                            item.quantity = Int32(textField.text!)!
                        }
                        else if view.tag == baseTag + 10 {
                            // Description - TV
                            let textView = view as! UITextView
                            item.info = textView.text
                        }
                    }
                }
            }
            
            Character.Selected.equipment?.removeFromOther(Character.Selected.equipment?.other!.allObjects[index] as! Item)
            Character.Selected.equipment?.addToOther(item)
        }
        else if segControl.selectedSegmentIndex == 4 {
            // All
            let baseTag = parentView.tag
            let index = baseTag/100
            
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
            
            let item = all_equipment[index]
            
            if item is Weapon {
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
                                //                        Character.Selected.weapon_proficiencies
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
                            else if view.tag == baseTag + 34 {
                                // Quantity - TF
                                let textField = view as! UITextField
                                weapon.quantity = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 36 {
                                // Weight - TF
                                let textField = view as! UITextField
                                weapon.weight = textField.text
                            }
                            else if view.tag == baseTag + 38 {
                                // Cost - TF
                                let textField = view as! UITextField
                                weapon.cost = textField.text
                            }
                            else if view.tag == baseTag + 41 {
                                // Description - TV
                                let textView = view as! UITextView
                                weapon.info = textView.text
                            }
                        }
                    }
                }
                
                weapon.damage = damage
                Character.Selected.equipment?.removeFromWeapons(Character.Selected.equipment?.weapons?.allObjects[index] as! Weapon)
                Character.Selected.equipment?.addToWeapons(weapon)
            }
            else if item is Armor {
                let armor = Character.Selected.equipment?.armor!.allObjects[index] as! Armor
                
                for case let view in parentView.subviews {
                    if let scrollView = view as? UIScrollView {
                        for case let view in scrollView.subviews {
                            if view.tag == baseTag + 1 {
                                // Name - TF
                                let textField = view as! UITextField
                                armor.name = textField.text
                            }
                            else if view.tag == baseTag + 7 {
                                // Magic Bonus - TF
                                let textField = view as! UITextField
                                armor.magic_bonus = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 9 {
                                // Misc Bonus - TF
                                let textField = view as! UITextField
                                armor.misc_bonus = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 10 {
                                // Ability Mod - Segmented Control
                                let segControl = view as! UISegmentedControl
                                switch segControl.selectedSegmentIndex {
                                case 0:
                                    // STR
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                                    break
                                case 1:
                                    // DEX
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                                    break
                                case 2:
                                    // CON
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                                    break
                                case 3:
                                    // INT
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                                    break
                                case 4:
                                    // WIS
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                                    break
                                case 5:
                                    // CHA
                                    armor.ability_mod = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                                    break
                                default:
                                    break
                                }
                            }
                            else if view.tag == baseTag + 12 {
                                // Stealth Disadvantage - Switch
                                let stealthDisadvantageSwitch = view as! UISwitch
                                armor.stealth_disadvantage = stealthDisadvantageSwitch.isOn
                            }
                            else if view.tag == baseTag + 14 {
                                // Equipped - Switch
                                let equippedSwitch = view as! UISwitch
                                armor.equipped = equippedSwitch.isOn
                            }
                            else if view.tag == baseTag + 16 {
                                // Quantity - TF
                                let textField = view as! UITextField
                                armor.quantity = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 19 {
                                // Str Requirement - TF
                                let textField = view as! UITextField
                                armor.str_requirement = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 22 {
                                // Weight - TF
                                let textField = view as! UITextField
                                armor.weight = textField.text
                            }
                            else if view.tag == baseTag + 24 {
                                // Cost - TF
                                let textField = view as! UITextField
                                armor.cost = textField.text
                            }
                            else if view.tag == baseTag + 26 {
                                // Description - TV
                                let textView = view as! UITextView
                                armor.info = textView.text
                            }
                        }
                    }
                }
                
                Character.Selected.equipment?.removeFromArmor(Character.Selected.equipment?.armor!.allObjects[index] as! Armor)
                Character.Selected.equipment?.addToArmor(armor)
            }
            else if item is Tool {
                let tool = Character.Selected.equipment?.tools!.allObjects[index] as! Tool
                
                for case let view in parentView.subviews {
                    if let scrollView = view as? UIScrollView {
                        for case let view in scrollView.subviews {
                            if view.tag == baseTag + 1 {
                                // Name - TF
                                let textField = view as! UITextField
                                tool.name = textField.text
                            }
                            else if view.tag == baseTag + 3 {
                                // Proficient - Switch
                                let proficientSwitch = view as! UISwitch
                                tool.proficient = proficientSwitch.isOn
                            }
                            else if view.tag == baseTag + 7 {
                                // Ability - Segmented Control
                                let segControl = view as! UISegmentedControl
                                switch segControl.selectedSegmentIndex {
                                case 0:
                                    // STR
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                                    break
                                case 1:
                                    // DEX
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                                    break
                                case 2:
                                    // CON
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                                    break
                                case 3:
                                    // INT
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                                    break
                                case 4:
                                    // WIS
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                                    break
                                case 5:
                                    // CHA
                                    tool.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                                    break
                                default:
                                    break
                                }
                            }
                            else if view.tag == baseTag + 9 {
                                // Weight - TF
                                let textField = view as! UITextField
                                tool.weight = textField.text
                            }
                            else if view.tag == baseTag + 11 {
                                // Cost - TF
                                let textField = view as! UITextField
                                tool.cost = textField.text
                            }
                            else if view.tag == baseTag + 13 {
                                // Quantity - TF
                                let textField = view as! UITextField
                                tool.quantity = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 16 {
                                // Description - TV
                                let textView = view as! UITextView
                                tool.info = textView.text
                            }
                        }
                    }
                }
                
                Character.Selected.equipment?.removeFromTools(Character.Selected.equipment?.tools!.allObjects[index] as! Tool)
                Character.Selected.equipment?.addToTools(tool)
            }
            else if item is Item {
                let item = Character.Selected.equipment?.other!.allObjects[index] as! Item
                
                for case let view in parentView.subviews {
                    if let scrollView = view as? UIScrollView {
                        for case let view in scrollView.subviews {
                            if view.tag == baseTag + 1 {
                                // Name - TF
                                let textField = view as! UITextField
                                item.name = textField.text
                            }
                            else if view.tag == baseTag + 3 {
                                // Weight - TF
                                let textField = view as! UITextField
                                item.weight = textField.text
                            }
                            else if view.tag == baseTag + 5 {
                                // Cost - TF
                                let textField = view as! UITextField
                                item.cost = textField.text
                            }
                            else if view.tag == baseTag + 7 {
                                // Quantity - TF
                                let textField = view as! UITextField
                                item.quantity = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 10 {
                                // Description - TV
                                let textView = view as! UITextView
                                item.info = textView.text
                            }
                        }
                    }
                }
                
                Character.Selected.equipment?.removeFromOther(Character.Selected.equipment?.other!.allObjects[index] as! Item)
                Character.Selected.equipment?.addToOther(item)
            }
            else {
                let item = Character.Selected.equipment?.other!.allObjects[index] as! Item
                
                for case let view in parentView.subviews {
                    if let scrollView = view as? UIScrollView {
                        for case let view in scrollView.subviews {
                            if view.tag == baseTag + 1 {
                                // Name - TF
                                let textField = view as! UITextField
                                item.name = textField.text
                            }
                            else if view.tag == baseTag + 3 {
                                // Weight - TF
                                let textField = view as! UITextField
                                item.weight = textField.text
                            }
                            else if view.tag == baseTag + 5 {
                                // Cost - TF
                                let textField = view as! UITextField
                                item.cost = textField.text
                            }
                            else if view.tag == baseTag + 7 {
                                // Quantity - TF
                                let textField = view as! UITextField
                                item.quantity = Int32(textField.text!)!
                            }
                            else if view.tag == baseTag + 10 {
                                // Description - TV
                                let textView = view as! UITextView
                                item.info = textView.text
                            }
                        }
                    }
                }
                
                Character.Selected.equipment?.removeFromOther(Character.Selected.equipment?.other!.allObjects[index] as! Item)
                Character.Selected.equipment?.addToOther(item)
            }
        }
        
        equipmentTable.reloadData()
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func createWeaponDetailView(weapon: Weapon, baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
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
        let row = Types.DamageStrings.index(of: damage.damage_type!.capitalized)
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
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 380, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 33
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 410, width: 40, height: 30))
        quantityField.text = String(weapon.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 34
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: tempView.frame.size.width/2+75, y: 410, width: 94, height: 29))
        quantityStepper.value = Double(weapon.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 35
        scrollView.addSubview(quantityStepper)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 450, width: tempView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 36
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 480, width: tempView.frame.size.width - 20, height: 30))
        weightField.text = weapon.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 37
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 520, width: tempView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 38
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 550, width: tempView.frame.size.width - 20, height: 30))
        costField.text = weapon.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 39
        scrollView.addSubview(costField)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 590, width: tempView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 40
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 520, width: tempView.frame.size.width - 20, height: 100))
        infoView.text = weapon.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 41
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 520 + infoView.frame.size.height + 10)
        
        view.addSubview(tempView)
    }
    
    func createArmorDetailView(armor: Armor, baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        let abilityType: String = (armor.ability_mod?.name)!
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
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = armor.name?.capitalized
        title.textAlignment = NSTextAlignment.center
        title.tag = baseTag + 1
        title.layer.borderWidth = 1.0
        title.layer.borderColor = UIColor.black.cgColor
        scrollView.addSubview(title)
        
        let baseValueLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 45, width: 90, height: 30))
        baseValueLabel.text = "Base\nValue"
        baseValueLabel.font = UIFont.systemFont(ofSize: 10)
        baseValueLabel.textAlignment = NSTextAlignment.center
        baseValueLabel.numberOfLines = 2
        baseValueLabel.tag = baseTag + 2
        scrollView.addSubview(baseValueLabel)
        
        let baseValueField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y: 80, width:40, height:30))
        baseValueField.text = String(armor.value)
        baseValueField.textAlignment = NSTextAlignment.center
        baseValueField.isEnabled = false
        baseValueField.textColor = UIColor.darkGray
        baseValueField.layer.borderWidth = 1.0
        baseValueField.layer.borderColor = UIColor.darkGray.cgColor
        baseValueField.tag = baseTag + 3
        scrollView.addSubview(baseValueField)
        
        let abilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 45, width: 90, height: 30))
        abilityLabel.text = abilityName+"\nBonus"
        abilityLabel.font = UIFont.systemFont(ofSize: 10)
        abilityLabel.textAlignment = NSTextAlignment.center
        abilityLabel.numberOfLines = 2
        abilityLabel.tag = baseTag + 4
        scrollView.addSubview(abilityLabel)
        
        let abilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y: 80, width:40, height:30))
        abilityField.text = String(abilityMod)
        abilityField.textAlignment = NSTextAlignment.center
        abilityField.isEnabled = false
        abilityField.textColor = UIColor.darkGray
        abilityField.layer.borderWidth = 1.0
        abilityField.layer.borderColor = UIColor.black.cgColor
        abilityField.tag = baseTag + 5
        scrollView.addSubview(abilityField)
        
        let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 45, width: 90, height: 30))
        magicLabel.text = "Magic Item\nBonus"
        magicLabel.font = UIFont.systemFont(ofSize: 10)
        magicLabel.textAlignment = NSTextAlignment.center
        magicLabel.numberOfLines = 2
        magicLabel.tag = baseTag + 6
        scrollView.addSubview(magicLabel)
        
        let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y: 80, width:40, height:30))
        magicField.text = String(armor.magic_bonus)
        magicField.textAlignment = NSTextAlignment.center
        magicField.layer.borderWidth = 1.0
        magicField.layer.borderColor = UIColor.black.cgColor
        magicField.tag = baseTag + 7
        scrollView.addSubview(magicField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 45, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = baseTag + 8
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y: 80, width:40, height:30))
        miscField.text = String(armor.misc_bonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = baseTag + 9
        scrollView.addSubview(miscField)
        
        let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:120, width:tempView.frame.size.width-20, height:30))
        aa.insertSegment(withTitle:"STR", at:0, animated:false)
        aa.insertSegment(withTitle:"DEX", at:1, animated:false)
        aa.insertSegment(withTitle:"CON", at:2, animated:false)
        aa.insertSegment(withTitle:"INT", at:3, animated:false)
        aa.insertSegment(withTitle:"WIS", at:4, animated:false)
        aa.insertSegment(withTitle:"CHA", at:5, animated:false)
        aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        aa.selectedSegmentIndex = aaIndex
        aa.tag = baseTag + 10
        scrollView.addSubview(aa)
        
        let stealthDisadvantageLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 160, width: 90, height: 30))
        stealthDisadvantageLabel.text = "Stealth\nDisadvantage"
        stealthDisadvantageLabel.font = UIFont.systemFont(ofSize: 10)
        stealthDisadvantageLabel.textAlignment = NSTextAlignment.center
        stealthDisadvantageLabel.numberOfLines = 2
        stealthDisadvantageLabel.tag = baseTag + 11
        scrollView.addSubview(stealthDisadvantageLabel)
        
        let stealthDisadvantageSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 200, width:51, height:31))
        stealthDisadvantageSwitch.isOn = armor.stealth_disadvantage
        stealthDisadvantageSwitch.tag = baseTag + 12
        scrollView.addSubview(stealthDisadvantageSwitch)
        
        let equippedLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 160, width: 90, height: 30))
        equippedLabel.text = "Equipped"
        equippedLabel.font = UIFont.systemFont(ofSize: 10)
        equippedLabel.textAlignment = NSTextAlignment.center
        equippedLabel.numberOfLines = 1
        equippedLabel.tag = baseTag + 13
        scrollView.addSubview(equippedLabel)
        
        let equippedSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 200, width:51, height:31))
        equippedSwitch.isOn = armor.equipped
        equippedSwitch.tag = baseTag + 14
        scrollView.addSubview(equippedSwitch)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 160, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 15
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 200, width: 40, height: 30))
        quantityField.text = String(armor.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 16
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: tempView.frame.size.width/2+75, y: 200, width: 94, height: 29))
        quantityStepper.value = Double(armor.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 17
        scrollView.addSubview(quantityStepper)
        
        let strRequirementLabel = UILabel.init(frame: CGRect.init(x: 10, y: 240, width: 180, height: 30))
        strRequirementLabel.text = "Strength Requirement"
        strRequirementLabel.textAlignment = NSTextAlignment.center
        strRequirementLabel.tag = baseTag + 18
        scrollView.addSubview(strRequirementLabel)
        
        let strRequirementField = UITextField.init(frame: CGRect.init(x: 10, y: 270, width: tempView.frame.size.width - 124, height: 30))
        strRequirementField.text = String(armor.str_requirement)
        strRequirementField.textAlignment = NSTextAlignment.center
        strRequirementField.layer.borderWidth = 1.0
        strRequirementField.layer.borderColor = UIColor.black.cgColor
        strRequirementField.tag = baseTag + 19
        scrollView.addSubview(strRequirementField)
        
        let strRequirementStepper = UIStepper.init(frame: CGRect.init(x: strRequirementField.frame.size.width + 15, y: 270, width: 94, height: 29))
        strRequirementStepper.value = Double(armor.str_requirement)
        strRequirementStepper.minimumValue = 0
        strRequirementStepper.maximumValue = 9999
        strRequirementStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        strRequirementStepper.tag = baseTag + 20
        scrollView.addSubview(strRequirementStepper)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 310, width: tempView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 21
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 340, width: tempView.frame.size.width - 20, height: 30))
        weightField.text = armor.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 22
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 380, width: tempView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 23
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 410, width: tempView.frame.size.width - 20, height: 30))
        costField.text = armor.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 24
        scrollView.addSubview(costField)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 450, width: tempView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 25
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 480, width: tempView.frame.size.width - 20, height: 100))
        infoView.text = armor.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 26
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 480 + infoView.frame.size.height + 10)
        
        view.addSubview(tempView)
    }
    
    func createToolDetailView(tool: Tool, baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        let abilityType: String = (tool.ability?.name)!
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
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = tool.name?.capitalized
        title.textAlignment = NSTextAlignment.center
        title.tag = baseTag + 1
        title.layer.borderWidth = 1.0
        title.layer.borderColor = UIColor.black.cgColor
        scrollView.addSubview(title)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: tempView.frame.size.width/2 - 20, height: 30))
        proficientLabel.text = "Proficient"
        proficientLabel.textAlignment = NSTextAlignment.center
        proficientLabel.numberOfLines = 2
        proficientLabel.tag = baseTag + 2
        scrollView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2 - 51 - 110, y: 80, width: 51, height: 31))
        proficientSwitch.isOn = tool.proficient
        proficientSwitch.tag = baseTag + 3
        scrollView.addSubview(proficientSwitch)
        
        let proficientField = UITextField.init(frame: CGRect.init(x: tempView.frame.size.width/2 - 40 - 40, y: 80, width: 40, height: 30))
        proficientField.text = String(Character.Selected.proficiencyBonus)
        proficientField.textAlignment = NSTextAlignment.center
        proficientField.isEnabled = false
        proficientField.textColor = UIColor.darkGray
        proficientField.layer.borderWidth = 1.0
        proficientField.layer.borderColor = UIColor.darkGray.cgColor
        proficientField.tag = baseTag + 4
        scrollView.addSubview(proficientField)
        
        let abilityModLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2 + 10, y: 45, width: tempView.frame.size.width/2 - 20, height: 30))
        abilityModLabel.text = abilityName + " Mod"
        abilityModLabel.textAlignment = NSTextAlignment.center
        abilityModLabel.numberOfLines = 2
        abilityModLabel.tag = baseTag + 5
        scrollView.addSubview(abilityModLabel)
        
        let abilityModField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2 + 70, y: 80, width:40, height:30))
        abilityModField.text = String(abilityMod)
        abilityModField.textAlignment = NSTextAlignment.center
        abilityModField.isEnabled = false
        abilityModField.textColor = UIColor.darkGray
        abilityModField.layer.borderWidth = 1.0
        abilityModField.layer.borderColor = UIColor.black.cgColor
        abilityModField.tag = baseTag + 6
        scrollView.addSubview(abilityModField)
        
        let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:120, width:tempView.frame.size.width-20, height:30))
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
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 160, width: tempView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 8
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 190, width: tempView.frame.size.width - 20, height: 30))
        weightField.text = tool.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 9
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 230, width: tempView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 10
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 260, width: tempView.frame.size.width - 20, height: 30))
        costField.text = tool.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 11
        scrollView.addSubview(costField)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 300, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 12
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 330, width: 40, height: 30))
        quantityField.text = String(tool.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 13
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: tempView.frame.size.width/2+75, y: 330, width: 94, height: 29))
        quantityStepper.value = Double(tool.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 14
        scrollView.addSubview(quantityStepper)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 370, width: tempView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 15
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 400, width: tempView.frame.size.width - 20, height: 100))
        infoView.text = tool.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 16
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 400 + infoView.frame.size.height + 10)
        
        view.addSubview(tempView)
    }
    
    func createItemDetailView(item: Item, baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = item.name?.capitalized
        title.textAlignment = NSTextAlignment.center
        title.tag = baseTag + 1
        title.layer.borderWidth = 1.0
        title.layer.borderColor = UIColor.black.cgColor
        scrollView.addSubview(title)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 45, width: tempView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 2
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 80, width: tempView.frame.size.width - 20, height: 30))
        weightField.text = item.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 3
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 120, width: tempView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 4
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 150, width: tempView.frame.size.width - 20, height: 30))
        costField.text = item.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 5
        scrollView.addSubview(costField)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 190, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 6
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: tempView.frame.size.width/2+25, y: 220, width: 40, height: 30))
        quantityField.text = String(item.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 7
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: tempView.frame.size.width/2+75, y: 220, width: 94, height: 29))
        quantityStepper.value = Double(item.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 8
        scrollView.addSubview(quantityStepper)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 260, width: tempView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 9
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 290, width: tempView.frame.size.width - 20, height: 100))
        infoView.text = item.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 10
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 290 + infoView.frame.size.height + 10)
        
        view.addSubview(tempView)
    }
    
    func stepperChanged(stepper: UIStepper) {
        let baseTag = (stepper.superview?.tag)! / 100
        if stepper.tag == baseTag + 17 {
            // Quantity
            quantityEffectValue = Int32(stepper.value)
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == baseTag + 16 {
                    let textField = view as! UITextField
                    textField.text = String(quantityEffectValue)
                }
            }
        }
        else if stepper.tag == baseTag + 20 {
            // Strength Requirement
            strRequirementEffectValue = Int32(stepper.value)
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == baseTag + 18 {
                    let textField = view as! UITextField
                    textField.text = String(strRequirementEffectValue)
                }
            }
        }
    }
    
    // UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.superview != nil {
            let parentView = pickerView.superview
            let baseTag = parentView?.tag
            if pickerView.tag == (baseTag)! + 9 {
                // Weapon Selection
                if newWeaponSimple == true {
                    if newWeaponMelee == true {
                        return Types.SimpleMeleeWeaponStrings.count
                    }
                    else {
                        return Types.SimpleRangedWeaponStrings.count
                    }
                }
                else {
                    if newWeaponMelee == true {
                        return Types.MartialMeleeWeaponStrings.count
                    }
                    else {
                        return Types.MartialRangedWeaponStrings.count
                    }
                }
            }
            else if pickerView.tag == (baseTag)! + 4 {
                for case let view in (parentView?.subviews)! {
                    if view.tag == baseTag! + 3 {
                        // Armor Type - Segmented Control
                        let armorTypeSegControl = view as! UISegmentedControl
                        if armorTypeSegControl.selectedSegmentIndex == 0 {
                            // Light
                            return Types.LightArmorStrings.count
                        }
                        else if armorTypeSegControl.selectedSegmentIndex == 1 {
                            // Medium
                            return Types.MediumArmorStrings.count
                        }
                        else {
                            // Heavy
                            return Types.HeavyArmorStrings.count
                        }
                    }
                }
                return Types.LightArmorStrings.count
            }
            else if pickerView.tag == (baseTag)! + 3 {
                // Tools
                return Types.ToolStrings.count
            }
            else {
                // Damage Types
                return Types.DamageStrings.count
            }
        }
        else {
            // Damage Types
            return Types.DamageStrings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.superview != nil {
            let parentView = pickerView.superview
            let baseTag = parentView?.tag
            if pickerView.tag == baseTag! + 9 {
                // Weapon Selection
                if newWeaponSimple == true {
                    if newWeaponMelee == true {
    //                    appDelegate.character. = Types.SimpleMeleeWeapons[row]
                    }
                    else {
    //                    appDelegate.character. = Types.SimpleRangedWeapons[row]
                    }
                }
                else {
                    if newWeaponMelee == true {
    //                    appDelegate.character. = Types.MartialMeleeWeapons[row]
                    }
                    else {
    //                    appDelegate.character. = Types.MartialRangedWeapons[row]
                    }
                }
            }
            else if pickerView.tag == baseTag! + 4 {
                for case let view in (parentView?.subviews)! {
                    if view.tag == baseTag! + 3 {
                        // Armor Type - Segmented Control
                        let armorTypeSegControl = view as! UISegmentedControl
                        if armorTypeSegControl.selectedSegmentIndex == 0 {
                            // Light
                            
                        }
                        else if armorTypeSegControl.selectedSegmentIndex == 1 {
                            // Medium
                            
                        }
                        else {
                            // Heavy
                            
                        }
                    }
                }
                // If not found use light armor here
            }
            else if pickerView.tag == (baseTag)! + 3 {
                // Tools
                
            }
            else {
                // Damage Types
    //            appDelegate.character. = Types.DamageStrings[row]
            }
        }
        else {
            // Damage Types
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 17)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        if pickerView.superview != nil {
            let parentView = pickerView.superview
            let baseTag = parentView?.tag
            
            if newWeaponCustom == true || newArmorCustom == true || newToolCustom == true {
                pickerLabel?.textColor = UIColor.darkGray
            }
            else {
                pickerLabel?.textColor = UIColor.black
            }
            
            if pickerView.tag == baseTag! + 9 {
                // Weapon Selection
                if newWeaponSimple == true {
                    if newWeaponMelee == true {
                        pickerLabel?.text = Types.SimpleMeleeWeaponStrings[row]
                    }
                    else {
                        pickerLabel?.text = Types.SimpleRangedWeaponStrings[row]
                    }
                }
                else {
                    if newWeaponMelee == true {
                        pickerLabel?.text = Types.MartialMeleeWeaponStrings[row]
                    }
                    else {
                        pickerLabel?.text = Types.MartialRangedWeaponStrings[row]
                    }
                }
            }
            else if pickerView.tag == (baseTag)! + 4 {
                for case let view in (parentView?.subviews)! {
                    if view.tag == baseTag! + 3 {
                        // Armor Type - Segmented Control
                        let armorTypeSegControl = view as! UISegmentedControl
                        if armorTypeSegControl.selectedSegmentIndex == 0 {
                            // Light
                            pickerLabel?.text = Types.LightArmorStrings[row]
                        }
                        else if armorTypeSegControl.selectedSegmentIndex == 1 {
                            // Medium
                            pickerLabel?.text = Types.MediumArmorStrings[row]
                        }
                        else {
                            // Heavy
                            pickerLabel?.text = Types.HeavyArmorStrings[row]
                        }
                    }
                }
                if pickerLabel?.text == "" {
                    pickerLabel?.text = Types.LightArmorStrings[row]
                }
            }
            else if pickerView.tag == baseTag! + 3 {
                // Tools
                pickerLabel?.text = Types.ToolStrings[row]
            }
            else {
                // Damage Types
                pickerLabel?.text = Types.DamageStrings[row]
            }
        }
        else {
            // Damage Types
            pickerLabel?.text = Types.DamageStrings[row]
        }
        
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
    
    // Create new Item
    func createNewItem(baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        let title: String = segControl.titleForSegment(at: segControl.selectedSegmentIndex)!
        
        let newLabel = UILabel(frame: CGRect.init(x: 10, y: 5, width: tempView.frame.size.width - 20, height: 30))
        newLabel.text = "New " + title
        newLabel.textAlignment = NSTextAlignment.center
        newLabel.tag = baseTag + 1
        newLabel.font = UIFont.systemFont(ofSize: 14)
        tempView.addSubview(newLabel)
        
        let typeSelector = UISegmentedControl.init(frame: CGRect.init(x:10, y:40, width:tempView.frame.size.width-20, height:30))
        typeSelector.insertSegment(withTitle:"Weapon", at:0, animated:false)
        typeSelector.insertSegment(withTitle:"Armor", at:1, animated:false)
        typeSelector.insertSegment(withTitle:"Tool", at:2, animated:false)
        typeSelector.insertSegment(withTitle:"Other", at:3, animated:false)
        typeSelector.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        if segControl.selectedSegmentIndex >= typeSelector.numberOfSegments {
            typeSelector.selectedSegmentIndex = segControl.selectedSegmentIndex - 1
        }
        else {
            typeSelector.selectedSegmentIndex = segControl.selectedSegmentIndex
        }
        typeSelector.tag = baseTag + 2
        tempView.addSubview(typeSelector)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 80, width: tempView.frame.size.width, height: tempView.frame.size.height-80-50))
        tempView.addSubview(scrollView)
        
        if typeSelector.selectedSegmentIndex == 0 {
            createNewWeapon(baseTag: baseTag, scrollView: scrollView)
        }
        else if typeSelector.selectedSegmentIndex == 1 {
            createNewArmor(baseTag: baseTag, scrollView: scrollView)
        }
        else if typeSelector.selectedSegmentIndex == 2 {
            createNewTool(baseTag: baseTag, scrollView: scrollView)
        }
        else {
            createNewItemDetails(baseTag: baseTag, scrollView: scrollView)
        }
        
        view.addSubview(tempView)
    }
    
    func createNewWeapon(baseTag: Int, scrollView: UIScrollView) {
        let customLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 70, height: 30))
        customLabel.text = "Custom"
        customLabel.textAlignment = .right
        customLabel.tag = baseTag + 1
        scrollView.addSubview(customLabel)
        
        let customSwitch = UISwitch(frame: CGRect(x: 85, y: 5, width: 51, height: 31))
        customSwitch.isOn = newWeaponCustom
        customSwitch.tag = baseTag + 2
        scrollView.addSubview(customSwitch)
        
        let simpleLabel = UILabel(frame: CGRect(x: 10, y: 40, width: 55, height: 30))
        simpleLabel.text = "Simple"
        simpleLabel.textAlignment = .right
        simpleLabel.tag = baseTag + 3
        scrollView.addSubview(simpleLabel)
        
        let simpleSwitch = UISwitch(frame: CGRect(x: 70, y: 40, width: 51, height: 31))
        simpleSwitch.isOn = newWeaponSimple
        simpleSwitch.tag = baseTag + 4
        scrollView.addSubview(simpleSwitch)
        
        let martialLabel = UILabel(frame: CGRect(x: 125, y: 40, width: 60, height: 30))
        martialLabel.text = "Martial"
        martialLabel.tag = baseTag + 5
        scrollView.addSubview(martialLabel)
        
        let meleeLabel = UILabel(frame: CGRect(x: 190, y: 40, width: 50, height: 30))
        meleeLabel.text = "Melee"
        meleeLabel.textAlignment = .right
        meleeLabel.tag = baseTag + 6
        scrollView.addSubview(meleeLabel)
        
        let meleeSwitch = UISwitch(frame: CGRect(x: 245, y: 40, width: 51, height: 31))
        meleeSwitch.isOn = newWeaponMelee
        meleeSwitch.tag = baseTag + 7
        scrollView.addSubview(meleeSwitch)
        
        let rangedLabel = UILabel(frame: CGRect(x: 300, y: 40, width: 70, height: 30))
        rangedLabel.text = "Ranged"
        rangedLabel.tag = baseTag + 8
        scrollView.addSubview(rangedLabel)
        
        let weaponPickerView = UIPickerView.init(frame: CGRect.init(x: 10, y: 75, width: scrollView.frame.size.width-20, height: 60))
        weaponPickerView.dataSource = self
        weaponPickerView.delegate = self
        weaponPickerView.layer.borderWidth = 1.0
        weaponPickerView.layer.borderColor = UIColor.black.cgColor
        weaponPickerView.tag = baseTag + 9
//        weaponPickerView.selectRow(0, inComponent: 0, animated: false)
        scrollView.addSubview(weaponPickerView)
        
        // TODO: Get Weapon/Damage based on selected picker view item
//        let weapon = as Weapon
//        let damage = weapon.damage! as Damage
        
        var attackBonus: Int32 = 0
        var damageBonus: Int32 = 0
        let modDamage = true//damage.mod_damage
        let abilityType: String = "STR"//(weapon.ability?.name)!
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
        
//        attackBonus = attackBonus + weapon.magic_bonus + weapon.misc_bonus
//        damageBonus = damageBonus + damage.magic_bonus + damage.misc_bonus
//        
//        var damageDieNumber = damage.die_number
//        var damageDie = damage.die_type
//        let extraDie = damage.extra_die
//        if (extraDie) {
//            damageDieNumber = damageDieNumber + damage.extra_die_number
//            damageDie = damageDie + damage.extra_die_type
//        }
        
        let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 145, width: scrollView.frame.size.width/2-15, height: 30))
        reachLabel.text = "Range"
        reachLabel.textAlignment = NSTextAlignment.center
        reachLabel.tag = baseTag + 10
        scrollView.addSubview(reachLabel)
        
        let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 175, width: scrollView.frame.size.width/2-15, height: 40))
        reachField.text = ""
        reachField.textAlignment = NSTextAlignment.center
        reachField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            reachField.isEnabled = false
            reachField.textColor = UIColor.darkGray
            reachField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            reachField.isEnabled = true
            reachField.textColor = UIColor.black
            reachField.layer.borderColor = UIColor.black.cgColor
        }
        reachField.tag = baseTag + 11
        scrollView.addSubview(reachField)
        
        let damageTypeLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+5, y: 145, width: scrollView.frame.size.width/2-15, height: 30))
        damageTypeLabel.text = "Damage Type"
        damageTypeLabel.textAlignment = NSTextAlignment.center
        damageTypeLabel.tag = baseTag + 12
        scrollView.addSubview(damageTypeLabel)
        
        let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: scrollView.frame.size.width/2+5, y: 175, width: scrollView.frame.size.width/2-15, height: 40))
        damageTypePickerView.dataSource = self
        damageTypePickerView.delegate = self
        damageTypePickerView.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            damageTypePickerView.isUserInteractionEnabled = false
            damageTypePickerView.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            damageTypePickerView.isUserInteractionEnabled = true
            damageTypePickerView.layer.borderColor = UIColor.black.cgColor
        }
        damageTypePickerView.layer.borderColor = UIColor.black.cgColor
        damageTypePickerView.tag = baseTag + 13
//        let row = Types.DamageStrings.index(of: damage.damage_type!.capitalized)
//        damageTypePickerView.selectRow(row!, inComponent: 0, animated: false)
        scrollView.addSubview(damageTypePickerView)
        
        let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 210, width: scrollView.frame.size.width-20, height: 30))
        attackLabel.text = "Attack Ability"
        attackLabel.textAlignment = NSTextAlignment.center
        attackLabel.tag = baseTag + 14
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
        
        let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:250, width:scrollView.frame.size.width-20, height:30))
        aa.insertSegment(withTitle:"STR", at:0, animated:false)
        aa.insertSegment(withTitle:"DEX", at:1, animated:false)
        aa.insertSegment(withTitle:"CON", at:2, animated:false)
        aa.insertSegment(withTitle:"INT", at:3, animated:false)
        aa.insertSegment(withTitle:"WIS", at:4, animated:false)
        aa.insertSegment(withTitle:"CHA", at:5, animated:false)
        aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        aa.selectedSegmentIndex = aaIndex
        aa.tag = baseTag + 15
        if newWeaponCustom == false {
            aa.isUserInteractionEnabled = false
        }
        else {
            aa.isUserInteractionEnabled = true
        }
        scrollView.addSubview(aa)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-135, y: 290, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = baseTag + 16
        scrollView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-110, y:320, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = baseTag + 17
        scrollView.addSubview(profField)
        
        let abilityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-75, y: 290, width: 90, height: 30))
        abilityLabel.text = abilityName+"\nBonus"
        abilityLabel.font = UIFont.systemFont(ofSize: 10)
        abilityLabel.textAlignment = NSTextAlignment.center
        abilityLabel.numberOfLines = 2
        abilityLabel.tag = baseTag + 18
        scrollView.addSubview(abilityLabel)
        
        let abilityField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-50, y:320, width:40, height:30))
        abilityField.text = String(abilityMod)
        abilityField.textAlignment = NSTextAlignment.center
        abilityField.isEnabled = false
        abilityField.textColor = UIColor.darkGray
        abilityField.layer.borderWidth = 1.0
        abilityField.layer.borderColor = UIColor.black.cgColor
        abilityField.tag = baseTag + 19
        scrollView.addSubview(abilityField)
        
        let magicLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-10, y: 290, width: 90, height: 30))
        magicLabel.text = "Magic Item\nAttack Bonus"
        magicLabel.font = UIFont.systemFont(ofSize: 10)
        magicLabel.textAlignment = NSTextAlignment.center
        magicLabel.numberOfLines = 2
        magicLabel.tag = baseTag + 20
        scrollView.addSubview(magicLabel)
        
        let magicField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+15, y:320, width:40, height:30))
        magicField.text = ""//String(weapon.magic_bonus)
        magicField.textAlignment = NSTextAlignment.center
        magicField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            magicField.isEnabled = false
            magicField.textColor = UIColor.darkGray
            magicField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            magicField.isEnabled = true
            magicField.textColor = UIColor.black
            magicField.layer.borderColor = UIColor.black.cgColor
        }
        magicField.tag = baseTag + 21
        scrollView.addSubview(magicField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+55, y: 290, width: 90, height: 30))
        miscLabel.text = "Misc\nAttack Bonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = baseTag + 22
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+80, y:320, width:40, height:30))
        miscField.text = ""//String(weapon.misc_bonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            miscField.isEnabled = false
            miscField.textColor = UIColor.darkGray
            miscField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            miscField.isEnabled = true
            miscField.textColor = UIColor.black
            miscField.layer.borderColor = UIColor.black.cgColor
        }
        miscField.tag = baseTag + 23
        scrollView.addSubview(miscField)
        
        let profWithLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-135, y: 360, width: 90, height: 40))
        profWithLabel.text = "Proficient\nWith\nWeapon"
        profWithLabel.font = UIFont.systemFont(ofSize: 10)
        profWithLabel.textAlignment = NSTextAlignment.center
        profWithLabel.numberOfLines = 3
        profWithLabel.tag = baseTag + 24
        scrollView.addSubview(profWithLabel)
        
        let profWithSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2-115, y: 400, width:51, height:31))
//        if (Character.Selected.weapon_proficiencies?.lowercased().contains(weapon.category!))! {
//            profWithSwitch.isOn = true
//        }
//        else {
            profWithSwitch.isOn = false
//        }
        if newWeaponCustom == false {
            profWithSwitch.isUserInteractionEnabled = false
        }
        else {
            profWithSwitch.isUserInteractionEnabled = true
        }
        profWithSwitch.tag = baseTag + 25
        scrollView.addSubview(profWithSwitch)
        
        let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-75, y: 360, width: 90, height: 40))
        abilityDmgLabel.text = "Ability\nMod to\nDamage"
        abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
        abilityDmgLabel.textAlignment = NSTextAlignment.center
        abilityDmgLabel.numberOfLines = 3
        abilityDmgLabel.tag = baseTag + 26
        scrollView.addSubview(abilityDmgLabel)
        
        let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2-50, y: 400, width:51, height:31))
        abilityDmgSwitch.isOn = true//damage.mod_damage
        if newWeaponCustom == false {
            abilityDmgSwitch.isUserInteractionEnabled = false
        }
        else {
            abilityDmgSwitch.isUserInteractionEnabled = true
        }
        abilityDmgSwitch.tag = baseTag + 27
        scrollView.addSubview(abilityDmgSwitch)
        
        let magicDmgLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-10, y: 360, width: 90, height: 40))
        magicDmgLabel.text = "Magic Item\nDamage\nBonus"
        magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
        magicDmgLabel.textAlignment = NSTextAlignment.center
        magicDmgLabel.numberOfLines = 3
        magicDmgLabel.tag = baseTag + 28
        scrollView.addSubview(magicDmgLabel)
        
        let magicDmgField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+15, y:400, width:40, height:30))
        magicDmgField.text = ""//String(damage.magic_bonus)
        magicDmgField.textAlignment = NSTextAlignment.center
        magicDmgField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            magicDmgField.isEnabled = false
            magicDmgField.textColor = UIColor.darkGray
            magicDmgField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            magicDmgField.isEnabled = true
            magicDmgField.textColor = UIColor.black
            magicDmgField.layer.borderColor = UIColor.black.cgColor
        }
        magicDmgField.tag = baseTag + 29
        scrollView.addSubview(magicDmgField)
        
        let miscDmgLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+55, y: 360, width: 90, height: 40))
        miscDmgLabel.text = "Misc\nDamage\nBonus"
        miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
        miscDmgLabel.textAlignment = NSTextAlignment.center
        miscDmgLabel.numberOfLines = 3
        miscDmgLabel.tag = baseTag + 30
        scrollView.addSubview(miscDmgLabel)
        
        let miscDmgField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+80, y:400, width:40, height:30))
        miscDmgField.text = ""//String(damage.misc_bonus)
        miscDmgField.textAlignment = NSTextAlignment.center
        miscDmgField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            miscDmgField.isEnabled = false
            miscDmgField.textColor = UIColor.darkGray
            miscDmgField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            miscDmgField.isEnabled = true
            miscDmgField.textColor = UIColor.black
            miscDmgField.layer.borderColor = UIColor.black.cgColor
        }
        miscDmgField.tag = baseTag + 31
        scrollView.addSubview(miscDmgField)
        
        let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 440, width: scrollView.frame.size.width/2-20, height: 30))
        weaponDmgLabel.text = "Weapon Damage Die"
        weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
        weaponDmgLabel.textAlignment = NSTextAlignment.center
        weaponDmgLabel.tag = baseTag + 32
        scrollView.addSubview(weaponDmgLabel)
        
        let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+10, y: 440, width: scrollView.frame.size.width/2-20, height: 30))
        extraWeaponDmgLabel.text = "Extra Damage Die"
        extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
        extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
        extraWeaponDmgLabel.tag = baseTag + 33
        scrollView.addSubview(extraWeaponDmgLabel)
        
        let weaponDieAmount = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-140, y:470, width:40, height:30))
        weaponDieAmount.text = ""//String(damage.die_number)
        weaponDieAmount.textAlignment = NSTextAlignment.center
        weaponDieAmount.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            weaponDieAmount.isEnabled = false
            weaponDieAmount.textColor = UIColor.darkGray
            weaponDieAmount.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            weaponDieAmount.isEnabled = true
            weaponDieAmount.textColor = UIColor.black
            weaponDieAmount.layer.borderColor = UIColor.black.cgColor
        }
        weaponDieAmount.tag = baseTag + 34
        scrollView.addSubview(weaponDieAmount)
        
        let weaponD = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2-100, y:470, width:20, height:30))
        weaponD.text = "d"
        weaponD.textAlignment = NSTextAlignment.center
        weaponD.tag = baseTag + 35
        scrollView.addSubview(weaponD)
        
        let weaponDie = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-80, y:470, width:40, height:30))
        weaponDie.text = ""//String(damage.die_type)
        weaponDie.textAlignment = NSTextAlignment.center
        weaponDie.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            weaponDie.isEnabled = false
            weaponDie.textColor = UIColor.darkGray
            weaponDie.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            weaponDie.isEnabled = true
            weaponDie.textColor = UIColor.black
            weaponDie.layer.borderColor = UIColor.black.cgColor
        }
        weaponDie.tag = baseTag + 36
        scrollView.addSubview(weaponDie)
        
        let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2+40, y: 465, width:51, height:31))
        extraDieSwitch.isOn = false//damage.extra_die
        extraDieSwitch.tag = baseTag + 37
        scrollView.addSubview(extraDieSwitch)
        
        let extraDieAmount = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+20, y:500, width:40, height:30))
        extraDieAmount.text = ""//String(damage.extra_die_number)
        extraDieAmount.textAlignment = NSTextAlignment.center
        extraDieAmount.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            extraDieAmount.isEnabled = false
            extraDieAmount.textColor = UIColor.darkGray
            extraDieAmount.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            extraDieAmount.isEnabled = true
            extraDieAmount.textColor = UIColor.black
            extraDieAmount.layer.borderColor = UIColor.black.cgColor
        }
        extraDieAmount.tag = baseTag + 38
        scrollView.addSubview(extraDieAmount)
        
        let extraD = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2+60, y:500, width:20, height:30))
        extraD.text = "d"
        extraD.textAlignment = NSTextAlignment.center
        extraD.tag = baseTag + 39
        scrollView.addSubview(extraD)
        
        let extraDieField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+80, y:500, width:40, height:30))
        extraDieField.text = ""//String(damage.extra_die_type)
        extraDieField.textAlignment = NSTextAlignment.center
        extraDieField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            extraDieField.isEnabled = false
            extraDieField.textColor = UIColor.darkGray
            extraDieField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            extraDieField.isEnabled = true
            extraDieField.textColor = UIColor.black
            extraDieField.layer.borderColor = UIColor.black.cgColor
        }
        extraDieField.tag = baseTag + 40
        scrollView.addSubview(extraDieField)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 540, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 41
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 570, width: 40, height: 30))
        quantityField.text = "1"//String(weapon.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 42
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: scrollView.frame.size.width/2+75, y: 570, width: 94, height: 29))
        quantityStepper.value = 0//Double(weapon.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 43
        scrollView.addSubview(quantityStepper)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 610, width: scrollView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 44
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 640, width: scrollView.frame.size.width - 20, height: 30))
        weightField.text = ""//weapon.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            weightField.isEnabled = false
            weightField.textColor = UIColor.darkGray
            weightField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            weightField.isEnabled = true
            weightField.textColor = UIColor.black
            weightField.layer.borderColor = UIColor.black.cgColor
        }
        weightField.tag = baseTag + 45
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 680, width: scrollView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 46
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 710, width: scrollView.frame.size.width - 20, height: 30))
        costField.text = ""//weapon.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            costField.isEnabled = false
            costField.textColor = UIColor.darkGray
            costField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            costField.isEnabled = true
            costField.textColor = UIColor.black
            costField.layer.borderColor = UIColor.black.cgColor
        }
        costField.tag = baseTag + 47
        scrollView.addSubview(costField)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 750, width: scrollView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 48
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 780, width: scrollView.frame.size.width - 20, height: 100))
        infoView.text = ""//weapon.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        if newWeaponCustom == false {
            infoView.isUserInteractionEnabled = false
            infoView.textColor = UIColor.darkGray
            infoView.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            infoView.isUserInteractionEnabled = true
            infoView.textColor = UIColor.black
            infoView.layer.borderColor = UIColor.black.cgColor
        }
        infoView.tag = baseTag + 49
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 780 + infoView.frame.size.height + 10)
    }
    
    func createNewArmor(baseTag: Int, scrollView: UIScrollView) {
        let customLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 70, height: 30))
        customLabel.text = "Custom"
        customLabel.textAlignment = .right
        customLabel.tag = baseTag + 1
        scrollView.addSubview(customLabel)
        
        let customSwitch = UISwitch(frame: CGRect(x: 85, y: 5, width: 51, height: 31))
        customSwitch.isOn = newArmorCustom
        customSwitch.tag = baseTag + 2
        scrollView.addSubview(customSwitch)
        
        let typeSelector = UISegmentedControl.init(frame: CGRect.init(x:10, y:40, width:scrollView.frame.size.width-20, height:30))
        typeSelector.insertSegment(withTitle:"Light", at:0, animated:false)
        typeSelector.insertSegment(withTitle:"Medium", at:1, animated:false)
        typeSelector.insertSegment(withTitle:"Heavy", at:2, animated:false)
        typeSelector.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        typeSelector.selectedSegmentIndex = 0
        typeSelector.tag = baseTag + 3
        scrollView.addSubview(typeSelector)
        
        let armorPickerView = UIPickerView.init(frame: CGRect.init(x: 10, y: 80, width: scrollView.frame.size.width-20, height: 60))
        armorPickerView.dataSource = self
        armorPickerView.delegate = self
        armorPickerView.layer.borderWidth = 1.0
        if newArmorCustom == true {
            armorPickerView.isUserInteractionEnabled = false
            armorPickerView.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            armorPickerView.isUserInteractionEnabled = true
            armorPickerView.layer.borderColor = UIColor.black.cgColor
        }
        armorPickerView.layer.borderColor = UIColor.black.cgColor
        armorPickerView.tag = baseTag + 4
//        let row = Types.DamageStrings.index(of: damage.damage_type!.capitalized)
//        damageTypePickerView.selectRow(row!, inComponent: 0, animated: false)
        scrollView.addSubview(armorPickerView)
        
        let abilityType: String = "DEX"//(armor.ability_mod?.name)!
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
        
        let baseValueLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-135, y: 150, width: 90, height: 30))
        baseValueLabel.text = "Base\nValue"
        baseValueLabel.font = UIFont.systemFont(ofSize: 10)
        baseValueLabel.textAlignment = NSTextAlignment.center
        baseValueLabel.numberOfLines = 2
        baseValueLabel.tag = baseTag + 5
        scrollView.addSubview(baseValueLabel)
        
        let baseValueField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-110, y: 180, width:40, height:30))
        baseValueField.text = ""//String(armor.value)
        baseValueField.textAlignment = NSTextAlignment.center
        baseValueField.isEnabled = false
        baseValueField.textColor = UIColor.darkGray
        baseValueField.layer.borderWidth = 1.0
        baseValueField.layer.borderColor = UIColor.darkGray.cgColor
        baseValueField.tag = baseTag + 6
        scrollView.addSubview(baseValueField)
        
        let abilityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-75, y: 150, width: 90, height: 30))
        abilityLabel.text = abilityName+"\nBonus"
        abilityLabel.font = UIFont.systemFont(ofSize: 10)
        abilityLabel.textAlignment = NSTextAlignment.center
        abilityLabel.numberOfLines = 2
        abilityLabel.tag = baseTag + 7
        scrollView.addSubview(abilityLabel)
        
        let abilityField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-50, y: 180, width:40, height:30))
        abilityField.text = String(abilityMod)
        abilityField.textAlignment = NSTextAlignment.center
        abilityField.isEnabled = false
        abilityField.textColor = UIColor.darkGray
        abilityField.layer.borderWidth = 1.0
        abilityField.layer.borderColor = UIColor.black.cgColor
        abilityField.tag = baseTag + 8
        scrollView.addSubview(abilityField)
        
        let magicLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-10, y: 150, width: 90, height: 30))
        magicLabel.text = "Magic Item\nBonus"
        magicLabel.font = UIFont.systemFont(ofSize: 10)
        magicLabel.textAlignment = NSTextAlignment.center
        magicLabel.numberOfLines = 2
        magicLabel.tag = baseTag + 9
        scrollView.addSubview(magicLabel)
        
        let magicField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+15, y: 180, width:40, height:30))
        magicField.text = ""//String(armor.magic_bonus)
        magicField.textAlignment = NSTextAlignment.center
        magicField.layer.borderWidth = 1.0
        magicField.layer.borderColor = UIColor.black.cgColor
        magicField.tag = baseTag + 10
        scrollView.addSubview(magicField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+55, y: 150, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = baseTag + 11
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+80, y: 180, width:40, height:30))
        miscField.text = ""//String(armor.misc_bonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = baseTag + 12
        scrollView.addSubview(miscField)
        
        let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:220, width:scrollView.frame.size.width-20, height:30))
        aa.insertSegment(withTitle:"STR", at:0, animated:false)
        aa.insertSegment(withTitle:"DEX", at:1, animated:false)
        aa.insertSegment(withTitle:"CON", at:2, animated:false)
        aa.insertSegment(withTitle:"INT", at:3, animated:false)
        aa.insertSegment(withTitle:"WIS", at:4, animated:false)
        aa.insertSegment(withTitle:"CHA", at:5, animated:false)
        aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        aa.selectedSegmentIndex = aaIndex
        aa.tag = baseTag + 13
        scrollView.addSubview(aa)
        
        let stealthDisadvantageLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-135, y: 260, width: 90, height: 30))
        stealthDisadvantageLabel.text = "Stealth\nDisadvantage"
        stealthDisadvantageLabel.font = UIFont.systemFont(ofSize: 10)
        stealthDisadvantageLabel.textAlignment = NSTextAlignment.center
        stealthDisadvantageLabel.numberOfLines = 2
        stealthDisadvantageLabel.tag = baseTag + 14
        scrollView.addSubview(stealthDisadvantageLabel)
        
        let stealthDisadvantageSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2-115, y: 290, width:51, height:31))
        stealthDisadvantageSwitch.isOn = false//armor.stealth_disadvantage
        stealthDisadvantageSwitch.tag = baseTag + 12
        scrollView.addSubview(stealthDisadvantageSwitch)
        
        let equippedLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2-75, y: 260, width: 90, height: 30))
        equippedLabel.text = "Equipped"
        equippedLabel.font = UIFont.systemFont(ofSize: 10)
        equippedLabel.textAlignment = NSTextAlignment.center
        equippedLabel.numberOfLines = 1
        equippedLabel.tag = baseTag + 16
        scrollView.addSubview(equippedLabel)
        
        let equippedSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2-50, y: 290, width:51, height:31))
        equippedSwitch.isOn = false//armor.equipped
        equippedSwitch.tag = baseTag + 17
        scrollView.addSubview(equippedSwitch)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 260, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 18
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 290, width: 40, height: 30))
        quantityField.text = ""//String(armor.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 19
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: scrollView.frame.size.width/2+75, y: 290, width: 94, height: 29))
        quantityStepper.value = 1//Double(armor.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 20
        scrollView.addSubview(quantityStepper)
        
        let strRequirementLabel = UILabel.init(frame: CGRect.init(x: 10, y: 330, width: 180, height: 30))
        strRequirementLabel.text = "Strength Requirement"
        strRequirementLabel.textAlignment = NSTextAlignment.center
        strRequirementLabel.tag = baseTag + 21
        scrollView.addSubview(strRequirementLabel)
        
        let strRequirementField = UITextField.init(frame: CGRect.init(x: 10, y: 360, width: scrollView.frame.size.width - 124, height: 30))
        strRequirementField.text = ""//String(armor.str_requirement)
        strRequirementField.textAlignment = NSTextAlignment.center
        strRequirementField.layer.borderWidth = 1.0
        strRequirementField.layer.borderColor = UIColor.black.cgColor
        strRequirementField.tag = baseTag + 22
        scrollView.addSubview(strRequirementField)
        
        let strRequirementStepper = UIStepper.init(frame: CGRect.init(x: strRequirementField.frame.size.width + 15, y: 360, width: 94, height: 29))
        strRequirementStepper.value = 10//Double(armor.str_requirement)
        strRequirementStepper.minimumValue = 0
        strRequirementStepper.maximumValue = 9999
        strRequirementStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        strRequirementStepper.tag = baseTag + 23
        scrollView.addSubview(strRequirementStepper)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 400, width: scrollView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 24
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 430, width: scrollView.frame.size.width - 20, height: 30))
        weightField.text = ""//armor.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 25
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 470, width: scrollView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 26
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 500, width: scrollView.frame.size.width - 20, height: 30))
        costField.text = ""//armor.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 27
        scrollView.addSubview(costField)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 540, width: scrollView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 28
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 570, width: scrollView.frame.size.width - 20, height: 100))
        infoView.text = ""//armor.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 29
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 570 + infoView.frame.size.height + 10)
    }
    
    func createNewTool(baseTag: Int, scrollView: UIScrollView) {
        let customLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 70, height: 30))
        customLabel.text = "Custom"
        customLabel.textAlignment = .right
        customLabel.tag = baseTag + 1
        scrollView.addSubview(customLabel)
        
        let customSwitch = UISwitch(frame: CGRect(x: 85, y: 5, width: 51, height: 31))
        customSwitch.isOn = newToolCustom
        customSwitch.tag = baseTag + 2
        scrollView.addSubview(customSwitch)
        
        let toolPickerView = UIPickerView.init(frame: CGRect.init(x: 10, y: 40, width: scrollView.frame.size.width-20, height: 60))
        toolPickerView.dataSource = self
        toolPickerView.delegate = self
        toolPickerView.layer.borderWidth = 1.0
        if newToolCustom == true {
            toolPickerView.isUserInteractionEnabled = false
            toolPickerView.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            toolPickerView.isUserInteractionEnabled = true
            toolPickerView.layer.borderColor = UIColor.black.cgColor
        }
        toolPickerView.layer.borderColor = UIColor.black.cgColor
        toolPickerView.tag = baseTag + 3
//        let row = Types.DamageStrings.index(of: damage.damage_type!.capitalized)
//        toolPickerView.selectRow(row!, inComponent: 0, animated: false)
        scrollView.addSubview(toolPickerView)
        
        let abilityType: String = "INT"//(tool.ability?.name)!
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
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x: 10, y: 110, width: scrollView.frame.size.width/2 - 20, height: 30))
        proficientLabel.text = "Proficient"
        proficientLabel.textAlignment = NSTextAlignment.center
        proficientLabel.numberOfLines = 2
        proficientLabel.tag = baseTag + 4
        scrollView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x: scrollView.frame.size.width/2 - 51 - 110, y: 140, width: 51, height: 31))
        proficientSwitch.isOn = true//tool.proficient
        proficientSwitch.tag = baseTag + 5
        scrollView.addSubview(proficientSwitch)
        
        let proficientField = UITextField.init(frame: CGRect.init(x: scrollView.frame.size.width/2 - 40 - 40, y: 140, width: 40, height: 30))
        proficientField.text = String(Character.Selected.proficiencyBonus)
        proficientField.textAlignment = NSTextAlignment.center
        proficientField.isEnabled = false
        proficientField.textColor = UIColor.darkGray
        proficientField.layer.borderWidth = 1.0
        proficientField.layer.borderColor = UIColor.darkGray.cgColor
        proficientField.tag = baseTag + 6
        scrollView.addSubview(proficientField)
        
        let abilityModLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2 + 10, y: 110, width: scrollView.frame.size.width/2 - 20, height: 30))
        abilityModLabel.text = abilityName + " Mod"
        abilityModLabel.textAlignment = NSTextAlignment.center
        abilityModLabel.numberOfLines = 2
        abilityModLabel.tag = baseTag + 7
        scrollView.addSubview(abilityModLabel)
        
        let abilityModField = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2 + 70, y: 140, width:40, height:30))
        abilityModField.text = String(abilityMod)
        abilityModField.textAlignment = NSTextAlignment.center
        abilityModField.isEnabled = false
        abilityModField.textColor = UIColor.darkGray
        abilityModField.layer.borderWidth = 1.0
        abilityModField.layer.borderColor = UIColor.black.cgColor
        abilityModField.tag = baseTag + 8
        scrollView.addSubview(abilityModField)
        
        let aa = UISegmentedControl.init(frame: CGRect.init(x:10, y:180, width:scrollView.frame.size.width-20, height:30))
        aa.insertSegment(withTitle:"STR", at:0, animated:false)
        aa.insertSegment(withTitle:"DEX", at:1, animated:false)
        aa.insertSegment(withTitle:"CON", at:2, animated:false)
        aa.insertSegment(withTitle:"INT", at:3, animated:false)
        aa.insertSegment(withTitle:"WIS", at:4, animated:false)
        aa.insertSegment(withTitle:"CHA", at:5, animated:false)
        aa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        aa.selectedSegmentIndex = aaIndex
        aa.tag = baseTag + 9
        scrollView.addSubview(aa)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 220, width: scrollView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 10
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 250, width: scrollView.frame.size.width - 20, height: 30))
        weightField.text = ""//tool.weight
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 11
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 290, width: scrollView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 12
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 320, width: scrollView.frame.size.width - 20, height: 30))
        costField.text = ""//tool.cost
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 13
        scrollView.addSubview(costField)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 360, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 14
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 390, width: 40, height: 30))
        quantityField.text = "1"//String(tool.quantity)
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 15
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: scrollView.frame.size.width/2+75, y: 390, width: 94, height: 29))
        quantityStepper.value = 1//Double(tool.quantity)
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 16
        scrollView.addSubview(quantityStepper)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 430, width: scrollView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 17
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 460, width: scrollView.frame.size.width - 20, height: 100))
        infoView.text = ""//tool.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 18
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 440 + infoView.frame.size.height + 10)
    }
    
    func createNewItemDetails(baseTag: Int, scrollView: UIScrollView) {
        
        let nameLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: scrollView.frame.size.width - 20, height: 30))
        nameLabel.text = "Name"
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.tag = baseTag + 1
        scrollView.addSubview(nameLabel)
        
        let nameField = UITextField.init(frame: CGRect.init(x: 10, y: 35, width: scrollView.frame.size.width - 20, height: 30))
        nameField.text = ""
        nameField.textAlignment = NSTextAlignment.center
        nameField.tag = baseTag + 1
        nameField.layer.borderWidth = 1.0
        nameField.layer.borderColor = UIColor.black.cgColor
        scrollView.addSubview(nameField)
        
        let weightLabel = UILabel.init(frame: CGRect.init(x: 10, y: 75, width: scrollView.frame.size.width - 20, height: 30))
        weightLabel.text = "Weight"
        weightLabel.textAlignment = NSTextAlignment.center
        weightLabel.tag = baseTag + 10
        scrollView.addSubview(weightLabel)
        
        let weightField = UITextField.init(frame: CGRect.init(x: 10, y: 105, width: scrollView.frame.size.width - 20, height: 30))
        weightField.text = ""
        weightField.textAlignment = NSTextAlignment.center
        weightField.layer.borderWidth = 1.0
        weightField.layer.borderColor = UIColor.black.cgColor
        weightField.tag = baseTag + 11
        scrollView.addSubview(weightField)
        
        let costLabel = UILabel.init(frame: CGRect.init(x: 10, y: 145, width: scrollView.frame.size.width - 20, height: 30))
        costLabel.text = "Cost"
        costLabel.textAlignment = NSTextAlignment.center
        costLabel.tag = baseTag + 12
        scrollView.addSubview(costLabel)
        
        let costField = UITextField.init(frame: CGRect.init(x: 10, y: 175, width: scrollView.frame.size.width - 20, height: 30))
        costField.text = ""
        costField.textAlignment = NSTextAlignment.center
        costField.layer.borderWidth = 1.0
        costField.layer.borderColor = UIColor.black.cgColor
        costField.tag = baseTag + 13
        scrollView.addSubview(costField)
        
        let quantityLabel = UILabel.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 215, width: 90, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textAlignment = NSTextAlignment.center
        quantityLabel.tag = baseTag + 14
        scrollView.addSubview(quantityLabel)
        
        let quantityField = UITextField.init(frame: CGRect.init(x: scrollView.frame.size.width/2+25, y: 245, width: 40, height: 30))
        quantityField.text = "1"
        quantityField.textAlignment = NSTextAlignment.center
        quantityField.layer.borderWidth = 1.0
        quantityField.layer.borderColor = UIColor.black.cgColor
        quantityField.tag = baseTag + 15
        scrollView.addSubview(quantityField)
        
        let quantityStepper = UIStepper.init(frame: CGRect.init(x: scrollView.frame.size.width/2+75, y: 245, width: 94, height: 29))
        quantityStepper.value = 1
        quantityStepper.minimumValue = 0
        quantityStepper.maximumValue = 9999
        quantityStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        quantityStepper.tag = baseTag + 16
        scrollView.addSubview(quantityStepper)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 10, y: 285, width: scrollView.frame.size.width - 20, height: 30))
        infoLabel.text = "Description"
        infoLabel.textAlignment = .center
        infoLabel.tag = baseTag + 17
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 10, y: 315, width: scrollView.frame.size.width - 20, height: 100))
        infoView.text = ""
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 18
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 315 + infoView.frame.size.height + 10)
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
