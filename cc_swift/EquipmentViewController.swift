////
////  EquipmentViewController.swift
////  cc_swift
////
////  Created by Andrew Kolb on 1/4/17.
////
////
//
//import UIKit
//import SwiftyJSON
//
//class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//
//    // Platinum
//    @IBOutlet weak var platinumView: UIView!
//    @IBOutlet weak var platinumTitle: UILabel!
//    @IBOutlet weak var platinumValue: UITextField!
//    
//    // Gold
//    @IBOutlet weak var goldView: UIView!
//    @IBOutlet weak var goldTitle: UILabel!
//    @IBOutlet weak var goldValue: UITextField!
//    
//    // Electrum
//    @IBOutlet weak var electrumView: UIView!
//    @IBOutlet weak var electrumTitle: UILabel!
//    @IBOutlet weak var electrumValue: UITextField!
//    
//    // Silver
//    @IBOutlet weak var silverView: UIView!
//    @IBOutlet weak var silverTitle: UILabel!
//    @IBOutlet weak var silverValue: UITextField!
//    
//    // Copper
//    @IBOutlet weak var copperView: UIView!
//    @IBOutlet weak var copperTitle: UILabel!
//    @IBOutlet weak var copperValue: UITextField!
//    
//    // Filtered Equipment
//    @IBOutlet weak var equipmentView: UIView!
//    @IBOutlet weak var segControl: UISegmentedControl!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var equipmentTable: UITableView!
//    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var equipment: Equipment = Equipment()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
//        
//        equipmentTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        
//        equipment = Character.Selected.equipment!
//
//        self.setMiscDisplayData()
//    }
//    
//    func hideKeyboardOnTap(_ selector: Selector) {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    func setMiscDisplayData() {
//        let currency = equipment.currency!
//        // Platinum
//        platinumValue.text = String(currency.platinum)
//        
//        // Gold
//        goldValue.text = String(currency.gold)
//        
//        // Electrum
//        electrumValue.text = String(currency.electrum)
//        
//        // Silver
//        silverValue.text = String(currency.silver)
//        
//        // Copper
//        copperValue.text = String(currency.copper)
//        
//        platinumView.layer.borderWidth = 1.0
//        platinumView.layer.borderColor = UIColor.black.cgColor
//        
//        goldView.layer.borderWidth = 1.0
//        goldView.layer.borderColor = UIColor.black.cgColor
//        
//        electrumView.layer.borderWidth = 1.0
//        electrumView.layer.borderColor = UIColor.black.cgColor
//        
//        silverView.layer.borderWidth = 1.0
//        silverView.layer.borderColor = UIColor.black.cgColor
//        
//        copperView.layer.borderWidth = 1.0
//        copperView.layer.borderColor = UIColor.black.cgColor
//        
//        equipmentView.layer.borderWidth = 1.0
//        equipmentView.layer.borderColor = UIColor.black.cgColor
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func segmentChanged(segControl: UISegmentedControl) {
//        equipmentTable.reloadData()
//    }
//    
//    // UITableView Delegate & Data Source
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            if segControl.selectedSegmentIndex == 0 {
//                // Weapon
//                return equipment.weapons!.count
//            }
//            else if segControl.selectedSegmentIndex == 1 {
//                // Armor
//                return equipment.armor!.count
//            }
//            else if segControl.selectedSegmentIndex == 2 {
//                // Tools
//                return equipment.tools!.count
//            }
//            else if segControl.selectedSegmentIndex == 3 {
//                // Other
//                return equipment.other!.count
//            }
//            else {
//                // All
//                return equipment.weapons!.count + equipment.armor!.count + equipment.tools!.count + equipment.other!.count
//            }
//        }
//        else {
//            return 1
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            
//            let weapons = equipment.weapons
//            let allArmor = equipment.armor
//            let tools = equipment.tools
//            let other = equipment.other
//            
//            if segControl.selectedSegmentIndex == 0 {
//                // Weapon
//                let weapon = weapons?.allObjects[indexPath.row] as! Weapon
//                
//                let description = weapon.description + "\nWeight: " + weapon.weight! + "\nCost: " + weapon.cost!
//                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                
//                let height = 30+5+30+5+21+descriptionHeight
//                return height//165
//            }
//            else if segControl.selectedSegmentIndex == 1 {
//                // Armor
//                let armor = allArmor?.allObjects[indexPath.row] as! Armor
//                
//                var stealthDisadvantage = ""
//                if armor.stealth_disadvantage {
//                    stealthDisadvantage = "Yes"
//                }
//                else {
//                    stealthDisadvantage = "No"
//                }
//                
//                var equipped = ""
//                if armor.equipped {
//                    equipped = "Yes"
//                }
//                else {
//                    equipped = "No"
//                }
//                
//                let description = "..."//armor.description + "\nMinimum Strength: " + armor.str_requirement + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + armor.weight + "\nCost: " + armor.cost
//                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                
//                let height = 30+5+21+5+21+descriptionHeight
//                return height//165
//            }
//            else if segControl.selectedSegmentIndex == 2 {
//                // Tools
//                let tool = tools?.allObjects[indexPath.row] as! Tool
//                
//                let description = tool.description + "\nWeight: " + tool.weight! + "\nCost: " + tool.cost!
//                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                
//                let height = 30+5+21+5+21+descriptionHeight
//                return height//165
//            }
//            else if segControl.selectedSegmentIndex == 3 {
//                // Other
//                let otherItem = other?.allObjects[indexPath.row] as! Item
//                
//                let description = otherItem.description + "\nWeight: " + otherItem.weight + "\nCost: " + otherItem.cost
//                let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                
//                let height = 30+5+21+descriptionHeight
//                return height//165
//            }
//            else {
//                // All equipment
//                let equipment = allEquipment[indexPath.row]
//                if equipment.exists() {
//                    // Weapon
//                    let description = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                    
//                    let height = 30+5+30+5+21+descriptionHeight
//                    return height//165
//                }
//                else if equipment["str_requirement"].exists() {
//                    // Armor
//                    var stealthDisadvantage = ""
//                    if equipment["stealth_disadvantage"].bool! {
//                        stealthDisadvantage = "Yes"
//                    }
//                    else {
//                        stealthDisadvantage = "No"
//                    }
//                    
//                    var equipped = ""
//                    if equipment["equipped"].bool! {
//                        equipped = "Yes"
//                    }
//                    else {
//                        equipped = "No"
//                    }
//                    
//                    let description = equipment.description + "\nMinimum Strength: " + String(equipment["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                    
//                    let height = 30+5+21+5+21+descriptionHeight
//                    return height//165
//                }
//                else if equipment["ability"].exists() {
//                    // Tools
//                    let description = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                    
//                    let height = 30+5+21+5+21+descriptionHeight
//                    return height//165
//                }
//                else {
//                    // Other
//                    let description = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    let descriptionHeight = description.heightWithConstrainedWidth(width: view.frame.width, font: UIFont.systemFont(ofSize: 17))
//                    
//                    let height = 30+5+21+descriptionHeight
//                    return height//165
//                }
//            }
//        }
//        else {
//            return 30
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let weapons = equipment.weapons
//            let allArmor = equipment.armor
//            let tools = equipment.tools
//            let other = equipment.other
//            if segControl.selectedSegmentIndex == 0 {
//                // Weapon
//                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
//                let weapon = weapons[indexPath.row]
//                let attackBonusDict = weapon["attack_bonus"]
//                let damageDict = weapon["damage"]
//                
//                var attackBonus = 0
//                var damageBonus = 0
//                let modDamage = damageDict["mod_damage"].bool
//                let abilityType: String = attackBonusDict["ability"].string!
//                switch abilityType {
//                case "STR":
//                    attackBonus += Character.Selected.strBonus //Add STR bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.strBonus
//                    }
//                case "DEX":
//                    attackBonus += Character.Selected.dexBonus //Add DEX bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.dexBonus
//                    }
//                case "CON":
//                    attackBonus += Character.Selected.conBonus //Add CON bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.conBonus
//                    }
//                case "INT":
//                    attackBonus += Character.Selected.intBonus //Add INT bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.intBonus
//                    }
//                case "WIS":
//                    attackBonus += Character.Selected.wisBonus //Add WIS bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.wisBonus
//                    }
//                case "CHA":
//                    attackBonus += Character.Selected.chaBonus //Add CHA bonus
//                    if modDamage! {
//                        damageBonus += Character.Selected.chaBonus
//                    }
//                default: break
//                }
//                
//                attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
//                damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
//                
//                var damageDieNumber = damageDict["die_number"].int
//                var damageDie = damageDict["die_type"].int
//                let extraDie = damageDict["extra_die"].bool
//                if (extraDie)! {
//                    damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
//                    damageDie = damageDie! + damageDict["extra_die_type"].int!
//                }
//                
//                let damageType = damageDict["damage_type"].string
//                
//                cell.weaponName.text = weapon["name"].string?.capitalized
//                cell.weaponReach.text = "Range: "+weapon["range"].string!
//                cell.weaponModifier.text = "+"+String(attackBonus)
//                let dieDamage = String(damageDieNumber!)+"d"+String(damageDie!)
//                cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
//                
//                cell.descView.text = weapon.description + "\nWeight: " + weapon.weight + "\nCost: " + weapon["cost"].string!
//                if weapon["quantity"].int! <= 1 {
//                    cell.amountLabel.text = ""
//                }
//                else {
//                    cell.amountLabel.text = "x"+String(weapon["quantity"].int!)
//                }
//                
//                return cell
//            }
//            else if segControl.selectedSegmentIndex == 1 {
//                // Armor
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
//                let armor = allArmor[indexPath.row]
//                cell.armorName.text = armor["name"].string
//                
//                var armorValue = armor["value"].int!
//                armorValue += armor["magic_bonus"].int!
//                armorValue += armor["misc_bonus"].int!
//                
//                if (armor["mod"].string != "") {
//                    cell.armorValue.text = String(armorValue) + "+" + armor["mod"].string!
//                }
//                else {
//                    cell.armorValue.text = String(armorValue)
//                }
//                
//                var stealthDisadvantage = ""
//                if armor["stealth_disadvantage"].bool! {
//                    stealthDisadvantage = "Yes"
//                }
//                else {
//                    stealthDisadvantage = "No"
//                }
//                
//                var equipped = ""
//                if armor["equipped"].bool! {
//                    equipped = "Yes"
//                }
//                else {
//                    equipped = "No"
//                }
//                
//                cell.descView.text = armor.description + "\nMinimum Strength: " + String(armor["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + armor.weight + "\nCost: " + armor["cost"].string!
//                if armor["quantity"].int! <= 1 {
//                    cell.amountLabel.text = ""
//                }
//                else {
//                    cell.amountLabel.text = "x"+String(armor["quantity"].int!)
//                }
//                
//                return cell
//            }
//            else if segControl.selectedSegmentIndex == 2 {
//                // Tools
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
//                let tool = tools[indexPath.row]
//                
//                var toolValue = 0
//                if tool["proficient"].bool! {
//                    toolValue += Character.Selected.proficiencyBonus
//                }
//                
//                let abilityType: String = tool["ability"].string!
//                switch abilityType {
//                case "STR":
//                    toolValue += Character.Selected.strBonus //Add STR bonus
//                case "DEX":
//                    toolValue += Character.Selected.dexBonus //Add DEX bonus
//                case "CON":
//                    toolValue += Character.Selected.conBonus //Add CON bonus
//                case "INT":
//                    toolValue += Character.Selected.intBonus //Add INT bonus
//                case "WIS":
//                    toolValue += Character.Selected.wisBonus //Add WIS bonus
//                case "CHA":
//                    toolValue += Character.Selected.chaBonus //Add CHA bonus
//                default: break
//                }
//                
//                cell.toolName.text = tool["name"].string
//                cell.toolValue.text = "+"+String(toolValue)
//                cell.descView.text = tool.description + "\nWeight: " + tool.weight + "\nCost: " + tool["cost"].string!
//                if tool["quantity"].int! <= 1 {
//                    cell.amountLabel.text = ""
//                }
//                else {
//                    cell.amountLabel.text = "x"+String(tool["quantity"].int!)
//                }
//                return cell
//            }
//            else if segControl.selectedSegmentIndex == 3 {
//                // Other
//                let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
//                let otherItem = other[indexPath.row]
//                
//                cell.equipmentName.text = otherItem["name"].string!
//                cell.descView.text = otherItem.description + "\nWeight: " + otherItem.weight + "\nCost: " + otherItem["cost"].string!
//                if otherItem["quantity"].int! <= 1 {
//                    cell.amountLabel.text = ""
//                }
//                else {
//                    cell.amountLabel.text = "x"+String(otherItem["quantity"].int!)
//                }
//                
//                return cell
//            }
//            else {
//                // All equipment
//                let equipment = allEquipment[indexPath.row]
//                if equipment["attack_bonus"].exists() {
//                    // Weapons
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
//                    let attackBonusDict = equipment["attack_bonus"]
//                    let damageDict = equipment["damage"]
//                    
//                    var attackBonus = 0
//                    var damageBonus = 0
//                    let modDamage = damageDict["mod_damage"].bool
//                    let abilityType: String = attackBonusDict["ability"].string!
//                    switch abilityType {
//                    case "STR":
//                        attackBonus += Character.Selected.strBonus //Add STR bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.strBonus
//                        }
//                    case "DEX":
//                        attackBonus += Character.Selected.dexBonus //Add DEX bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.dexBonus
//                        }
//                    case "CON":
//                        attackBonus += Character.Selected.conBonus //Add CON bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.conBonus
//                        }
//                    case "INT":
//                        attackBonus += Character.Selected.intBonus //Add INT bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.intBonus
//                        }
//                    case "WIS":
//                        attackBonus += Character.Selected.wisBonus //Add WIS bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.wisBonus
//                        }
//                    case "CHA":
//                        attackBonus += Character.Selected.chaBonus //Add CHA bonus
//                        if modDamage! {
//                            damageBonus += Character.Selected.chaBonus
//                        }
//                    default: break
//                    }
//                    
//                    attackBonus = attackBonus + attackBonusDict["magic_bonus"].int! + attackBonusDict["misc_bonus"].int!
//                    damageBonus = damageBonus + damageDict["magic_bonus"].int! + damageDict["misc_bonus"].int!
//                    
//                    var damageDieNumber = damageDict["die_number"].int
//                    var damageDie = damageDict["die_type"].int
//                    let extraDie = damageDict["extra_die"].bool
//                    if (extraDie)! {
//                        damageDieNumber = damageDieNumber! + damageDict["extra_die_number"].int!
//                        damageDie = damageDie! + damageDict["extra_die_type"].int!
//                    }
//                    
//                    let damageType = damageDict["damage_type"].string
//                    
//                    cell.weaponName.text = equipment["name"].string?.capitalized
//                    cell.weaponReach.text = "Range: "+equipment["range"].string!
//                    cell.weaponModifier.text = "+"+String(attackBonus)
//                    let dieDamage = String(damageDieNumber!)+"d"+String(damageDie!)
//                    cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
//                    
//                    cell.descView.text = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    if equipment["quantity"].int! <= 1 {
//                        cell.amountLabel.text = ""
//                    }
//                    else {
//                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
//                    }
//                    
//                    return cell
//                }
//                else if equipment["str_requirement"].exists() {
//                    // Armor
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "ArmorTableViewCell", for: indexPath) as! ArmorTableViewCell
//                    cell.armorName.text = equipment["name"].string
//                    
//                    var armorValue = equipment["value"].int!
//                    armorValue += equipment["magic_bonus"].int!
//                    armorValue += equipment["misc_bonus"].int!
//                    
//                    if (equipment["mod"].string != "") {
//                        cell.armorValue.text = String(armorValue) + "+" + equipment["mod"].string!
//                    }
//                    else {
//                        cell.armorValue.text = String(armorValue)
//                    }
//                    
//                    var stealthDisadvantage = ""
//                    if equipment["stealth_disadvantage"].bool! {
//                        stealthDisadvantage = "Yes"
//                    }
//                    else {
//                        stealthDisadvantage = "No"
//                    }
//                    
//                    var equipped = ""
//                    if equipment["equipped"].bool! {
//                        equipped = "Yes"
//                    }
//                    else {
//                        equipped = "No"
//                    }
//                    
//                    cell.descView.text = equipment.description + "\nMinimum Strength: " + String(equipment["str_requirement"].int!) + "\nStealth Disadvantage: " + stealthDisadvantage + "\nEquipped: " + equipped + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    if equipment["quantity"].int! <= 1 {
//                        cell.amountLabel.text = ""
//                    }
//                    else {
//                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
//                    }
//                    
//                    return cell
//                }
//                else if equipment["ability"].exists() {
//                    // Tools
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "ToolTableViewCell", for: indexPath) as! ToolTableViewCell
//                    
//                    var toolValue: Int32 = 0
//                    if equipment["proficient"].bool! {
//                        toolValue += Character.Selected.proficiency_bonus
//                    }
//                    
//                    let abilityType: String = equipment["ability"].string!
//                    switch abilityType {
//                    case "STR":
//                        toolValue += Character.Selected.strBonus //Add STR bonus
//                    case "DEX":
//                        toolValue += Character.Selected.dexBonus //Add DEX bonus
//                    case "CON":
//                        toolValue += Character.Selected.conBonus //Add CON bonus
//                    case "INT":
//                        toolValue += Character.Selected.intBonus //Add INT bonus
//                    case "WIS":
//                        toolValue += Character.Selected.wisBonus //Add WIS bonus
//                    case "CHA":
//                        toolValue += Character.Selected.chaBonus //Add CHA bonus
//                    default: break
//                    }
//                    
//                    cell.toolName.text = equipment["name"].string
//                    cell.toolValue.text = "+"+String(toolValue)
//                    cell.descView.text = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    if equipment["quantity"].int! <= 1 {
//                        cell.amountLabel.text = ""
//                    }
//                    else {
//                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
//                    }
//                    return cell
//                }
//                else {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTableViewCell", for: indexPath) as! EquipmentTableViewCell
//                    
//                    cell.equipmentName.text = equipment["name"].string!
//                    cell.descView.text = equipment.description + "\nWeight: " + equipment.weight + "\nCost: " + equipment["cost"].string!
//                    if equipment["quantity"].int! <= 1 {
//                        cell.amountLabel.text = ""
//                    }
//                    else {
//                        cell.amountLabel.text = "x"+String(equipment["quantity"].int!)
//                    }
//                    
//                    return cell
//                }
//            }
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Edit selected skill value
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
