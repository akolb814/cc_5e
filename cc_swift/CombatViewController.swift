//
//  CombatViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 12/20/16.
//
//

import UIKit
import SwiftyJSON

class CombatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // HP
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var hpTitle: UILabel!
    @IBOutlet weak var hpValue: UILabel!
    @IBOutlet weak var hpButton: UIButton!
    
    // Resource
    @IBOutlet weak var resourceView: UIView!
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var resourceValue: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    
    // Proficiency
    @IBOutlet weak var profView: UIView!
    @IBOutlet weak var profTitle: UILabel!
    @IBOutlet weak var profValue: UILabel!
    @IBOutlet weak var profButton: UIButton!
    
    // Armor Class
    @IBOutlet weak var acView: UIView!
    @IBOutlet weak var acTitle: UILabel!
    @IBOutlet weak var acValue: UILabel!
    @IBOutlet weak var acButton: UIButton!
    
    // Speed
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedTitle: UILabel!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    
    // Initiative
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var initTitle: UILabel!
    @IBOutlet weak var initValue: UILabel!
    @IBOutlet weak var initButton: UIButton!
    
    // Weapon TableView
    @IBOutlet weak var weaponsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        weaponsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
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
        // HP
        hpValue.text = String(appDelegate.character.currentHP)+"/"+String(appDelegate.character.maxHP)
        
        // Resource
        resourceTitle.text = appDelegate.character.martialResource["name"].string
        
        let currentResourceValue: Int = appDelegate.character.martialResource["current_value"].int!
        let maxResourceValue: Int = appDelegate.character.martialResource["max_value"].int!
        let dieType: Int = appDelegate.character.martialResource["die_type"].int!
        
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
        
        // Proficiency
        profValue.text = "+"+String(appDelegate.character.proficiencyBonus)
        
        // Armor Class
        acValue.text = String(appDelegate.character.AC)
        
        // Speed
        speedValue.text = String(appDelegate.character.speed)
        
        // Initiative
        if appDelegate.character.initiative < 0 {
            initValue.text = String(appDelegate.character.initiative)
        }
        else {
            initValue.text = "+"+String(appDelegate.character.initiative)
        }
        
        hpView.layer.borderWidth = 1.0
        hpView.layer.borderColor = UIColor.black.cgColor
        
        resourceView.layer.borderWidth = 1.0
        resourceView.layer.borderColor = UIColor.black.cgColor
        
        profView.layer.borderWidth = 1.0
        profView.layer.borderColor = UIColor.black.cgColor
        
        acView.layer.borderWidth = 1.0
        acView.layer.borderColor = UIColor.black.cgColor
        
        speedView.layer.borderWidth = 1.0
        speedView.layer.borderColor = UIColor.black.cgColor
        
        initView.layer.borderWidth = 1.0
        initView.layer.borderColor = UIColor.black.cgColor
        
        weaponsTable.layer.borderWidth = 1.0
        weaponsTable.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Edit HP
    @IBAction func hpAction(button: UIButton) {
        
    }
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        
    }
    
    // Edit Proficiency
    @IBAction func profAction(button: UIButton) {
        
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        
    }
    
    // Edit Speed
    @IBAction func speedAction(button: UIButton) {
        
    }
    
    // Edit Initiative
    @IBAction func initAction(button: UIButton) {
        
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return appDelegate.character.equipment["weapons"].count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            // Existing weapon
            return 70
        }
        else {
            // New weapon
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell", for: indexPath) as! WeaponTableViewCell
            let weapon = appDelegate.character.equipment["weapons"][indexPath.row]
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
            
            cell.weaponName.text = weapon["name"].string?.capitalized
            cell.weaponReach.text = "Range: "+weapon["range"].string!
            cell.weaponModifier.text = "+"+String(attackBonus)
            let dieDamage = String(damageDieNumber!)+"d"+String(damageDie!)
            cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
            
            return cell
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
}

