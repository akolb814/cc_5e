//
//  CombatViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 12/20/16.
//
//

import UIKit
import SwiftyJSON

class CombatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    // HP
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var hpTitle: UILabel!
    @IBOutlet weak var hpValue: UILabel!
    @IBOutlet weak var dsPass1: UIView!
    @IBOutlet weak var dsPass2: UIView!
    @IBOutlet weak var dsPass3: UIView!
    @IBOutlet weak var dsFail1: UIView!
    @IBOutlet weak var dsFail2: UIView!
    @IBOutlet weak var dsFail3: UIView!
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
    
    var newItem = false
    var newWeaponCustom = false
    var newWeaponMartial = true
    var newWeaponRanged = true
    var newWeaponQuantityEffectValue: Int32 = 1
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hpEffectValue: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        weaponsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        self.setMiscDisplayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateDeathSaves()
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
        dsPass1.layer.cornerRadius = 10
        dsPass1.layer.borderColor = UIColor.green.cgColor
        dsPass1.layer.borderWidth = 0.5
        
        dsPass2.layer.cornerRadius = 10
        dsPass2.layer.borderColor = UIColor.green.cgColor
        dsPass2.layer.borderWidth = 0.5
        
        dsPass3.layer.cornerRadius = 10
        dsPass3.layer.borderColor = UIColor.green.cgColor
        dsPass3.layer.borderWidth = 0.5
        
        dsFail1.layer.cornerRadius = 10
        dsFail1.layer.borderColor = UIColor.red.cgColor
        dsFail1.layer.borderWidth = 0.5
        
        dsFail2.layer.cornerRadius = 10
        dsFail2.layer.borderColor = UIColor.red.cgColor
        dsFail2.layer.borderWidth = 0.5
        
        dsFail3.layer.cornerRadius = 10
        dsFail3.layer.borderColor = UIColor.red.cgColor
        dsFail3.layer.borderWidth = 0.5
        
        if Character.Selected.current_hp == 0 {
            // Death Saves
            hpTitle.text = "Death Saves"
            hpValue.isHidden = true
            hpValue.text = ""
            
            dsPass1.isHidden = false
            dsPass2.isHidden = false
            dsPass3.isHidden = false
            dsFail1.isHidden = false
            dsFail2.isHidden = false
            dsFail3.isHidden = false
            
            updateDeathSaves()
        }
        else {
            hpTitle.text = "HP"
            hpValue.isHidden = false
            hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
            
            dsPass1.isHidden = true
            dsPass2.isHidden = true
            dsPass3.isHidden = true
            dsFail1.isHidden = true
            dsFail2.isHidden = true
            dsFail3.isHidden = true
        }
        
        if((Character.Selected.resources?.allObjects.count ?? 0)! > 0) {
            for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                if resource.spellcasting == false {
                    resourceTitle.text = resource.name ?? "Resource"
                    
                    let currentResourceValue: Int32 = resource.current_value
                    let maxResourceValue: Int32 = resource.max_value
                    let dieType: Int32 = resource.die_type
                    
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
                }
            }
        }
        
        // Proficiency
        profValue.text = "+"+String(Character.Selected.proficiency_bonus)
        
        // Armor Class
        acValue.text = String(Character.Selected.ac)
        
        // Speed
        switch Character.Selected.speed_type {
        case 0:
            // Walk
            speedTitle.text = "Walk"
            speedValue.text = String(Character.Selected.speed_walk)
            break
        case 1:
            speedTitle.text = "Burrow"
            speedValue.text = String(Character.Selected.speed_burrow)
            break
        case 2:
            speedTitle.text = "Climb"
            speedValue.text = String(Character.Selected.speed_climb)
            break
        case 3:
            speedTitle.text = "Fly"
            speedValue.text = String(Character.Selected.speed_fly)
            break
        case 4:
            speedTitle.text = "Swim"
            speedValue.text = String(Character.Selected.speed_swim)
            break
        default: break
        }
        
        // Initiative
        if Character.Selected.initiative < 0 {
            initValue.text = String(Character.Selected.initiative)
        }
        else {
            initValue.text = "+"+String(Character.Selected.initiative)
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
    
    func updateDeathSaves() {
        if Character.Selected.current_hp >= 1 {
            hpTitle.text = "HP"
            hpValue.isHidden = false
            hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
            
            dsPass1.isHidden = true
            dsPass2.isHidden = true
            dsPass3.isHidden = true
            dsFail1.isHidden = true
            dsFail2.isHidden = true
            dsFail3.isHidden = true
        }
        else {
            var passes = 0
            var fails = 0
            
            // Determine number of passes & fails
            for counter in Character.Selected.death_saves {
                if counter == "Pass" {
                    passes = passes + 1
                }
                else {
                    fails = fails + 1
                }
            }
            
            switch passes {
            case 0:
                dsPass1.backgroundColor = UIColor.clear
                dsPass2.backgroundColor = UIColor.clear
                dsPass3.backgroundColor = UIColor.clear
                break
                
            case 1:
                dsPass1.backgroundColor = UIColor.green
                dsPass2.backgroundColor = UIColor.clear
                dsPass3.backgroundColor = UIColor.clear
                break
                
            case 2:
                dsPass1.backgroundColor = UIColor.green
                dsPass2.backgroundColor = UIColor.green
                dsPass3.backgroundColor = UIColor.clear
                break
                
            case 3:
                // Stabalize
                dsPass1.backgroundColor = UIColor.green
                dsPass2.backgroundColor = UIColor.green
                dsPass3.backgroundColor = UIColor.green
                
                Character.Selected.death_saves.removeAll()
                Character.Selected.current_hp = 1
                
                hpTitle.text = "HP"
                hpValue.isHidden = false
                hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
                
                dsPass1.isHidden = true
                dsPass2.isHidden = true
                dsPass3.isHidden = true
                dsFail1.isHidden = true
                dsFail2.isHidden = true
                dsFail3.isHidden = true
                
                updateDeathSaves()
                break
                
            default:
                dsPass1.backgroundColor = UIColor.green
                dsPass2.backgroundColor = UIColor.green
                dsPass3.backgroundColor = UIColor.green
                break
                
            }
            
            switch fails {
            case 0:
                dsFail1.backgroundColor = UIColor.clear
                dsFail2.backgroundColor = UIColor.clear
                dsFail3.backgroundColor = UIColor.clear
                break
                
            case 1:
                dsFail1.backgroundColor = UIColor.red
                dsFail2.backgroundColor = UIColor.clear
                dsFail3.backgroundColor = UIColor.clear
                break
                
            case 2:
                dsFail1.backgroundColor = UIColor.red
                dsFail2.backgroundColor = UIColor.red
                dsFail3.backgroundColor = UIColor.clear
                break
                
            case 3:
                dsFail1.backgroundColor = UIColor.red
                dsFail2.backgroundColor = UIColor.red
                dsFail3.backgroundColor = UIColor.red
                break
                
            default:
                dsFail1.backgroundColor = UIColor.red
                dsFail2.backgroundColor = UIColor.red
                dsFail3.backgroundColor = UIColor.red
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        switch parentView.tag {
        case 100:
            // HP
            for case let view in parentView.subviews {
                if view.tag == 105 {
                    let segControl = view as! UISegmentedControl
                    if segControl.selectedSegmentIndex == 0 {
                        // Damage
                        Character.Selected.current_hp = Int32(Character.Selected.current_hp - hpEffectValue)
                    }
                    else if segControl.selectedSegmentIndex == 1 {
                        // Heal
                        Character.Selected.current_hp = Int32(Character.Selected.current_hp + hpEffectValue)
                        if Character.Selected.current_hp > Character.Selected.max_hp {
                            Character.Selected.current_hp = Character.Selected.max_hp
                        }
                    }
                    else {
                        // Temp HP
                        Character.Selected.current_hp = Int32(Character.Selected.current_hp + hpEffectValue)
                    }
                }
            }
            hpEffectValue = 0
            
            if Character.Selected.current_hp == 0 {
                // Death Saves
                hpTitle.text = "Death Saves"
                hpValue.isHidden = true
                hpValue.text = ""
                
                dsPass1.isHidden = false
                dsPass2.isHidden = false
                dsPass3.isHidden = false
                dsFail1.isHidden = false
                dsFail2.isHidden = false
                dsFail3.isHidden = false
                
                updateDeathSaves()
            }
            else {
                hpTitle.text = "HP"
                hpValue.isHidden = false
                hpValue.text = String(Character.Selected.current_hp)+"/"+String(Character.Selected.max_hp)
                
                dsPass1.isHidden = true
                dsPass2.isHidden = true
                dsPass3.isHidden = true
                dsFail1.isHidden = true
                dsFail2.isHidden = true
                dsFail3.isHidden = true
            }
            
            break
            
        case 200:
            // Resource
            for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                if resource.spellcasting == false {
                    resourceTitle.text = resource.name
                    let currentResourceValue: Int32 = resource.current_value
                    let maxResourceValue: Int32 = resource.max_value
                    let dieType: Int32 = resource.die_type
                    
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
                }
            }
            break
            
        case 300:
            // Proficiency Bonus
            profValue.text = "+"+String(Character.Selected.proficiency_bonus)
            break
            
        case 400:
            // Armor Class
            acValue.text = String(Character.Selected.ac)
            break
            
        case 500:
            // Speed
            switch Character.Selected.speed_type {
            case 0:
                // Walk
                speedTitle.text = "Walk"
                speedValue.text = String(Character.Selected.speed_walk)
                break
            case 1:
                speedTitle.text = "Burrow"
                speedValue.text = String(Character.Selected.speed_burrow)
                break
            case 2:
                speedTitle.text = "Climb"
                speedValue.text = String(Character.Selected.speed_climb)
                break
            case 3:
                speedTitle.text = "Fly"
                speedValue.text = String(Character.Selected.speed_fly)
                break
            case 4:
                speedTitle.text = "Swim"
                speedValue.text = String(Character.Selected.speed_swim)
                break
            default: break
            }
            break
            
        case 600:
            // Initiative
            if Character.Selected.initiative < 0 {
                initValue.text = String(Character.Selected.initiative)
            }
            else {
                initValue.text = "+"+String(Character.Selected.initiative)
            }
            break
            
        default:
            if parentView.tag >= 700 {
                let baseTag = parentView.tag
                let index = (baseTag - 700)/100
                
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
                
                weaponsTable.reloadData()
            }
            break
            
        }
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func segmentChanged(segControl: UISegmentedControl) {
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
    
    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == 107 {
            // HP
            hpEffectValue = Int32(stepper.value)
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 106 {
                    let textField = view as! UITextField
                    textField.text = String(hpEffectValue)
                }
            }
        }
        else if stepper.tag == 209 {
            // HD
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 202 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
    }
    
    // Edit HP
    @IBAction func hpAction(button: UIButton) {
        if Character.Selected.current_hp == 0 {
            // Create an alert view to select fail, cancel, pass
            let alert: UIAlertController = UIAlertController(title: "Death Save", message: "", preferredStyle: .alert)
            let pass: UIAlertAction = UIAlertAction(title: "Pass", style: .default, handler: { (action: UIAlertAction) in
                Character.Selected.death_saves.append("Pass")
                self.updateDeathSaves()
            })
            alert.addAction(pass)
            
            let fail: UIAlertAction = UIAlertAction(title: "Fail", style: .default, handler: { (action: UIAlertAction) in
                Character.Selected.death_saves.append("Fail")
                self.updateDeathSaves()
            })
            alert.addAction(fail)
            
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                
            })
            alert.addAction(cancel)
            
            self.present(alert, animated: true)
        }
        else {
            // Create hit point adjusting view
            let tempView = createBasicView()
            tempView.tag = 100
            
            let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
            title.text = "HP"
            title.textAlignment = NSTextAlignment.center
            title.tag = 101
            tempView.addSubview(title)
            
            let currentHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
            currentHP.text = String(Character.Selected.current_hp)
            currentHP.textAlignment = NSTextAlignment.center
            currentHP.layer.borderWidth = 1.0
            currentHP.layer.borderColor = UIColor.black.cgColor
            currentHP.tag = 102
            tempView.addSubview(currentHP)
            
            let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
            slash.text = "/"
            slash.textAlignment = NSTextAlignment.center
            slash.tag = 103
            tempView.addSubview(slash)
            
            let maxHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
            maxHP.text = String(Character.Selected.max_hp)
            maxHP.textAlignment = NSTextAlignment.center
            maxHP.layer.borderWidth = 1.0
            maxHP.layer.borderColor = UIColor.black.cgColor
            maxHP.tag = 104
            tempView.addSubview(maxHP)
            
            let effectType = UISegmentedControl.init(frame: CGRect.init(x:10, y:75, width:tempView.frame.size.width-20, height:30))
            effectType.insertSegment(withTitle:"Damage", at:0, animated:false)
            effectType.insertSegment(withTitle:"Heal", at:1, animated:false)
            effectType.insertSegment(withTitle:"Temp", at:2, animated:false)
            effectType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
            effectType.selectedSegmentIndex = 0
            effectType.tag = 105
            tempView.addSubview(effectType)
            
            let effectValue = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:110, width:40, height:30))
            effectValue.text = String(hpEffectValue)
            effectValue.textAlignment = NSTextAlignment.center
            effectValue.layer.borderWidth = 1.0
            effectValue.layer.borderColor = UIColor.black.cgColor
            effectValue.tag = 106
            tempView.addSubview(effectValue)
            
            let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:145, width:94, height:29))
            stepper.value = 0
            stepper.minimumValue = 0
            stepper.maximumValue = 1000
            stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
            stepper.tag = 107
            tempView.addSubview(stepper)
            
            view.addSubview(tempView)
        }
    }
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        // Create resource adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
            if resource.spellcasting == false {
                let currentResourceValue: Int32 = resource.current_value
                let maxResourceValue: Int32 = resource.max_value
                let dieType: Int32 = resource.die_type
                
                let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
                title.text = resource.name
                title.textAlignment = NSTextAlignment.center
                title.tag = 201
                tempView.addSubview(title)
                
                if dieType == 0 {
                    if maxResourceValue == 0 {
                        // current
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                    }
                    else {
                        // current / max
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 205
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 206
                        tempView.addSubview(maxResource)
                    }
                }
                else {
                    if maxResourceValue == 0 {
                        // current d die
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 203
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 204
                        tempView.addSubview(rd1)
                    }
                    else {
                        // current d die / max d die
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 202
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 203
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.isUserInteractionEnabled = false
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 204
                        tempView.addSubview(rd1)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 205
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 206
                        tempView.addSubview(maxResource)
                        
                        let d2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:35, width:30, height:30))
                        d2.text = "d"
                        d2.textAlignment = NSTextAlignment.center
                        d2.tag = 207
                        tempView.addSubview(d2)
                        
                        let rd2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:35, width:40, height:30))
                        rd2.text = String(dieType)
                        rd2.textAlignment = NSTextAlignment.center
                        rd2.layer.borderWidth = 1.0
                        rd2.layer.borderColor = UIColor.black.cgColor
                        rd2.tag = 208
                        tempView.addSubview(rd2)
                    }
                }
                
                let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:90, width:94, height:29))
                stepper.value = Double(currentResourceValue)
                stepper.minimumValue = 0
                stepper.maximumValue = Double(maxResourceValue)
                stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                stepper.tag = 209
                tempView.addSubview(stepper)
        
            }
        }
        
        view.addSubview(tempView)
    }
    
    // Edit Proficiency
    @IBAction func profAction(button: UIButton) {
        // Create proficiency bonus adjusting view
        let tempView = createBasicView()
        tempView.tag = 300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Proficiency Bonus"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        tempView.addSubview(title)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.black.cgColor
        profField.tag = 302
        tempView.addSubview(profField)
        
        view.addSubview(tempView)
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        // Create armor class adjusting view
        let tempView = createBasicView()
        tempView.tag = 400
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Armor Class"
        title.textAlignment = NSTextAlignment.center
        title.tag = 401
        scrollView.addSubview(title)
        
        // Armor value
        let armorValueLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 30, width: 40, height: 30))
        armorValueLabel.text = "Armor\nValue"
        armorValueLabel.font = UIFont.systemFont(ofSize: 10)
        armorValueLabel.textAlignment = NSTextAlignment.center
        armorValueLabel.numberOfLines = 2
        armorValueLabel.tag = 402
        scrollView.addSubview(armorValueLabel)
        
        let armorValueField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:55, width:40, height:30))
        armorValueField.text = String(10)
        armorValueField.textAlignment = NSTextAlignment.center
        armorValueField.layer.borderWidth = 1.0
        armorValueField.layer.borderColor = UIColor.darkGray.cgColor
        armorValueField.textColor = UIColor.darkGray
        armorValueField.isEnabled = false
        armorValueField.tag = 403
        scrollView.addSubview(armorValueField)
        
        // Dex bonus
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-70, y: 30, width: 40, height: 30))
        dexLabel.text = "Dex\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 404
        scrollView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-70, y:55, width:40, height:30))
        dexField.text = String(Character.Selected.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.darkGray.cgColor
        dexField.textColor = UIColor.darkGray
        dexField.isEnabled = false
        dexField.tag = 405
        scrollView.addSubview(dexField)
        
        // Shield Value
        let shieldLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-20, y: 30, width: 40, height: 30))
        shieldLabel.text = "Shield\nValue"
        shieldLabel.font = UIFont.systemFont(ofSize: 10)
        shieldLabel.textAlignment = NSTextAlignment.center
        shieldLabel.numberOfLines = 2
        shieldLabel.tag = 406
        scrollView.addSubview(shieldLabel)
        
        let shieldField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:55, width:40, height:30))
        shieldField.text = String(0)
        shieldField.textAlignment = NSTextAlignment.center
        shieldField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        shieldField.tag = 407
        scrollView.addSubview(shieldField)
        
        // Max Dex
        let maxDexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+30, y: 30, width: 40, height: 30))
        maxDexLabel.text = "Max\nDex"
        maxDexLabel.font = UIFont.systemFont(ofSize: 10)
        maxDexLabel.textAlignment = NSTextAlignment.center
        maxDexLabel.numberOfLines = 2
        maxDexLabel.tag = 408
        scrollView.addSubview(maxDexLabel)
        
        let maxDexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+30, y:55, width:40, height:30))
        maxDexField.text = "-"
        maxDexField.textAlignment = NSTextAlignment.center
        maxDexField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        maxDexField.tag = 409
        scrollView.addSubview(maxDexField)
        
        // Misc Mod
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+80, y: 30, width: 40, height: 30))
        miscLabel.text = "Misc\nValue"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 410
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:55, width:40, height:30))
        miscField.text = String(Character.Selected.ac_misc)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 411
        scrollView.addSubview(miscField)
        
        //Additional Ability Mod (Monk/Barb)
        let addAbilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 90, width: 90, height: 30))
        addAbilityLabel.text = "Additional Mod"
        addAbilityLabel.font = UIFont.systemFont(ofSize: 10)
        addAbilityLabel.tag = 412
        scrollView.addSubview(addAbilityLabel)
        
        let addAbilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:90, width:40, height:30))
        addAbilityField.text = String(0)
        addAbilityField.textAlignment = NSTextAlignment.center
        addAbilityField.layer.borderWidth = 1.0
        addAbilityField.layer.borderColor = UIColor.darkGray.cgColor
        addAbilityField.textColor = UIColor.darkGray
        addAbilityField.isEnabled = false
        addAbilityField.tag = 413
        scrollView.addSubview(addAbilityField)
        
        let addAbilitySeg = UISegmentedControl.init(frame: CGRect.init(x:10, y:130, width:tempView.frame.size.width-20, height:30))
        addAbilitySeg.insertSegment(withTitle:"N/A", at:0, animated:false)
        addAbilitySeg.insertSegment(withTitle:"STR", at:1, animated:false)
        addAbilitySeg.insertSegment(withTitle:"DEX", at:2, animated:false)
        addAbilitySeg.insertSegment(withTitle:"CON", at:3, animated:false)
        addAbilitySeg.insertSegment(withTitle:"INT", at:4, animated:false)
        addAbilitySeg.insertSegment(withTitle:"WIS", at:5, animated:false)
        addAbilitySeg.insertSegment(withTitle:"CHA", at:6, animated:false)
        addAbilitySeg.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        addAbilitySeg.selectedSegmentIndex = 0
        addAbilitySeg.tag = 414
        scrollView.addSubview(addAbilitySeg)
        
        let armorTable = UITableView.init(frame: CGRect.init(x:10, y:170, width:tempView.frame.size.width-20, height:80))
        armorTable.tag = 415
        armorTable.delegate = self
        armorTable.dataSource = self
        scrollView.addSubview(armorTable)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 260)
        
        
        let allArmor: [Armor] = Character.Selected.equipment!.armor?.allObjects as! [Armor]
        
        for armor: Armor in allArmor {
            if armor.equipped == true {
                if armor.shield == true {
                    let shieldValue = armor.value + armor.magic_bonus + armor.misc_bonus
                    shieldField.text = String(shieldValue)
                }
                else {
                    let armorValue = armor.value + armor.magic_bonus + armor.misc_bonus
                    armorValueField.text = String(armorValue)
                    let maxDex = armor.max_dex
                    if maxDex == 0 {
                        maxDexField.text = "-"
                    }
                    else {
                        maxDexField.text = String(maxDex)
                    }
                }
            }
        }
        
        switch Character.Selected.additional_ac_mod! {
        case "STR":
            addAbilitySeg.selectedSegmentIndex = 1
            addAbilityField.text = String(Character.Selected.strBonus)
            break
        case "DEX":
            addAbilitySeg.selectedSegmentIndex = 2
            addAbilityField.text = String(Character.Selected.dexBonus)
            break
        case "CON":
            addAbilitySeg.selectedSegmentIndex = 3
            addAbilityField.text = String(Character.Selected.conBonus)
            break
        case "INT":
            addAbilitySeg.selectedSegmentIndex = 4
            addAbilityField.text = String(Character.Selected.intBonus)
            break
        case "WIS":
            addAbilitySeg.selectedSegmentIndex = 5
            addAbilityField.text = String(Character.Selected.wisBonus)
            break
        case "CHA":
            addAbilitySeg.selectedSegmentIndex = 6
            addAbilityField.text = String(Character.Selected.chaBonus)
            break
        default:
            addAbilitySeg.selectedSegmentIndex = 0
            addAbilityField.text = "-"
            break
        }
        
        view.addSubview(tempView)
    }
    
    // Edit Speed
    @IBAction func speedAction(button: UIButton) {
        // Create speed adjusting view
        let tempView = createBasicView()
        tempView.tag = 500
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Speed"
        title.textAlignment = NSTextAlignment.center
        title.tag = 501
        tempView.addSubview(title)
        
        let baseLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-85, y: 35, width: 90, height: 30))
        baseLabel.text = "Base\nValue"
        baseLabel.font = UIFont.systemFont(ofSize: 10)
        baseLabel.textAlignment = NSTextAlignment.center
        baseLabel.numberOfLines = 2
        baseLabel.tag = 502
        tempView.addSubview(baseLabel)
        
        let baseField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:65, width:40, height:30))
        baseField.textAlignment = NSTextAlignment.center
        baseField.layer.borderWidth = 1.0
        baseField.layer.borderColor = UIColor.black.cgColor
        baseField.tag = 503
        tempView.addSubview(baseField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-5, y: 35, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 504
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:65, width:40, height:30))
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 505
        tempView.addSubview(miscField)
        
        switch Character.Selected.speed_type {
        case 0:
            // Walk
            baseField.text = String(Character.Selected.speed_walk)
            miscField.text = String(Character.Selected.speed_walk_misc)
            break
        case 1:
            // Burrow
            baseField.text = String(Character.Selected.speed_burrow)
            miscField.text = String(Character.Selected.speed_burrow_misc)
            break
        case 2:
            // Climb
            baseField.text = String(Character.Selected.speed_climb)
            miscField.text = String(Character.Selected.speed_climb_misc)
            break
        case 3:
            // Fly
            baseField.text = String(Character.Selected.speed_fly)
            miscField.text = String(Character.Selected.speed_fly_misc)
            break
        case 4:
            // Swim
            baseField.text = String(Character.Selected.speed_swim)
            miscField.text = String(Character.Selected.speed_swim_misc)
            break
        default: break
        }
        
        let movementLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        movementLabel.text = "Movement Type"
        movementLabel.textAlignment = NSTextAlignment.center
        movementLabel.tag = 506
        tempView.addSubview(movementLabel)
        
        let movementType = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        movementType.insertSegment(withTitle:"Walk", at:0, animated:false)
        movementType.insertSegment(withTitle:"Burrow", at:1, animated:false)
        movementType.insertSegment(withTitle:"Climb", at:2, animated:false)
        movementType.insertSegment(withTitle:"Fly", at:3, animated:false)
        movementType.insertSegment(withTitle:"Swim", at:4, animated:false)
        movementType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        movementType.selectedSegmentIndex = 0
        movementType.tag = 507
        tempView.addSubview(movementType)
        
        view.addSubview(tempView)
    }
    
    // Edit Initiative
    @IBAction func initAction(button: UIButton) {
        // Create initiative adjusting view
        let tempView = createBasicView()
        tempView.tag = 600
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = "Initiative"
        title.textAlignment = NSTextAlignment.center
        title.tag = 601
        tempView.addSubview(title)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-105, y: 25, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = 602
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
        profField.text = String(Character.Selected.proficiency_bonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 603
        tempView.addSubview(profField)
        
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
        dexLabel.text = "Dexterity\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 604
        tempView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        dexField.text = String(Character.Selected.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.black.cgColor
        dexField.tag = 605
        tempView.addSubview(dexField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 606
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
        miscField.text = String(0)//String(Character.Selected.miscInitBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 607
        tempView.addSubview(miscField)
        
        let alertLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:85, width:120, height:30))
        alertLabel.text = "Alert Feat"
        alertLabel.textAlignment = NSTextAlignment.right
        alertLabel.tag = 608
        tempView.addSubview(alertLabel)
        
        let alertSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
        alertSwitch.isOn = false
        alertSwitch.tag = 609
        tempView.addSubview(alertSwitch)
        
        let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
        halfProfLabel.text = "Half Proficiency"
        halfProfLabel.textAlignment = NSTextAlignment.right
        halfProfLabel.tag = 610
        tempView.addSubview(halfProfLabel)
        
        let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
        halfProfSwitch.isOn = false
        halfProfSwitch.tag = 611
        tempView.addSubview(halfProfSwitch)
        
        let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
        roundUpLabel.text = "Round Up"
        roundUpLabel.textAlignment = NSTextAlignment.right
        roundUpLabel.tag = 612
        tempView.addSubview(roundUpLabel)
        
        let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
        roundUpSwitch.isOn = false
        roundUpSwitch.tag = 613
        tempView.addSubview(roundUpSwitch)
        
        if halfProfSwitch.isOn {
            roundUpLabel.isHidden = false
            roundUpSwitch.isHidden = false
        }
        else {
            roundUpLabel.isHidden = true
            roundUpSwitch.isHidden = true
        }
        
        view.addSubview(tempView)
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == weaponsTable{
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 415 {
            return (Character.Selected.equipment?.armor?.allObjects.count) ?? 0
        }
        else {
            if section == 0 {
                return (Character.Selected.equipment?.weapons?.allObjects.count) ?? 0
            }
            else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 415 {
            return 30
        }
        else {
            if indexPath.section == 0 {
                // Existing weapon
                return 70
            }
            else {
                // New weapon
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 415 {
            let cell = weaponsTable.dequeueReusableCell(withIdentifier: "ArmorTableViewCell") as! ArmorTableViewCell
            
            let armor = Character.Selected.equipment?.armor?.allObjects[indexPath.row] as! Armor            
            var armorValue = armor.value
            armorValue = armorValue + armor.magic_bonus
            armorValue = armorValue + armor.misc_bonus
            
            if armor.equipped == true {
                cell.armorName.textColor = UIColor.green
                cell.armorValue.textColor = UIColor.green
            }
            
            if armor.str_requirement > Character.Selected.strScore {
                cell.armorName.textColor = UIColor.red
                cell.armorValue.textColor = UIColor.red
            }
            
            cell.armorName.text = armor.name
            if armor.shield == true {
                cell.armorValue.text = " + " + String(armorValue)
            }
            else {
                if armor.ability_mod?.name == "" {
                    cell.armorValue.text = String(armorValue)
                }
                else {
                    cell.armorValue.text = String(armorValue) + " + " + (armor.ability_mod?.name)!
                }
            }
            
            return cell
        }
        else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeaponTableViewCell") as! WeaponTableViewCell
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
                
                let damageType = damage.damage_type
                
                cell.weaponName.text = weapon.name
                cell.weaponReach.text = "Range: " + weapon.range!
                cell.weaponModifier.text = "+" + String(attackBonus)
                let dieDamage = String(damageDieNumber)+"d"+String(damageDie)
                cell.weaponDamage.text = dieDamage+"+"+String(damageBonus)+" "+damageType!
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as! NewTableViewCell
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit selected skill value
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 415 {
            // Select a new armor to equip
            let allArmor = Character.Selected.equipment?.armor?.allObjects
            let armor: Armor = allArmor?[indexPath.row] as! Armor
            
            armor.equipped = !armor.equipped
            
            let parentView:UIView = tableView.superview!
            for case let view in parentView.subviews {
                if armor.shield == true {
                    if view.tag == 307 {
                        // Shield Value
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.value)
                        }
                        else {
                            textField.text = "-"
                        }
                    }
                }
                else {
                    if view.tag == 303 {
                        // Armor Value
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.value)
                        }
                        else {
                            textField.text = String(10)
                        }
                    }
                    else if view.tag == 309 {
                        // Max Dex
                        let textField = view as! UITextField
                        if armor.equipped == true {
                            textField.text = String(armor.max_dex)
                        }
                        else {
                            textField.text = "-"
                        }
                    }
                }
            }
            
            tableView.reloadData()
        }
        else {
            if indexPath.section == 0 {
                let tempView = createBasicView()
                tempView.tag = 700 + (indexPath.row * 100)
                
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
                title.tag = 700 + (indexPath.row * 100) + 1
                title.layer.borderWidth = 1.0
                title.layer.borderColor = UIColor.black.cgColor
                scrollView.addSubview(title)
                
                let reachLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                reachLabel.text = "Range"
                reachLabel.textAlignment = NSTextAlignment.center
                reachLabel.tag = 700 + (indexPath.row * 100) + 2
                scrollView.addSubview(reachLabel)
                
                let reachField = UITextField.init(frame: CGRect.init(x: 10, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                reachField.text = weapon.range
                reachField.textAlignment = NSTextAlignment.center
                reachField.layer.borderWidth = 1.0
                reachField.layer.borderColor = UIColor.black.cgColor
                reachField.tag = 700 + (indexPath.row * 100) + 3
                scrollView.addSubview(reachField)
                
                let damageTypeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 30, width: tempView.frame.size.width/2-15, height: 30))
                damageTypeLabel.text = "Damage Type"
                damageTypeLabel.textAlignment = NSTextAlignment.center
                damageTypeLabel.tag = 700 + (indexPath.row * 100) + 4
                scrollView.addSubview(damageTypeLabel)
                
                let damageTypePickerView = UIPickerView.init(frame: CGRect.init(x: tempView.frame.size.width/2+5, y: 55, width: tempView.frame.size.width/2-15, height: 40))
                damageTypePickerView.dataSource = self
                damageTypePickerView.delegate = self
                damageTypePickerView.layer.borderWidth = 1.0
                damageTypePickerView.layer.borderColor = UIColor.black.cgColor
                damageTypePickerView.tag = 700 + (indexPath.row * 100) + 5
                let row = Types.DamageStrings.index(of: damage.damage_type!.capitalized)
                damageTypePickerView.selectRow(row!, inComponent: 0, animated: false)
                scrollView.addSubview(damageTypePickerView)
                
                let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
                attackLabel.text = "Attack Ability"
                attackLabel.textAlignment = NSTextAlignment.center
                attackLabel.tag = 700 + (indexPath.row * 100) + 6
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
                aa.tag = 700 + (indexPath.row * 100) + 7
                scrollView.addSubview(aa)
                
                let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 145, width: 90, height: 30))
                profLabel.text = "Proficiency\nBonus"
                profLabel.font = UIFont.systemFont(ofSize: 10)
                profLabel.textAlignment = NSTextAlignment.center
                profLabel.numberOfLines = 2
                profLabel.tag = 700 + (indexPath.row * 100) + 8
                scrollView.addSubview(profLabel)
                
                let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:170, width:40, height:30))
                profField.text = String(Character.Selected.proficiency_bonus)
                profField.textAlignment = NSTextAlignment.center
                profField.isEnabled = false
                profField.textColor = UIColor.darkGray
                profField.layer.borderWidth = 1.0
                profField.layer.borderColor = UIColor.darkGray.cgColor
                profField.tag = 700 + (indexPath.row * 100) + 9
                scrollView.addSubview(profField)
                
                let abilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
                abilityLabel.text = abilityName+"\nBonus"
                abilityLabel.font = UIFont.systemFont(ofSize: 10)
                abilityLabel.textAlignment = NSTextAlignment.center
                abilityLabel.numberOfLines = 2
                abilityLabel.tag = 700 + (indexPath.row * 100) + 10
                scrollView.addSubview(abilityLabel)
                
                let abilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
                abilityField.text = String(abilityMod)
                abilityField.textAlignment = NSTextAlignment.center
                abilityField.isEnabled = false
                abilityField.textColor = UIColor.darkGray
                abilityField.layer.borderWidth = 1.0
                abilityField.layer.borderColor = UIColor.black.cgColor
                abilityField.tag = 700 + (indexPath.row * 100) + 11
                scrollView.addSubview(abilityField)
                
                let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
                magicLabel.text = "Magic Item\nAttack Bonus"
                magicLabel.font = UIFont.systemFont(ofSize: 10)
                magicLabel.textAlignment = NSTextAlignment.center
                magicLabel.numberOfLines = 2
                magicLabel.tag = 700 + (indexPath.row * 100) + 12
                scrollView.addSubview(magicLabel)
                
                let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
                magicField.text = String(weapon.magic_bonus)
                magicField.textAlignment = NSTextAlignment.center
                magicField.layer.borderWidth = 1.0
                magicField.layer.borderColor = UIColor.black.cgColor
                magicField.tag = 700 + (indexPath.row * 100) + 13
                scrollView.addSubview(magicField)
                
                let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 145, width: 90, height: 30))
                miscLabel.text = "Misc\nAttack Bonus"
                miscLabel.font = UIFont.systemFont(ofSize: 10)
                miscLabel.textAlignment = NSTextAlignment.center
                miscLabel.numberOfLines = 2
                miscLabel.tag = 700 + (indexPath.row * 100) + 14
                scrollView.addSubview(miscLabel)
                
                let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:170, width:40, height:30))
                miscField.text = String(weapon.misc_bonus)
                miscField.textAlignment = NSTextAlignment.center
                miscField.layer.borderWidth = 1.0
                miscField.layer.borderColor = UIColor.black.cgColor
                miscField.tag = 700 + (indexPath.row * 100) + 15
                scrollView.addSubview(miscField)
                
                let profWithLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 205, width: 90, height: 40))
                profWithLabel.text = "Proficient\nWith\nWeapon"
                profWithLabel.font = UIFont.systemFont(ofSize: 10)
                profWithLabel.textAlignment = NSTextAlignment.center
                profWithLabel.numberOfLines = 3
                profWithLabel.tag = 700 + (indexPath.row * 100) + 16
                scrollView.addSubview(profWithLabel)
                
                let profWithSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-115, y: 245, width:51, height:31))
                if (Character.Selected.weapon_proficiencies?.lowercased().contains(weapon.category!))! {
                    profWithSwitch.isOn = true
                }
                else {
                    profWithSwitch.isOn = false
                }
                profWithSwitch.tag = 700 + (indexPath.row * 100) + 17
                scrollView.addSubview(profWithSwitch)
                
                let abilityDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 205, width: 90, height: 40))
                abilityDmgLabel.text = "Ability\nMod to\nDamage"
                abilityDmgLabel.font = UIFont.systemFont(ofSize: 10)
                abilityDmgLabel.textAlignment = NSTextAlignment.center
                abilityDmgLabel.numberOfLines = 3
                abilityDmgLabel.tag = 700 + (indexPath.row * 100) + 18
                scrollView.addSubview(abilityDmgLabel)
                
                let abilityDmgSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2-50, y: 245, width:51, height:31))
                abilityDmgSwitch.isOn = damage.mod_damage
                
                abilityDmgSwitch.tag = 700 + (indexPath.row * 100) + 19
                scrollView.addSubview(abilityDmgSwitch)
                
                let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
                magicDmgLabel.text = "Magic Item\nDamage\nBonus"
                magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
                magicDmgLabel.textAlignment = NSTextAlignment.center
                magicDmgLabel.numberOfLines = 3
                magicDmgLabel.tag = 700 + (indexPath.row * 100) + 20
                scrollView.addSubview(magicDmgLabel)
                
                let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
                magicDmgField.text = String(damage.magic_bonus)
                magicDmgField.textAlignment = NSTextAlignment.center
                magicDmgField.layer.borderWidth = 1.0
                magicDmgField.layer.borderColor = UIColor.black.cgColor
                magicDmgField.tag = 700 + (indexPath.row * 100) + 21
                scrollView.addSubview(magicDmgField)
                
                let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
                miscDmgLabel.text = "Misc\nDamage\nBonus"
                miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
                miscDmgLabel.textAlignment = NSTextAlignment.center
                miscDmgLabel.numberOfLines = 3
                miscDmgLabel.tag = 700 + (indexPath.row * 100) + 22
                scrollView.addSubview(miscDmgLabel)
                
                let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
                miscDmgField.text = String(damage.misc_bonus)
                miscDmgField.textAlignment = NSTextAlignment.center
                miscDmgField.layer.borderWidth = 1.0
                miscDmgField.layer.borderColor = UIColor.black.cgColor
                miscDmgField.tag = 700 + (indexPath.row * 100) + 23
                scrollView.addSubview(miscDmgField)
                
                let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                weaponDmgLabel.text = "Weapon Damage Die"
                weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                weaponDmgLabel.textAlignment = NSTextAlignment.center
                weaponDmgLabel.tag = 700 + (indexPath.row * 100) + 24
                scrollView.addSubview(weaponDmgLabel)
                
                let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
                extraWeaponDmgLabel.text = "Extra Damage Die"
                extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
                extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
                extraWeaponDmgLabel.tag = 700 + (indexPath.row * 100) + 25
                scrollView.addSubview(extraWeaponDmgLabel)
                
                let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-140, y:320, width:40, height:30))
                weaponDieAmount.text = String(damage.die_number)
                weaponDieAmount.textAlignment = NSTextAlignment.center
                weaponDieAmount.layer.borderWidth = 1.0
                weaponDieAmount.layer.borderColor = UIColor.black.cgColor
                weaponDieAmount.tag = 700 + (indexPath.row * 100) + 26
                scrollView.addSubview(weaponDieAmount)
                
                let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-100, y:320, width:20, height:30))
                weaponD.text = "d"
                weaponD.textAlignment = NSTextAlignment.center
                weaponD.tag = 700 + (indexPath.row * 100) + 27
                scrollView.addSubview(weaponD)
                
                let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:40, height:30))
                weaponDie.text = String(damage.die_type)
                weaponDie.textAlignment = NSTextAlignment.center
                weaponDie.layer.borderWidth = 1.0
                weaponDie.layer.borderColor = UIColor.black.cgColor
                weaponDie.tag = 700 + (indexPath.row * 100) + 28
                scrollView.addSubview(weaponDie)
                
                let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
                extraDieSwitch.isOn = damage.extra_die
                extraDieSwitch.tag = 700 + (indexPath.row * 100) + 29
                scrollView.addSubview(extraDieSwitch)
                
                let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
                extraDieAmount.text = String(damage.extra_die_number)
                extraDieAmount.textAlignment = NSTextAlignment.center
                extraDieAmount.layer.borderWidth = 1.0
                extraDieAmount.layer.borderColor = UIColor.black.cgColor
                extraDieAmount.tag = 700 + (indexPath.row * 100) + 30
                scrollView.addSubview(extraDieAmount)
                
                let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
                extraD.text = "d"
                extraD.textAlignment = NSTextAlignment.center
                extraD.tag = 700 + (indexPath.row * 100) + 31
                scrollView.addSubview(extraD)
                
                let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
                extraDieField.text = String(damage.extra_die_type)
                extraDieField.textAlignment = NSTextAlignment.center
                extraDieField.layer.borderWidth = 1.0
                extraDieField.layer.borderColor = UIColor.black.cgColor
                extraDieField.tag = 700 + (indexPath.row * 100) + 32
                scrollView.addSubview(extraDieField)
                
                scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 380)
                
                view.addSubview(tempView)
            }
            else {
                createNewItem(baseTag: 700 + (indexPath.row * 100))
            }
        }
    }
    
    // Create new Item
    func createNewItem(baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        newItem = true
        
        let newLabel = UILabel(frame: CGRect.init(x: 10, y: 5, width: tempView.frame.size.width - 20, height: 30))
        newLabel.text = "New Weapon"
        newLabel.textAlignment = NSTextAlignment.center
        newLabel.tag = baseTag + 1
        newLabel.font = UIFont.systemFont(ofSize: 14)
        tempView.addSubview(newLabel)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 45, width: tempView.frame.size.width, height: tempView.frame.size.height-50-50))
        scrollView.tag = baseTag
        tempView.addSubview(scrollView)
        
        createNewWeapon(baseTag: baseTag, scrollView: scrollView)
        
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
        customSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        customSwitch.tag = baseTag + 2
        scrollView.addSubview(customSwitch)
        
        let simpleLabel = UILabel(frame: CGRect(x: 10, y: 40, width: 55, height: 30))
        simpleLabel.text = "Simple"
        simpleLabel.textAlignment = .right
        simpleLabel.tag = baseTag + 3
        scrollView.addSubview(simpleLabel)
        
        let simpleSwitch = UISwitch(frame: CGRect(x: 70, y: 40, width: 51, height: 31))
        simpleSwitch.isOn = newWeaponMartial
        simpleSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
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
        meleeSwitch.isOn = newWeaponRanged
        meleeSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
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
        weaponPickerView.isUserInteractionEnabled = !newWeaponCustom
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
    
    func switchChanged(sender: UISwitch) {
        let parentView = sender.superview!
        var baseTag = 0
        if parentView is UIScrollView {
            baseTag = parentView.superview!.tag
        }
        else {
            baseTag = parentView.tag
        }
        
        if sender.tag == baseTag + 2 {
            // Custom
            for case let view in parentView.subviews {
                view.removeFromSuperview()
            }
            
            newWeaponCustom = sender.isOn
            createNewWeapon(baseTag: baseTag, scrollView: parentView as! UIScrollView)
        }
        else if sender.tag == baseTag + 4 {
            // Simple - Martial Switch
            newWeaponMartial = sender.isOn
        }
        else if sender.tag == baseTag + 7 {
            // Melee - Ranged Switch
            newWeaponRanged = sender.isOn
        }
        
        for case let view in parentView.subviews {
            if view.tag == baseTag + 9 {
                // Update picker view
                let pickerView = view as! UIPickerView
                pickerView.reloadAllComponents()
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
                if newWeaponMartial == true {
                    if newWeaponRanged == true {
                        return Types.MartialRangedWeaponStrings.count
                    }
                    else {
                        return Types.MartialMeleeWeaponStrings.count
                    }
                }
                else {
                    if newWeaponRanged == true {
                        return Types.SimpleRangedWeaponStrings.count
                    }
                    else {
                        return Types.SimpleMeleeWeaponStrings.count
                    }
                }
            }
            else {
                return Types.DamageStrings.count
            }
        }
        else {
            return Types.DamageStrings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.superview != nil {
            let parentView = pickerView.superview
            let baseTag = parentView?.tag
            if pickerView.tag == baseTag! + 9 {
                // Weapon Selection
                if newWeaponMartial == true {
                    if newWeaponRanged == true {
//                    appDelegate.character. = Types.MartialRangedWeapons[row]
                    }
                    else {
//                    appDelegate.character. = Types.MartialMeleeWeapons[row]
                    }
                }
                else {
                    if newWeaponRanged == true {
//                    appDelegate.character. = Types.SimpleRangedWeapons[row]
                    }
                    else {
//                    appDelegate.character. = Types.Types.SimpleMeleeWeapons[row]
                    }
                }
            }
            else {
//                appDelegate.character. = damageTypes[row] as? String
            }
        }
        else {
//            appDelegate.character. = damageTypes[row] as? String
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
            
            if pickerView.tag == baseTag! + 9 {
                if newWeaponCustom == true {
                    pickerLabel?.textColor = UIColor.darkGray
                }
                else {
                    pickerLabel?.textColor = UIColor.black
                }
                
                // Weapon Selection
                if newWeaponMartial == true {
                    if newWeaponRanged == true {
                        pickerLabel?.text = Types.MartialRangedWeaponStrings[row]
                    }
                    else {
                        pickerLabel?.text = Types.MartialMeleeWeaponStrings[row]
                    }
                }
                else {
                    if newWeaponRanged == true {
                        pickerLabel?.text = Types.SimpleRangedWeaponStrings[row]
                    }
                    else {
                        pickerLabel?.text = Types.SimpleMeleeWeaponStrings[row]
                    }
                }
            }
            else {
                pickerLabel?.textColor = UIColor.black
                pickerLabel?.text = Types.DamageStrings[row]
            }
        }
        else {
            pickerLabel?.textColor = UIColor.black
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
}

