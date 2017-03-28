//
//  OverviewViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 12/20/16.
//
//

import UIKit
import SwiftyJSON

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // Character Overview
    @IBOutlet weak var characterView: UIView!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var backgroundTextField: UITextField!
    @IBOutlet weak var alignmentTextField: UITextField!
    @IBOutlet weak var experienceTextField: UITextField!
    // HP
    @IBOutlet weak var hpView: UIView!
    @IBOutlet weak var hpTitle: UILabel!
    @IBOutlet weak var hpValue: UILabel!
    @IBOutlet weak var hpButton: UIButton!
    // Hit Dice
    @IBOutlet weak var hdView: UIView!
    @IBOutlet weak var hdTitle: UILabel!
    @IBOutlet weak var hdValue: UILabel!
    @IBOutlet weak var hdButton: UIButton!
    // Armor Class
    @IBOutlet weak var acView: UIView!
    @IBOutlet weak var acTitle: UILabel!
    @IBOutlet weak var acValue: UILabel!
    @IBOutlet weak var acButton: UIButton!
    // Proficiency Bonus
    @IBOutlet weak var profView: UIView!
    @IBOutlet weak var profTitle: UILabel!
    @IBOutlet weak var profValue: UILabel!
    @IBOutlet weak var profButton: UIButton!
    // Strength
    @IBOutlet weak var strView: UIView!
    @IBOutlet weak var strTitle: UILabel!
    @IBOutlet weak var strScoreTitle: UILabel!
    @IBOutlet weak var strScoreValue: UILabel!
    @IBOutlet weak var strModTitle: UILabel!
    @IBOutlet weak var strModValue: UILabel!
    @IBOutlet weak var strSaveTitle: UILabel!
    @IBOutlet weak var strSaveValue: UILabel!
    @IBOutlet weak var strButton: UIButton!
    // Dexterity
    @IBOutlet weak var dexView: UIView!
    @IBOutlet weak var dexTitle: UILabel!
    @IBOutlet weak var dexScoreTitle: UILabel!
    @IBOutlet weak var dexScoreValue: UILabel!
    @IBOutlet weak var dexModTitle: UILabel!
    @IBOutlet weak var dexModValue: UILabel!
    @IBOutlet weak var dexSaveTitle: UILabel!
    @IBOutlet weak var dexSaveValue: UILabel!
    @IBOutlet weak var dexButton: UIButton!
    // Constitution
    @IBOutlet weak var conView: UIView!
    @IBOutlet weak var conTitle: UILabel!
    @IBOutlet weak var conScoreTitle: UILabel!
    @IBOutlet weak var conScoreValue: UILabel!
    @IBOutlet weak var conModTitle: UILabel!
    @IBOutlet weak var conModValue: UILabel!
    @IBOutlet weak var conSaveTitle: UILabel!
    @IBOutlet weak var conSaveValue: UILabel!
    @IBOutlet weak var conButton: UIButton!
    // Intelligence
    @IBOutlet weak var intView: UIView!
    @IBOutlet weak var intTitle: UILabel!
    @IBOutlet weak var intScoreTitle: UILabel!
    @IBOutlet weak var intScoreValue: UILabel!
    @IBOutlet weak var intModTitle: UILabel!
    @IBOutlet weak var intModValue: UILabel!
    @IBOutlet weak var intSaveTitle: UILabel!
    @IBOutlet weak var intSaveValue: UILabel!
    @IBOutlet weak var intButton: UIButton!
    // Wisdom
    @IBOutlet weak var wisView: UIView!
    @IBOutlet weak var wisTitle: UILabel!
    @IBOutlet weak var wisScoreTitle: UILabel!
    @IBOutlet weak var wisScoreValue: UILabel!
    @IBOutlet weak var wisModTitle: UILabel!
    @IBOutlet weak var wisModValue: UILabel!
    @IBOutlet weak var wisSaveTitle: UILabel!
    @IBOutlet weak var wisSaveValue: UILabel!
    @IBOutlet weak var wisButton: UIButton!
    // Charisma
    @IBOutlet weak var chaView: UIView!
    @IBOutlet weak var chaTitle: UILabel!
    @IBOutlet weak var chaScoreTitle: UILabel!
    @IBOutlet weak var chaScoreValue: UILabel!
    @IBOutlet weak var chaModTitle: UILabel!
    @IBOutlet weak var chaModValue: UILabel!
    @IBOutlet weak var chaSaveTitle: UILabel!
    @IBOutlet weak var chaSaveValue: UILabel!
    @IBOutlet weak var chaButton: UIButton!
    // Initiative
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var initTitle: UILabel!
    @IBOutlet weak var initValue: UILabel!
    @IBOutlet weak var initButton: UIButton!
    // Passive Perception
    @IBOutlet weak var ppView: UIView!
    @IBOutlet weak var ppTitle: UILabel!
    @IBOutlet weak var ppValue: UILabel!
    @IBOutlet weak var ppButton: UIButton!
    // Speed
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedTitle: UILabel!
    @IBOutlet weak var speedValue: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    // Skills
    @IBOutlet weak var skillsView: UIView!
    @IBOutlet weak var skillsTitle: UILabel!
    @IBOutlet weak var skillsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var hpEffectValue = 0
    let allClasses = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard", "Custom"]
    let levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    let allRaces = [
        ["race":"Aarakocra",
         "subraces":[]
        ],
        ["race":"Aasimar",
         "subraces":[]
        ],
        ["race":"Dragonborn",
         "subraces":[]
        ],
        ["race":"Dwarf",
         "subraces":["Dark", "Hill", "Mountain"]
        ],
        ["race":"Elf",
         "subraces":["Dark", "Eladrin", "High", "Wood"]
        ],
        ["race":"Genasi",
         "subraces":["Air", "Earth", "Fire", "Water"]
        ],
        ["race":"Gnome",
         "subraces":["Deep", "Forest", "Rock"]
        ],
        ["race":"Goliath",
         "subraces":[]
        ],
        ["race":"Half-Elf",
         "subraces":["Half-Elf", "Variant"]
        ],
        ["race":"Halfling",
         "subraces":["Ghastly", "Lightfoot", "Stout"]
        ],
        ["race":"Half-Orc",
         "subraces":[]
        ],
        ["race":"Human",
         "subraces":["Human", "Variant"]
        ],
        ["race":"Tiefling",
         "subraces":["Tiefling", "Variant"]
        ],
        ["race":"Custom",
         "subraces":[]
        ]
    ]
    let allBackgrounds = ["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Guild Artisan", "Hermit", "Noble", "Outlander", "Sage", "Sailor", "Soldier", "Urchin", "Custom"]
    func setMiscDisplayData() {
        let firstClass: JSON = appDelegate.character.classes[0] 
        let classStr = firstClass["class"].string!
        let level = firstClass["level"].int!
        
        var perceptionSkill = [:] as JSON
        for case let skill in appDelegate.character.skills.array! {
            let skillName = skill["skill"].string!
            if skillName == "Perception" {
                perceptionSkill = skill
            }
        }
        
        
        let attribute = perceptionSkill["attribute"].string!
        var skillValue = 0
        switch attribute {
        case "STR":
            skillValue += appDelegate.character.strBonus //Add STR bonus
        case "DEX":
            skillValue += appDelegate.character.dexBonus //Add DEX bonus
        case "CON":
            skillValue += appDelegate.character.conBonus //Add CON bonus
        case "INT":
            skillValue += appDelegate.character.intBonus //Add INT bonus
        case "WIS":
            skillValue += appDelegate.character.wisBonus //Add WIS bonus
        case "CHA":
            skillValue += appDelegate.character.chaBonus //Add CHA bonus
        default: break
        }
        
        let isProficient = perceptionSkill["proficient"].bool!
        if isProficient {
            skillValue += appDelegate.character.proficiencyBonus //Add proficiency bonus
        }
        let passivePerception = 10+skillValue
        ppValue.text = String(passivePerception)
        
        classTextField.text = classStr + " " + String(level)
        let race = appDelegate.character.race
        raceTextField.text = race["title"].string
        let background = appDelegate.character.background
        backgroundTextField.text = background["title"].string
        alignmentTextField.text = appDelegate.character.alignment
        experienceTextField.text = appDelegate.character.experience
        
        hpValue.text = String(appDelegate.character.currentHP)+"\n/"+String(appDelegate.character.maxHP)
        hdValue.text = String(appDelegate.character.currentHitDice)+"d"+String(appDelegate.character.hitDieType)+"\n/"+String(appDelegate.character.maxHitDice)+"d"+String(appDelegate.character.hitDieType)
        
        profValue.text = "+"+String(appDelegate.character.proficiencyBonus)
        acValue.text = String(appDelegate.character.AC)
        
        var initiative = appDelegate.character.initiative
        initiative = initiative + appDelegate.character.initiativeMiscBonus
        if appDelegate.character.initiative < 0 {
            initValue.text = String(appDelegate.character.initiative)
        }
        else {
            initValue.text = "+"+String(appDelegate.character.initiative)
        }
        
        switch appDelegate.character.speedType {
        case 0:
            // Walk
            speedTitle.text = "Walk"
            speedValue.text = String(appDelegate.character.walkSpeed)
            break
        case 1:
            speedTitle.text = "Burrow"
            speedValue.text = String(appDelegate.character.burrowSpeed)
            break
        case 2:
            speedTitle.text = "Climb"
            speedValue.text = String(appDelegate.character.climbSpeed)
            break
        case 3:
            speedTitle.text = "Fly"
            speedValue.text = String(appDelegate.character.flySpeed)
            break
        case 4:
            speedTitle.text = "Swim"
            speedValue.text = String(appDelegate.character.swimSpeed)
            break
        default: break
        }
        
        // HP
        hpView.layer.borderWidth = 1.0
        hpView.layer.borderColor = UIColor.black.cgColor
        // Hit Dice
        hdView.layer.borderWidth = 1.0
        hdView.layer.borderColor = UIColor.black.cgColor
        // Armor Class
        acView.layer.borderWidth = 1.0
        acView.layer.borderColor = UIColor.black.cgColor
        // Proficiency Bonus
        profView.layer.borderWidth = 1.0
        profView.layer.borderColor = UIColor.black.cgColor
        // Strength
        strView.layer.borderWidth = 1.0
        strView.layer.borderColor = UIColor.black.cgColor
        // Dexterity
        dexView.layer.borderWidth = 1.0
        dexView.layer.borderColor = UIColor.black.cgColor
        // Constitution
        conView.layer.borderWidth = 1.0
        conView.layer.borderColor = UIColor.black.cgColor
        // Intelligence
        intView.layer.borderWidth = 1.0
        intView.layer.borderColor = UIColor.black.cgColor
        // Wisdom
        wisView.layer.borderWidth = 1.0
        wisView.layer.borderColor = UIColor.black.cgColor
        // Charisma
        chaView.layer.borderWidth = 1.0
        chaView.layer.borderColor = UIColor.black.cgColor
        // Initiative
        initView.layer.borderWidth = 1.0
        initView.layer.borderColor = UIColor.black.cgColor
        // Passive Perception
        ppView.layer.borderWidth = 1.0
        ppView.layer.borderColor = UIColor.black.cgColor
        // Speed
        speedView.layer.borderWidth = 1.0
        speedView.layer.borderColor = UIColor.black.cgColor
        // Skills
        skillsView.layer.borderWidth = 1.0
        skillsView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        skillsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        self.setAbilityScores()
        self.setMiscDisplayData()
    }
    
    func setAbilityScores() {
        // STR
        strScoreValue.text = String(appDelegate.character.strScore)
        if appDelegate.character.strBonus < 0 {
            strModValue.text = String(appDelegate.character.strBonus)
        }
        else {
            strModValue.text = "+"+String(appDelegate.character.strBonus)
        }
        if appDelegate.character.strSave < 0 {
            strSaveValue.text = String(appDelegate.character.strSave)
        }
        else {
            strSaveValue.text = "+"+String(appDelegate.character.strSave)
        }
        
        // DEX
        dexScoreValue.text = String(appDelegate.character.dexScore)
        if appDelegate.character.dexBonus < 0 {
            dexModValue.text = String(appDelegate.character.dexBonus)
        }
        else {
            dexModValue.text = "+"+String(appDelegate.character.dexBonus)
        }
        if appDelegate.character.dexSave < 0 {
            dexSaveValue.text = String(appDelegate.character.dexSave)
        }
        else {
            dexSaveValue.text = "+"+String(appDelegate.character.dexSave)
        }
        
        // CON
        conScoreValue.text = String(appDelegate.character.conScore)
        if appDelegate.character.conBonus < 0 {
            conModValue.text = String(appDelegate.character.conBonus)
        }
        else {
            conModValue.text = "+"+String(appDelegate.character.conBonus)
        }
        if appDelegate.character.conSave < 0 {
            conSaveValue.text = String(appDelegate.character.conSave)
        }
        else {
            conSaveValue.text = "+"+String(appDelegate.character.conSave)
        }
        
        // INT
        intScoreValue.text = String(appDelegate.character.intScore)
        if appDelegate.character.intBonus < 0 {
            intModValue.text = String(appDelegate.character.intBonus)
        }
        else {
            intModValue.text = "+"+String(appDelegate.character.intBonus)
        }
        if appDelegate.character.intSave < 0 {
            intSaveValue.text = String(appDelegate.character.intSave)
        }
        else {
            intSaveValue.text = "+"+String(appDelegate.character.intSave)
        }
        
        // WIS
        wisScoreValue.text = String(appDelegate.character.wisScore)
        if appDelegate.character.wisBonus < 0 {
            wisModValue.text = String(appDelegate.character.wisBonus)
        }
        else {
            wisModValue.text = "+"+String(appDelegate.character.wisBonus)
        }
        if appDelegate.character.wisSave < 0 {
            wisSaveValue.text = String(appDelegate.character.wisSave)
        }
        else {
            wisSaveValue.text = "+"+String(appDelegate.character.wisSave)
        }
        
        // CHA
        chaScoreValue.text = String(appDelegate.character.chaScore)
        if appDelegate.character.chaBonus < 0 {
            chaModValue.text = String(appDelegate.character.chaBonus)
        }
        else {
            chaModValue.text = "+"+String(appDelegate.character.chaBonus)
        }
        if appDelegate.character.chaSave < 0 {
            chaSaveValue.text = String(appDelegate.character.chaSave)
        }
        else {
            chaSaveValue.text = "+"+String(appDelegate.character.chaSave)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
                        appDelegate.character.currentHP -= hpEffectValue
                    }
                    else if segControl.selectedSegmentIndex == 1 {
                        // Heal
                        appDelegate.character.currentHP += hpEffectValue
                        if appDelegate.character.currentHP > appDelegate.character.maxHP {
                            appDelegate.character.currentHP = appDelegate.character.maxHP
                        }
                    }
                    else {
                        // Temp HP
                        appDelegate.character.currentHP += hpEffectValue
                    }
                }
            }
            hpEffectValue = 0
            hpValue.text = String(appDelegate.character.currentHP)+"\n/"+String(appDelegate.character.maxHP)
            
            if appDelegate.character.currentHP == 0 {
                // Death Saves
            }
            break
            
        case 200:
            // Hit Dice
            for case let view in parentView.subviews {
                if view.tag == 209 {
                    let stepper = view as! UIStepper
                    appDelegate.character.currentHitDice = Int(stepper.value)
                }
            }
            
            let firstClass: JSON = appDelegate.character.classes[0]
            let level = firstClass["level"].int!
            let hitDie = firstClass["hitDie"].int!
            hdValue.text = String(appDelegate.character.currentHitDice)+"d"+String(hitDie)+"\n/"+String(level)+"d"+String(hitDie)
            break
            
        case 300:
            // Armor Class
            appDelegate.character.calcAC()
            acValue.text = String(appDelegate.character.AC)
            break
            
        case 400:
            // Proficiency Bonus
            profValue.text = String(appDelegate.character.proficiencyBonus)
            break
        
        case 500:
            // Strength
            self.setAbilityScores()
            break
            
        case 600:
            // Dexterity
            self.setAbilityScores()
            break
            
        case 700:
            // Constitution
            self.setAbilityScores()
            break
            
        case 800:
            // Intelligence
            self.setAbilityScores()
            break
            
        case 900:
            // Wisdom
            self.setAbilityScores()
            break
            
        case 1000:
            // Charisma
            self.setAbilityScores()
            break
            
        case 1100:
            // Initiative
            appDelegate.character.calcInitiative()
            if appDelegate.character.initiative < 0 {
                initValue.text = String(appDelegate.character.initiative)
            }
            else {
                initValue.text = "+"+String(appDelegate.character.initiative)
            }
            break
            
        case 1200:
            // Passive Perception
            appDelegate.character.calcPP()
            ppValue.text = String(appDelegate.character.passivePerception)
            break
            
        case 1300:
            // Speed
            for case let view in parentView.subviews {
                if view.tag == 1307 {
                    let segControl = view as! UISegmentedControl
                    if segControl.selectedSegmentIndex == 0 {
                        // Walk
                        speedTitle.text = "Walk"
                        speedValue.text = String(appDelegate.character.walkSpeed)
                    }
                    else if segControl.selectedSegmentIndex == 1 {
                        // Burrow
                        speedTitle.text = "Burrow"
                        speedValue.text = String(appDelegate.character.burrowSpeed)
                    }
                    else if segControl.selectedSegmentIndex == 2 {
                        // Climb
                        speedTitle.text = "Climb"
                        speedValue.text = String(appDelegate.character.climbSpeed)
                    }
                    else if segControl.selectedSegmentIndex == 3 {
                        // Fly
                        speedTitle.text = "Fly"
                        speedValue.text = String(appDelegate.character.flySpeed)
                    }
                    else if segControl.selectedSegmentIndex == 4 {
                        // Swim
                        speedTitle.text = "Swim"
                        speedValue.text = String(appDelegate.character.swimSpeed)
                    }
                }
            }
            
            break
            
        default:
            break
            
        }
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func segmentChanged(segControl: UISegmentedControl) {
        if segControl.tag == 105 {
            // HP Effect
            
        }
        else if segControl.tag == 314 {
            // Extra Ability Mod to AC
            let parentView:UIView = segControl.superview!
            for case let view in parentView.subviews {
                if view.tag == 313 {
                    
                    let textField = view as! UITextField
                    
                    switch segControl.selectedSegmentIndex {
                    case 0:
                        // NA
                        textField.text = "-"
                        appDelegate.character.hasAdditionalACMod = false
                        appDelegate.character.additionalACMod = ""
                        break
                    case 1:
                        // STR
                        textField.text = String(appDelegate.character.strBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "STR"
                        break
                    case 2:
                        // DEX
                        textField.text = String(appDelegate.character.dexBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "DEX"
                        break
                    case 3:
                        // CON
                        textField.text = String(appDelegate.character.conBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "CON"
                        break
                    case 4:
                        // INT
                        textField.text = String(appDelegate.character.intBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "INT"
                        break
                    case 5:
                        // WIS
                        textField.text = String(appDelegate.character.wisBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "WIS"
                        break
                    case 6:
                        // CHA
                        textField.text = String(appDelegate.character.chaBonus)
                        appDelegate.character.hasAdditionalACMod = true
                        appDelegate.character.additionalACMod = "CHA"
                        break
                    default:
                        break
                    }
                }
            }
            appDelegate.character.calcAC()
        }
        else if segControl.tag == 1307 {
            // Speed Type
            appDelegate.character.speedType = segControl.selectedSegmentIndex
            
            let parentView:UIView = segControl.superview!
            for case let view in parentView.subviews {
                switch segControl.selectedSegmentIndex {
                case 0:
                    // Walk
                    if view.tag == 1303 {
                        // Base Speed
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.walkSpeed)
                    }
                    else if view.tag == 1305 {
                        // Misc Bonus
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.walkSpeedMiscBonus)
                    }
                    break
                case 1:
                    // Burrow
                    if view.tag == 1303 {
                        // Base Speed
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.burrowSpeed)
                    }
                    else if view.tag == 1305 {
                        // Misc Bonus
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.burrowSpeedMiscBonus)
                    }
                    break
                case 2:
                    // Climb
                    if view.tag == 1303 {
                        // Base Speed
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.climbSpeed)
                    }
                    else if view.tag == 1305 {
                        // Misc Bonus
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.climbSpeedMiscBonus)
                    }
                    break
                case 3:
                    // Fly
                    if view.tag == 1303 {
                        // Base Speed
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.flySpeed)
                    }
                    else if view.tag == 1305 {
                        // Misc Bonus
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.flySpeedMiscBonus)
                    }
                    break
                case 4:
                    // Swim
                    if view.tag == 1303 {
                        // Base Speed
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.swimSpeed)
                    }
                    else if view.tag == 1305 {
                        // Misc Bonus
                        let textField = view as! UITextField
                        textField.text = String(appDelegate.character.swimSpeedMiscBonus)
                    }
                    break
                default: break
                }
            }
        }
    }
    
    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == 107 {
            // HP
            hpEffectValue = Int(stepper.value)
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
        else if stepper.tag == 219 {
            // Extra HD 1
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 212 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
        else if stepper.tag == 229 {
            // Extra HD 2
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 222 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
        else if stepper.tag == 239 {
            // Extra HD 3
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 232 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
    }
    
    func switchAction(sender: UISwitch) {
        if sender.tag == 211 {
            // Extra Hit Die 1
            
        }
        else if sender.tag == 221 {
            // Extra Hit Die 2
            
        }
        else if sender.tag == 231 {
            // Extra Hit Die 3
            
        }
        else if sender.tag == 504 {
            // Strength Save Proficiency
            
        }
        else if sender.tag == 604 {
            // Dexterity Save Proficiency
            
        }
        else if sender.tag == 704 {
            // Constitution Save Proficiency
            
        }
        else if sender.tag == 804 {
            // Intelligence Save Proficiency
            
        }
        else if sender.tag == 904 {
            // Wisdom Save Proficiency
        }
        else if sender.tag == 1004 {
            // Charisma Save Proficiency
        }
        else if sender.tag == 1109 {
            // Initiative Alert Feat
            
        }
        else if sender.tag == 1111 {
            // Initiative Half Proficiency
            
        }
        else if sender.tag == 1113 {
            // Initiative Round Up
            
        }
        else {
            // Skills
            
        }
    }
    
    // Edit HP
    @IBAction func hpAction(button: UIButton) {
        // Create hit point adjusting view
        let tempView = createBasicView()
        tempView.tag = 100
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "HP"
        title.textAlignment = NSTextAlignment.center
        title.tag = 101
        tempView.addSubview(title)
        
        let currentHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
        currentHP.text = String(appDelegate.character.currentHP)
        currentHP.textAlignment = NSTextAlignment.center
        currentHP.layer.borderWidth = 1.0
        currentHP.layer.borderColor = UIColor.black.cgColor
        currentHP.tag = 102
        currentHP.delegate = self
        tempView.addSubview(currentHP)
        
        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
        slash.text = "/"
        slash.textAlignment = NSTextAlignment.center
        slash.tag = 103
        tempView.addSubview(slash)
        
        let maxHP = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
        maxHP.text = String(appDelegate.character.maxHP)
        maxHP.textAlignment = NSTextAlignment.center
        maxHP.layer.borderWidth = 1.0
        maxHP.layer.borderColor = UIColor.black.cgColor
        maxHP.tag = 104
        maxHP.delegate = self
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
        effectValue.delegate = self
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
    
    // Edit Hit Dice
    @IBAction func hdAction(button: UIButton) {
        // Create hit dice adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Hit Dice"
        title.textAlignment = NSTextAlignment.center
        title.tag = 201
        scrollView.addSubview(title)
        
        let currentHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:35, width:40, height:30))
        currentHD.text = String(appDelegate.character.currentHitDice)
        currentHD.textAlignment = NSTextAlignment.center
        currentHD.layer.borderWidth = 1.0
        currentHD.layer.borderColor = UIColor.black.cgColor
        currentHD.tag = 202
        currentHD.delegate = self
        scrollView.addSubview(currentHD)
        
        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:35, width:30, height:30))
        d1.text = "d"
        d1.textAlignment = NSTextAlignment.center
        d1.tag = 203
        scrollView.addSubview(d1)
        
        let hd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
        hd1.text = String(appDelegate.character.hitDieType)
        hd1.textAlignment = NSTextAlignment.center
        hd1.isUserInteractionEnabled = false
        hd1.textColor = UIColor.darkGray
        hd1.layer.borderWidth = 1.0
        hd1.layer.borderColor = UIColor.darkGray.cgColor
        hd1.tag = 204
        scrollView.addSubview(hd1)
        
        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
        slash.text = "/"
        slash.textAlignment = NSTextAlignment.center
        slash.tag = 205
        scrollView.addSubview(slash)
        
        let maxHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
        maxHD.text = String(appDelegate.character.maxHitDice)
        maxHD.textAlignment = NSTextAlignment.center
        maxHD.layer.borderWidth = 1.0
        maxHD.layer.borderColor = UIColor.black.cgColor
        maxHD.tag = 206
        maxHD.delegate = self
        scrollView.addSubview(maxHD)
        
        let d2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:35, width:30, height:30))
        d2.text = "d"
        d2.textAlignment = NSTextAlignment.center
        d2.tag = 207
        scrollView.addSubview(d2)
        
        let hd2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:35, width:40, height:30))
        hd2.text = String(appDelegate.character.hitDieType)
        hd2.textAlignment = NSTextAlignment.center
        hd2.layer.borderWidth = 1.0
        hd2.layer.borderColor = UIColor.black.cgColor
        hd2.tag = 208
        hd2.delegate = self
        scrollView.addSubview(hd2)
        
        let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:75, width:94, height:29))
        stepper.value = Double(appDelegate.character.currentHitDice)
        stepper.minimumValue = 0
        stepper.maximumValue = Double(appDelegate.character.maxHitDice)
        stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        stepper.tag = 209
        scrollView.addSubview(stepper)
        
        let extraHitDie1 = UILabel.init(frame: CGRect.init(x:10, y:115, width:120, height:30))
        extraHitDie1.text = "Extra Hit Dice"
        extraHitDie1.tag = 210
        scrollView.addSubview(extraHitDie1)
        
        let extraHitDie1Switch = UISwitch.init(frame: CGRect.init(x:135, y:115, width:51, height:31))
        extraHitDie1Switch.isOn = appDelegate.character.hasExtraHitDie1
        extraHitDie1Switch.addTarget(self, action: #selector(self.switchAction), for: UIControlEvents.valueChanged)
        extraHitDie1Switch.tag = 211
        scrollView.addSubview(extraHitDie1Switch)
        
        let extra1CurrentHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:40, height:30))
        extra1CurrentHD.text = String(appDelegate.character.extra1CurrentHitDice)
        extra1CurrentHD.textAlignment = NSTextAlignment.center
        extra1CurrentHD.layer.borderWidth = 1.0
        extra1CurrentHD.layer.borderColor = UIColor.black.cgColor
        extra1CurrentHD.tag = 212
        extra1CurrentHD.delegate = self
        scrollView.addSubview(extra1CurrentHD)
        
        let extra1D1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:155, width:30, height:30))
        extra1D1.text = "d"
        extra1D1.textAlignment = NSTextAlignment.center
        extra1D1.tag = 213
        scrollView.addSubview(extra1D1)
        
        let extra1HD1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:155, width:40, height:30))
        extra1HD1.text = String(appDelegate.character.extra1HitDieType)
        extra1HD1.textAlignment = NSTextAlignment.center
        extra1HD1.isUserInteractionEnabled = false
        extra1HD1.textColor = UIColor.darkGray
        extra1HD1.layer.borderWidth = 1.0
        extra1HD1.layer.borderColor = UIColor.darkGray.cgColor
        extra1HD1.tag = 214
        scrollView.addSubview(extra1HD1)
        
        let extra1Slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:155, width:30, height:30))
        extra1Slash.text = "/"
        extra1Slash.textAlignment = NSTextAlignment.center
        extra1Slash.tag = 215
        scrollView.addSubview(extra1Slash)
        
        let extra1MaxHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:155, width:40, height:30))
        extra1MaxHD.text = String(appDelegate.character.extra1MaxHitDice)
        extra1MaxHD.textAlignment = NSTextAlignment.center
        extra1MaxHD.layer.borderWidth = 1.0
        extra1MaxHD.layer.borderColor = UIColor.black.cgColor
        extra1MaxHD.tag = 216
        extra1MaxHD.delegate = self
        scrollView.addSubview(extra1MaxHD)
        
        let extra1D2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:155, width:30, height:30))
        extra1D2.text = "d"
        extra1D2.textAlignment = NSTextAlignment.center
        extra1D2.tag = 217
        scrollView.addSubview(extra1D2)
        
        let extra1HD2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:155, width:40, height:30))
        extra1HD2.text = String(appDelegate.character.extra1HitDieType)
        extra1HD2.textAlignment = NSTextAlignment.center
        extra1HD2.layer.borderWidth = 1.0
        extra1HD2.layer.borderColor = UIColor.black.cgColor
        extra1HD2.tag = 218
        extra1HD2.delegate = self
        scrollView.addSubview(extra1HD2)
        
        let extra1Stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:190, width:94, height:29))
        extra1Stepper.value = Double(appDelegate.character.extra1CurrentHitDice)
        extra1Stepper.minimumValue = 0
        extra1Stepper.maximumValue = Double(appDelegate.character.extra1MaxHitDice)
        extra1Stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        extra1Stepper.tag = 219
        scrollView.addSubview(extra1Stepper)
        
        let extraHitDie2 = UILabel.init(frame: CGRect.init(x:10, y:230, width:120, height:30))
        extraHitDie2.text = "Extra Hit Dice 2"
        extraHitDie2.tag = 220
        scrollView.addSubview(extraHitDie2)
        
        let extraHitDie2Switch = UISwitch.init(frame: CGRect.init(x:135, y:230, width:51, height:31))
        extraHitDie2Switch.isOn = appDelegate.character.hasExtraHitDie1
        extraHitDie2Switch.addTarget(self, action: #selector(self.switchAction), for: UIControlEvents.valueChanged)
        extraHitDie2Switch.tag = 221
        scrollView.addSubview(extraHitDie2Switch)
        
        let extra2CurrentHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:265, width:40, height:30))
        extra2CurrentHD.text = String(appDelegate.character.extra1CurrentHitDice)
        extra2CurrentHD.textAlignment = NSTextAlignment.center
        extra2CurrentHD.layer.borderWidth = 1.0
        extra2CurrentHD.layer.borderColor = UIColor.black.cgColor
        extra2CurrentHD.tag = 222
        extra2CurrentHD.delegate = self
        scrollView.addSubview(extra2CurrentHD)
        
        let extra2D1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:265, width:30, height:30))
        extra2D1.text = "d"
        extra2D1.textAlignment = NSTextAlignment.center
        extra2D1.tag = 223
        scrollView.addSubview(extra2D1)
        
        let extra2HD1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:265, width:40, height:30))
        extra2HD1.text = String(appDelegate.character.extra1HitDieType)
        extra2HD1.textAlignment = NSTextAlignment.center
        extra2HD1.isUserInteractionEnabled = false
        extra2HD1.textColor = UIColor.darkGray
        extra2HD1.layer.borderWidth = 1.0
        extra2HD1.layer.borderColor = UIColor.darkGray.cgColor
        extra2HD1.tag = 224
        scrollView.addSubview(extra2HD1)
        
        let extra2Slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:265, width:30, height:30))
        extra2Slash.text = "/"
        extra2Slash.textAlignment = NSTextAlignment.center
        extra2Slash.tag = 225
        scrollView.addSubview(extra2Slash)
        
        let extra2MaxHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:265, width:40, height:30))
        extra2MaxHD.text = String(appDelegate.character.extra1MaxHitDice)
        extra2MaxHD.textAlignment = NSTextAlignment.center
        extra2MaxHD.layer.borderWidth = 1.0
        extra2MaxHD.layer.borderColor = UIColor.black.cgColor
        extra2MaxHD.tag = 226
        extra2MaxHD.delegate = self
        scrollView.addSubview(extra2MaxHD)
        
        let extra2D2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:265, width:30, height:30))
        extra2D2.text = "d"
        extra2D2.textAlignment = NSTextAlignment.center
        extra2D2.tag = 227
        scrollView.addSubview(extra2D2)
        
        let extra2HD2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:265, width:40, height:30))
        extra2HD2.text = String(appDelegate.character.extra1HitDieType)
        extra2HD2.textAlignment = NSTextAlignment.center
        extra2HD2.layer.borderWidth = 1.0
        extra2HD2.layer.borderColor = UIColor.black.cgColor
        extra2HD2.tag = 228
        extra2HD2.delegate = self
        scrollView.addSubview(extra2HD2)
        
        let extra2Stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:300, width:94, height:29))
        extra2Stepper.value = Double(appDelegate.character.extra1CurrentHitDice)
        extra2Stepper.minimumValue = 0
        extra2Stepper.maximumValue = Double(appDelegate.character.extra1MaxHitDice)
        extra2Stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        extra2Stepper.tag = 229
        scrollView.addSubview(extra2Stepper)
        
        let extraHitDie3 = UILabel.init(frame: CGRect.init(x:10, y:340, width:120, height:30))
        extraHitDie3.text = "Extra Hit Dice 3"
        extraHitDie3.tag = 230
        scrollView.addSubview(extraHitDie3)
        
        let extraHitDie3Switch = UISwitch.init(frame: CGRect.init(x:135, y:340, width:51, height:31))
        extraHitDie3Switch.isOn = appDelegate.character.hasExtraHitDie1
        extraHitDie3Switch.addTarget(self, action: #selector(self.switchAction), for: UIControlEvents.valueChanged)
        extraHitDie3Switch.tag = 231
        scrollView.addSubview(extraHitDie3Switch)
        
        let extra3CurrentHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:375, width:40, height:30))
        extra3CurrentHD.text = String(appDelegate.character.extra1CurrentHitDice)
        extra3CurrentHD.textAlignment = NSTextAlignment.center
        extra3CurrentHD.layer.borderWidth = 1.0
        extra3CurrentHD.layer.borderColor = UIColor.black.cgColor
        extra3CurrentHD.tag = 232
        extra3CurrentHD.delegate = self
        scrollView.addSubview(extra3CurrentHD)
        
        let extra3D1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:375, width:30, height:30))
        extra3D1.text = "d"
        extra3D1.textAlignment = NSTextAlignment.center
        extra3D1.tag = 233
        scrollView.addSubview(extra3D1)
        
        let extra3HD1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:375, width:40, height:30))
        extra3HD1.text = String(appDelegate.character.extra1HitDieType)
        extra3HD1.textAlignment = NSTextAlignment.center
        extra3HD1.isUserInteractionEnabled = false
        extra3HD1.textColor = UIColor.darkGray
        extra3HD1.layer.borderWidth = 1.0
        extra3HD1.layer.borderColor = UIColor.darkGray.cgColor
        extra3HD1.tag = 234
        scrollView.addSubview(extra3HD1)
        
        let extra3Slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:375, width:30, height:30))
        extra3Slash.text = "/"
        extra3Slash.textAlignment = NSTextAlignment.center
        extra3Slash.tag = 235
        scrollView.addSubview(extra3Slash)
        
        let extra3MaxHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:375, width:40, height:30))
        extra3MaxHD.text = String(appDelegate.character.extra1MaxHitDice)
        extra3MaxHD.textAlignment = NSTextAlignment.center
        extra3MaxHD.layer.borderWidth = 1.0
        extra3MaxHD.layer.borderColor = UIColor.black.cgColor
        extra3MaxHD.tag = 236
        extra3MaxHD.delegate = self
        scrollView.addSubview(extra3MaxHD)
        
        let extra3D2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:375, width:30, height:30))
        extra3D2.text = "d"
        extra3D2.textAlignment = NSTextAlignment.center
        extra3D2.tag = 237
        scrollView.addSubview(extra3D2)
        
        let extra3HD2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:375, width:40, height:30))
        extra3HD2.text = String(appDelegate.character.extra1HitDieType)
        extra3HD2.textAlignment = NSTextAlignment.center
        extra3HD2.layer.borderWidth = 1.0
        extra3HD2.layer.borderColor = UIColor.black.cgColor
        extra3HD2.tag = 238
        extra3HD2.delegate = self
        scrollView.addSubview(extra3HD2)
        
        let extra3Stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:410, width:94, height:29))
        extra3Stepper.value = Double(appDelegate.character.extra1CurrentHitDice)
        extra3Stepper.minimumValue = 0
        extra3Stepper.maximumValue = Double(appDelegate.character.extra1MaxHitDice)
        extra3Stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        extra3Stepper.tag = 239
        scrollView.addSubview(extra3Stepper)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 450)
        
        view.addSubview(tempView)
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        // Create armor class adjusting view
        let tempView = createBasicView()
        tempView.tag = 300
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
        tempView.addSubview(scrollView)
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Armor Class"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        scrollView.addSubview(title)
        
        // Armor value
        let armorValueLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 30, width: 40, height: 30))
        armorValueLabel.text = "Armor\nValue"
        armorValueLabel.font = UIFont.systemFont(ofSize: 10)
        armorValueLabel.textAlignment = NSTextAlignment.center
        armorValueLabel.numberOfLines = 2
        armorValueLabel.tag = 302
        scrollView.addSubview(armorValueLabel)
        
        let armorValueField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:55, width:40, height:30))
        armorValueField.text = String(10)
        armorValueField.textAlignment = NSTextAlignment.center
        armorValueField.layer.borderWidth = 1.0
        armorValueField.layer.borderColor = UIColor.darkGray.cgColor
        armorValueField.textColor = UIColor.darkGray
        armorValueField.isEnabled = false
        armorValueField.tag = 303
        scrollView.addSubview(armorValueField)
        
        // Dex bonus
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-70, y: 30, width: 40, height: 30))
        dexLabel.text = "Dex\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 304
        scrollView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-70, y:55, width:40, height:30))
        dexField.text = String(appDelegate.character.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.darkGray.cgColor
        dexField.textColor = UIColor.darkGray
        dexField.isEnabled = false
        dexField.tag = 305
        scrollView.addSubview(dexField)
        
        // Shield Value
        let shieldLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-20, y: 30, width: 40, height: 30))
        shieldLabel.text = "Shield\nValue"
        shieldLabel.font = UIFont.systemFont(ofSize: 10)
        shieldLabel.textAlignment = NSTextAlignment.center
        shieldLabel.numberOfLines = 2
        shieldLabel.tag = 306
        scrollView.addSubview(shieldLabel)
        
        let shieldField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:55, width:40, height:30))
        shieldField.text = String(0)
        shieldField.textAlignment = NSTextAlignment.center
        shieldField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        shieldField.tag = 307
        scrollView.addSubview(shieldField)
        
        // Max Dex
        let maxDexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+30, y: 30, width: 40, height: 30))
        maxDexLabel.text = "Max\nDex"
        maxDexLabel.font = UIFont.systemFont(ofSize: 10)
        maxDexLabel.textAlignment = NSTextAlignment.center
        maxDexLabel.numberOfLines = 2
        maxDexLabel.tag = 308
        scrollView.addSubview(maxDexLabel)
        
        let maxDexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+30, y:55, width:40, height:30))
        maxDexField.text = "-"
        maxDexField.textAlignment = NSTextAlignment.center
        maxDexField.layer.borderWidth = 1.0
        shieldField.layer.borderColor = UIColor.darkGray.cgColor
        shieldField.textColor = UIColor.darkGray
        shieldField.isEnabled = false
        maxDexField.tag = 309
        scrollView.addSubview(maxDexField)
        
        // Misc Mod
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+80, y: 30, width: 40, height: 30))
        miscLabel.text = "Misc\nValue"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 310
        scrollView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:55, width:40, height:30))
        miscField.text = String(appDelegate.character.ACMiscBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 311
        scrollView.addSubview(miscField)
        
        //Additional Ability Mod (Monk/Barb)
        let addAbilityLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-120, y: 90, width: 90, height: 30))
        addAbilityLabel.text = "Additional Mod"
        addAbilityLabel.font = UIFont.systemFont(ofSize: 10)
        addAbilityLabel.tag = 312
        scrollView.addSubview(addAbilityLabel)
        
        let addAbilityField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:90, width:40, height:30))
        addAbilityField.text = String(0)
        addAbilityField.textAlignment = NSTextAlignment.center
        addAbilityField.layer.borderWidth = 1.0
        addAbilityField.layer.borderColor = UIColor.darkGray.cgColor
        addAbilityField.textColor = UIColor.darkGray
        addAbilityField.isEnabled = false
        addAbilityField.tag = 313
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
        addAbilitySeg.tag = 314
        scrollView.addSubview(addAbilitySeg)
        
        let armorTable = UITableView.init(frame: CGRect.init(x:10, y:170, width:tempView.frame.size.width-20, height:80))
        armorTable.tag = 315
        armorTable.delegate = self
        armorTable.dataSource = self
        scrollView.addSubview(armorTable)
        
        scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 260)
        
        let allArmor = appDelegate.character.equipment["armor"]
        for armor in allArmor.array! {
            if armor["equipped"] == true {
                if armor["shield"] == true {
                    let shieldValue = armor["value"].int! + armor["magic_bonus"].int! + armor["misc_bonus"].int!
                    shieldField.text = String(shieldValue)
                }
                else {
                    let armorValue = armor["value"].int! + armor["magic_bonus"].int! + armor["misc_bonus"].int!
                    armorValueField.text = String(armorValue)
                    let maxDex = armor["max_dex"].int!
                    if maxDex == 0 {
                        maxDexField.text = "-"
                    }
                    else {
                        maxDexField.text = String(maxDex)
                    }
                }
            }
        }
        
        if appDelegate.character.hasAdditionalACMod == true {
            switch appDelegate.character.additionalACMod {
            case "STR":
                addAbilitySeg.selectedSegmentIndex = 1
                addAbilityField.text = String(appDelegate.character.strBonus)
            case "DEX":
                addAbilitySeg.selectedSegmentIndex = 2
                addAbilityField.text = String(appDelegate.character.dexBonus)
            case "CON":
                addAbilitySeg.selectedSegmentIndex = 3
                addAbilityField.text = String(appDelegate.character.conBonus)
            case "INT":
                addAbilitySeg.selectedSegmentIndex = 4
                addAbilityField.text = String(appDelegate.character.intBonus)
            case "WIS":
                addAbilitySeg.selectedSegmentIndex = 5
                addAbilityField.text = String(appDelegate.character.wisBonus)
            case "CHA":
                addAbilitySeg.selectedSegmentIndex = 6
                addAbilityField.text = String(appDelegate.character.chaBonus)
            default: break
            }
        }
        else {
            addAbilitySeg.selectedSegmentIndex = 0
            addAbilityField.text = "-"
        }
        
        view.addSubview(tempView)
    }
    
    // Edit Proficiency Bonus
    @IBAction func profAction(button: UIButton) {
        // Create proficiency bonus adjusting view
        let tempView = createBasicView()
        tempView.tag = 400
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Proficiency Bonus"
        title.textAlignment = NSTextAlignment.center
        title.tag = 401
        tempView.addSubview(title)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        profField.text = String(appDelegate.character.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.black.cgColor
        profField.tag = 402
        profField.delegate = self
        tempView.addSubview(profField)
        
        view.addSubview(tempView)
    }
    
    // Edit Strength Score
    @IBAction func strAction(button: UIButton) {
        // Create strength adjusting view
        let tempView = createBasicView()
        tempView.tag = 500
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Strength"
        title.textAlignment = NSTextAlignment.center
        title.tag = 501
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.strScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 502
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 503
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("STR") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.addTarget(self, action: #selector(self.switchAction), for: UIControlEvents.valueChanged)
        proficientSwitch.tag = 504
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Dexterity Score
    @IBAction func dexAction(button: UIButton) {
        // Create dexterity adjusting view
        let tempView = createBasicView()
        tempView.tag = 600
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Dexterity"
        title.textAlignment = NSTextAlignment.center
        title.tag = 601
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.dexScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 602
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 603
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("DEX") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.tag = 604
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Constitution Score
    @IBAction func conAction(button: UIButton) {
        // Create constitution adjusting view
        let tempView = createBasicView()
        tempView.tag = 700
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Constitution"
        title.textAlignment = NSTextAlignment.center
        title.tag = 701
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.conScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 702
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 703
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("CON") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.tag = 704
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Intelligence Score
    @IBAction func intAction(button: UIButton) {
        // Create intelligence adjusting view
        let tempView = createBasicView()
        tempView.tag = 800
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Intelligence"
        title.textAlignment = NSTextAlignment.center
        title.tag = 801
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.intScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 802
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 803
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("INT") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.tag = 804
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Wisdom Score
    @IBAction func wisAction(button: UIButton) {
        // Create wisdom adjusting view
        let tempView = createBasicView()
        tempView.tag = 900
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Wisdom"
        title.textAlignment = NSTextAlignment.center
        title.tag = 901
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.wisScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 902
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 903
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("WIS") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.tag = 904
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Charisma Score
    @IBAction func chaAction(button: UIButton) {
        // Create charisma adjusting view
        let tempView = createBasicView()
        tempView.tag = 1000
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Charisma"
        title.textAlignment = NSTextAlignment.center
        title.tag = 1001
        tempView.addSubview(title)
        
        let scoreField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        scoreField.text = String(appDelegate.character.chaScore)
        scoreField.textAlignment = NSTextAlignment.center
        scoreField.layer.borderWidth = 1.0
        scoreField.layer.borderColor = UIColor.black.cgColor
        scoreField.tag = 1002
        scoreField.delegate = self
        tempView.addSubview(scoreField)
        
        let proficientLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:90, width:120, height:30))
        proficientLabel.text = "Save Proficient"
        proficientLabel.textAlignment = NSTextAlignment.right
        proficientLabel.tag = 1003
        tempView.addSubview(proficientLabel)
        
        let proficientSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:90, width:51, height:31))
        if appDelegate.character.saveProficiencies.arrayValue.contains("CHA") {
            proficientSwitch.isOn = true
        }
        else {
            proficientSwitch.isOn = false
        }
        proficientSwitch.tag = 1004
        tempView.addSubview(proficientSwitch)
        
        view.addSubview(tempView)
    }
    
    // Edit Initiative
    @IBAction func initAction(button: UIButton) {
        // Create initiative adjusting view
        let tempView = createBasicView()
        tempView.tag = 1100
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = "Initiative"
        title.textAlignment = NSTextAlignment.center
        title.tag = 1101
        tempView.addSubview(title)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-105, y: 25, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = 1102
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
        profField.text = String(appDelegate.character.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 1103
        tempView.addSubview(profField)
        
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
        dexLabel.text = "Dexterity\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 1104
        tempView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        dexField.text = String(appDelegate.character.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.isEnabled = false
        dexField.textColor = UIColor.darkGray
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.darkGray.cgColor
        dexField.tag = 1105
        tempView.addSubview(dexField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 1106
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
        miscField.text = String(appDelegate.character.initiativeMiscBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 1107
        miscField.delegate = self
        tempView.addSubview(miscField)
        
        let alertLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:85, width:120, height:30))
        alertLabel.text = "Alert Feat"
        alertLabel.textAlignment = NSTextAlignment.right
        alertLabel.tag = 1108
        tempView.addSubview(alertLabel)
        
        let alertSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
        alertSwitch.isOn = appDelegate.character.alertFeat
        alertSwitch.tag = 1109
        tempView.addSubview(alertSwitch)
        
        let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
        halfProfLabel.text = "Half Proficiency"
        halfProfLabel.textAlignment = NSTextAlignment.right
        halfProfLabel.tag = 1110
        tempView.addSubview(halfProfLabel)
        
        let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
        halfProfSwitch.isOn = appDelegate.character.halfProfOnInitiative
        halfProfSwitch.tag = 1111
        tempView.addSubview(halfProfSwitch)
        
        let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
        roundUpLabel.text = "Round Up"
        roundUpLabel.textAlignment = NSTextAlignment.right
        roundUpLabel.tag = 1112
        tempView.addSubview(roundUpLabel)
        
        let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
        roundUpSwitch.isOn = appDelegate.character.roundUpOnInitiative
        roundUpSwitch.tag = 1113
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
    
    // Edit Passive Perception
    @IBAction func ppAction(button: UIButton) {
        // Create passive perception adjusting view
        let tempView = createBasicView()
        tempView.tag = 1200
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Passive Perception"
        title.textAlignment = NSTextAlignment.center
        title.tag = 1201
        tempView.addSubview(title)
        
        let passiveLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-40, y:50, width:40, height:30))
        passiveLabel.text = "10"
        passiveLabel.font = UIFont.boldSystemFont(ofSize: 17)
        passiveLabel.textAlignment = NSTextAlignment.center
        passiveLabel.tag = 1202
        tempView.addSubview(passiveLabel)
        
        let plusLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        plusLabel.text = "+"
        plusLabel.font = UIFont.boldSystemFont(ofSize: 17)
        plusLabel.textAlignment = NSTextAlignment.center
        plusLabel.tag = 1202
        tempView.addSubview(plusLabel)
        
        var perceptionSkill = [:] as JSON
        for case let skill in appDelegate.character.skills.array! {
            let skillName = skill["skill"].string!
            if skillName == "Perception" {
                perceptionSkill = skill
            }
        }
        
        let attribute = perceptionSkill["attribute"].string!
        var skillValue = 0
        switch attribute {
        case "STR":
            skillValue += appDelegate.character.strBonus
        case "DEX":
            skillValue += appDelegate.character.dexBonus
        case "CON":
            skillValue += appDelegate.character.conBonus
        case "INT":
            skillValue += appDelegate.character.intBonus
        case "WIS":
            skillValue += appDelegate.character.wisBonus
        case "CHA":
            skillValue += appDelegate.character.chaBonus
        default: break
        }
        
        let isProficient = perceptionSkill["proficient"].bool!
        if isProficient {
            skillValue += appDelegate.character.proficiencyBonus
        }
        
        let percField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:50, width:40, height:30))
        percField.text = String(skillValue)
        percField.textAlignment = NSTextAlignment.center
        percField.isEnabled = false
        percField.textColor = UIColor.darkGray
        percField.layer.borderWidth = 1.0
        percField.layer.borderColor = UIColor.darkGray.cgColor
        percField.tag = 1203
        tempView.addSubview(percField)
        
        view.addSubview(tempView)
    }
    
    // Edit Speed
    @IBAction func speedAction(button: UIButton) {
        // Create speed adjusting view
        let tempView = createBasicView()
        tempView.tag = 1300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Speed"
        title.textAlignment = NSTextAlignment.center
        title.tag = 1301
        tempView.addSubview(title)
        
        let baseLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-85, y: 35, width: 90, height: 30))
        baseLabel.text = "Base\nValue"
        baseLabel.font = UIFont.systemFont(ofSize: 10)
        baseLabel.textAlignment = NSTextAlignment.center
        baseLabel.numberOfLines = 2
        baseLabel.tag = 1302
        tempView.addSubview(baseLabel)
        
        let baseField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:65, width:40, height:30))
        baseField.textAlignment = NSTextAlignment.center
        baseField.layer.borderWidth = 1.0
        baseField.layer.borderColor = UIColor.black.cgColor
        baseField.tag = 1303
        baseField.delegate = self
        tempView.addSubview(baseField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-5, y: 35, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 1304
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:65, width:40, height:30))
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 1305
        miscField.delegate = self
        tempView.addSubview(miscField)
        
        switch appDelegate.character.speedType {
        case 0:
            // Walk
            baseField.text = String(appDelegate.character.walkSpeed)
            miscField.text = String(appDelegate.character.walkSpeedMiscBonus)
            break
        case 1:
            // Burrow
            baseField.text = String(appDelegate.character.burrowSpeed)
            miscField.text = String(appDelegate.character.burrowSpeedMiscBonus)
            break
        case 2:
            // Climb
            baseField.text = String(appDelegate.character.climbSpeed)
            miscField.text = String(appDelegate.character.climbSpeedMiscBonus)
            break
        case 3:
            // Fly
            baseField.text = String(appDelegate.character.flySpeed)
            miscField.text = String(appDelegate.character.flySpeedMiscBonus)
            break
        case 4:
            // Swim
            baseField.text = String(appDelegate.character.swimSpeed)
            miscField.text = String(appDelegate.character.swimSpeedMiscBonus)
            break
        default: break
        }
        
        let movementLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        movementLabel.text = "Movement Type"
        movementLabel.textAlignment = NSTextAlignment.center
        movementLabel.tag = 1306
        tempView.addSubview(movementLabel)
        
        let movementType = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        movementType.insertSegment(withTitle:"Walk", at:0, animated:false)
        movementType.insertSegment(withTitle:"Burrow", at:1, animated:false)
        movementType.insertSegment(withTitle:"Climb", at:2, animated:false)
        movementType.insertSegment(withTitle:"Fly", at:3, animated:false)
        movementType.insertSegment(withTitle:"Swim", at:4, animated:false)
        movementType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        movementType.selectedSegmentIndex = appDelegate.character.speedType
        movementType.tag = 1307
        tempView.addSubview(movementType)
        
        view.addSubview(tempView)
    }
    
    func mcAction(sender: UIButton) {
        let parentView = sender.superview as! UIScrollView
        
        let selectedIndex = 0
        let yOffset = sender.frame.origin.y
        let classPickerView = UIPickerView.init(frame: CGRect.init(x:5, y:yOffset, width:parentView.frame.size.width/2-10, height:40))
        classPickerView.dataSource = self
        classPickerView.delegate = self
        classPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        classPickerView.layer.borderWidth = 1.0
        classPickerView.layer.borderColor = UIColor.black.cgColor
        classPickerView.tag = 26
        parentView.addSubview(classPickerView)
        
        let levelTextField = UIPickerView.init(frame: CGRect.init(x:parentView.frame.size.width/2+5, y:yOffset, width:parentView.frame.size.width/2-10, height:40))
        levelTextField.dataSource = self
        levelTextField.delegate = self
        levelTextField.selectRow(selectedIndex, inComponent: 0, animated: false)
        levelTextField.layer.borderWidth = 1.0
        levelTextField.layer.borderColor = UIColor.black.cgColor
        levelTextField.tag = 27
        parentView.addSubview(levelTextField)
        
        sender.frame = CGRect.init(x:5, y:yOffset+45, width:parentView.frame.size.width/2-10, height:30)
        
        parentView.contentSize = CGSize.init(width: parentView.frame.size.width, height: sender.frame.origin.y+40)
    }
    
    func alignmentAction(sender: UIButton) {
        
        var lgBtn = UIButton.init(type: UIButtonType.custom)
        var ngBtn = UIButton.init(type: UIButtonType.custom)
        var cgBtn = UIButton.init(type: UIButtonType.custom)
        var lnBtn = UIButton.init(type: UIButtonType.custom)
        var tnBtn = UIButton.init(type: UIButtonType.custom)
        var cnBtn = UIButton.init(type: UIButtonType.custom)
        var leBtn = UIButton.init(type: UIButtonType.custom)
        var neBtn = UIButton.init(type: UIButtonType.custom)
        var ceBtn = UIButton.init(type: UIButtonType.custom)
        
        let parentView = sender.superview
        for case let view in (parentView?.subviews)! {
            if view.tag == 42 {
                lgBtn = view as! UIButton
            }
            else if view.tag == 43 {
                ngBtn = view as! UIButton
            }
            else if view.tag == 44 {
                cgBtn = view as! UIButton
            }
            else if view.tag == 45 {
                lnBtn = view as! UIButton
            }
            else if view.tag == 46 {
                tnBtn = view as! UIButton
            }
            else if view.tag == 47 {
                cnBtn = view as! UIButton
            }
            else if view.tag == 48 {
                leBtn = view as! UIButton
            }
            else if view.tag == 49 {
                neBtn = view as! UIButton
            }
            else if view.tag == 50 {
                ceBtn = view as! UIButton
            }
        }
        
        if sender.tag == 42 {
            // LG
            lgBtn.isSelected = true
            lgBtn.backgroundColor = UIColor.black
            lgBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 43 {
            // NG
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = true
            ngBtn.backgroundColor = UIColor.black
            ngBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 44 {
            // CG
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = true
            cgBtn.backgroundColor = UIColor.black
            cgBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 45 {
            // LN
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = true
            lnBtn.backgroundColor = UIColor.black
            lnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 46 {
            // TN
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = true
            tnBtn.backgroundColor = UIColor.black
            tnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 47 {
            // CN
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = true
            cnBtn.backgroundColor = UIColor.black
            cnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        if sender.tag == 48 {
            // LE
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = true
            leBtn.backgroundColor = UIColor.black
            leBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 49 {
            // NE
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = true
            neBtn.backgroundColor = UIColor.black
            neBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            ceBtn.isSelected = false
            ceBtn.backgroundColor = UIColor.white
            ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        else if sender.tag == 50 {
            // CE
            lgBtn.isSelected = false
            lgBtn.backgroundColor = UIColor.white
            lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ngBtn.isSelected = false
            ngBtn.backgroundColor = UIColor.white
            ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cgBtn.isSelected = false
            cgBtn.backgroundColor = UIColor.white
            cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            lnBtn.isSelected = false
            lnBtn.backgroundColor = UIColor.white
            lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            tnBtn.isSelected = false
            tnBtn.backgroundColor = UIColor.white
            tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            cnBtn.isSelected = false
            cnBtn.backgroundColor = UIColor.white
            cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            leBtn.isSelected = false
            leBtn.backgroundColor = UIColor.white
            leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            neBtn.isSelected = false
            neBtn.backgroundColor = UIColor.white
            neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            ceBtn.isSelected = true
            ceBtn.backgroundColor = UIColor.black
            ceBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    }
    
    // UITableView Delegate & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 315 {
            return appDelegate.character.equipment["armor"].count
        }
        else {
            return appDelegate.character.skills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 315 {
            let cell = skillsTable.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as! SkillTableViewCell
            
            let armor = appDelegate.character.equipment["armor"][indexPath.row]
            
            var armorValue: Int = armor["value"].int!
            armorValue = armorValue + armor["magic_bonus"].int!
            armorValue = armorValue + armor["misc_bonus"].int!
            
            if armor["equipped"] == true {
                cell.skillName.textColor = UIColor.green
                cell.skillValue.textColor = UIColor.green
            }
            
            if armor["str_requirement"].int! > appDelegate.character.strScore {
                cell.skillName.textColor = UIColor.red
                cell.skillValue.textColor = UIColor.red
            }
            
            cell.skillName.text = armor["name"].string
            if armor["mod"] == "" {
                cell.skillValue.text = String(armorValue)
            }
            else {
                cell.skillValue.text = String(armorValue) + " + " + armor["mod"].string!
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillTableViewCell", for: indexPath) as! SkillTableViewCell
            
            let skill: JSON = appDelegate.character.skills[indexPath.row] 
            let skillName = skill["skill"].string!
            
            let attribute = skill["attribute"].string!
            var skillValue = 0
            switch attribute {
            case "STR":
                skillValue += appDelegate.character.strBonus
            case "DEX":
                skillValue += appDelegate.character.dexBonus
            case "CON":
                skillValue += appDelegate.character.conBonus
            case "INT":
                skillValue += appDelegate.character.intBonus
            case "WIS":
                skillValue += appDelegate.character.wisBonus
            case "CHA":
                skillValue += appDelegate.character.chaBonus
            default: break
            }
            
            let isProficient = skill["proficient"].bool!
            if isProficient {
                skillValue += appDelegate.character.proficiencyBonus
            }

            cell.skillName.text = skillName+"("+attribute+")"
            if skillValue < 0 {
                cell.skillValue.text = String(skillValue)
            }
            else {
                cell.skillValue.text = "+"+String(skillValue)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit selected skill value
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 315 {
            // Select a new armor to equip
            var armor = appDelegate.character.equipment["armor"][indexPath.row]
            armor["equipped"].bool = !armor["equipped"].boolValue
            appDelegate.character.equipment["armor"][indexPath.row] = armor
            
            let parentView:UIView = tableView.superview!
            for case let view in parentView.subviews {
                if armor["shield"] == true {
                    if view.tag == 307 {
                        // Shield Value
                        let textField = view as! UITextField
                        if armor["equipped"] == true {
                            textField.text = String(armor["value"].int!)
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
                        if armor["equipped"] == true {
                            textField.text = String(armor["value"].int!)
                        }
                        else {
                            textField.text = String(10)
                        }
                    }
                    else if view.tag == 309 {
                        // Max Dex
                        let textField = view as! UITextField
                        if armor["equipped"] == true {
                            textField.text = String(armor["max_dex"].int!)
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
            let tag = 1400+(100*indexPath.row)
            
            let skill: JSON = appDelegate.character.skills[indexPath.row]
            let skillName = skill["skill"].string!
            
            let attribute = skill["attribute"].string!
            var attributeDisplay = ""
            var attributeValue = 0
            switch attribute {
            case "STR":
                attributeDisplay = "Strength"
                attributeValue += appDelegate.character.strBonus
            case "DEX":
                attributeDisplay = "Dexterity"
                attributeValue += appDelegate.character.dexBonus
            case "CON":
                attributeDisplay = "Constitution"
                attributeValue += appDelegate.character.conBonus
            case "INT":
                attributeDisplay = "Intelligence"
                attributeValue += appDelegate.character.intBonus
            case "WIS":
                attributeDisplay = "Wisdom"
                attributeValue += appDelegate.character.wisBonus
            case "CHA":
                attributeDisplay = "Charisma"
                attributeValue += appDelegate.character.chaBonus
            default: break
            }
            
            var profValue = 0
            let isProficient = skill["proficient"].bool!
            if isProficient {
                profValue += appDelegate.character.proficiencyBonus
            }
            
            // Create skill adjusting view
            let tempView = createBasicView()
            tempView.tag = tag
            
            let title = UILabel.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
            title.text = skillName
            title.textAlignment = NSTextAlignment.center
            title.tag = tag+1
            tempView.addSubview(title)
            
            let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-105, y: 25, width: 90, height: 30))
            profLabel.text = "Proficiency\nBonus"
            profLabel.font = UIFont.systemFont(ofSize: 10)
            profLabel.textAlignment = NSTextAlignment.center
            profLabel.numberOfLines = 2
            profLabel.tag = tag+2
            tempView.addSubview(profLabel)
            
            let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
            profField.text = String(appDelegate.character.proficiencyBonus)
            profField.textAlignment = NSTextAlignment.center
            profField.isEnabled = false
            profField.textColor = UIColor.darkGray
            profField.layer.borderWidth = 1.0
            profField.layer.borderColor = UIColor.darkGray.cgColor
            profField.tag = tag+3
            tempView.addSubview(profField)
            
            let attributeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
            attributeLabel.text = attributeDisplay+"\nBonus"
            attributeLabel.font = UIFont.systemFont(ofSize: 10)
            attributeLabel.textAlignment = NSTextAlignment.center
            attributeLabel.numberOfLines = 2
            attributeLabel.tag = tag+4
            tempView.addSubview(attributeLabel)
            
            let attributeField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
            attributeField.text = String(attributeValue)
            attributeField.textAlignment = NSTextAlignment.center
            attributeField.isEnabled = false
            attributeField.textColor = UIColor.darkGray
            attributeField.layer.borderWidth = 1.0
            attributeField.layer.borderColor = UIColor.darkGray.cgColor
            attributeField.tag = tag+5
            tempView.addSubview(attributeField)
            
            let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
            miscLabel.text = "Misc\nBonus"
            miscLabel.font = UIFont.systemFont(ofSize: 10)
            miscLabel.textAlignment = NSTextAlignment.center
            miscLabel.numberOfLines = 2
            miscLabel.tag = tag+6
            tempView.addSubview(miscLabel)
            
            let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
            miscField.text = String(skill["misc_bonus"].intValue)
            miscField.textAlignment = NSTextAlignment.center
            miscField.layer.borderWidth = 1.0
            miscField.layer.borderColor = UIColor.black.cgColor
            miscField.tag = tag+7
            miscField.delegate = self
            tempView.addSubview(miscField)
            
            let skillProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:85, width:150, height:30))
            skillProfLabel.text = "Skill Proficiency"
            skillProfLabel.textAlignment = NSTextAlignment.right
            skillProfLabel.tag = tag+8
            tempView.addSubview(skillProfLabel)
            
            let skillProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
            skillProfSwitch.isOn = false
            skillProfSwitch.tag = tag+9
            tempView.addSubview(skillProfSwitch)
            
            let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
            if skillProfSwitch.isOn {
                halfProfLabel.text = "Double Proficiency"
            }
            else {
                halfProfLabel.text = "Half Proficiency"
            }
            halfProfLabel.textAlignment = NSTextAlignment.right
            halfProfLabel.tag = tag+10
            tempView.addSubview(halfProfLabel)
            
            let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
            halfProfSwitch.tag = tag+11
            tempView.addSubview(halfProfSwitch)
            
            let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
            roundUpLabel.text = "Round Up"
            roundUpLabel.textAlignment = NSTextAlignment.right
            roundUpLabel.tag = tag+12
            tempView.addSubview(roundUpLabel)
            
            let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
            roundUpSwitch.isOn = false
            roundUpSwitch.tag = tag+13
            tempView.addSubview(roundUpSwitch)
            
            if halfProfLabel.text == "Double Proficiency" {
                halfProfSwitch.isOn = false
                roundUpLabel.isHidden = true
                roundUpSwitch.isHidden = true
            }
            else {
                halfProfSwitch.isOn = true
                if halfProfSwitch.isOn {
                    roundUpLabel.isHidden = false
                    roundUpSwitch.isHidden = false
                }
                else {
                    roundUpLabel.isHidden = true
                    roundUpSwitch.isHidden = true
                }
            }
            
            view.addSubview(tempView)
        }
    }
    
    // UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 10 {
            // Class & Level
            let tempView = createBasicView()
            tempView.tag = 20
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let classTitle = UILabel.init(frame: CGRect.init(x:5, y:5, width:tempView.frame.size.width/2-10, height:30))
            classTitle.text = "Class"
            classTitle.textAlignment = NSTextAlignment.center
            classTitle.tag = 21
            scrollView.addSubview(classTitle)
            
            let levelTitle = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+5, y:5, width:tempView.frame.size.width/2-10, height:30))
            levelTitle.text = "Level"
            levelTitle.textAlignment = NSTextAlignment.center
            levelTitle.tag = 22
            scrollView.addSubview(levelTitle)
            
            var yOffest = 40
            let classStrings = textField.text?.components(separatedBy: ",")
            for classString in classStrings! {
                let classStringArray = classString.components(separatedBy: " ")
                let classStr: String = classStringArray[0]
                let levelStr: String = classStringArray[1]
                
                print("Class: ", classStr, "Level: ", levelStr)
                
                var selectedIndex = 0
                for i in 0...allClasses.count-1 {
                    let c = allClasses[i]
                    if c == classStr {
                        selectedIndex = i
                    }
                }
                
                let classPickerView = UIPickerView.init(frame: CGRect.init(x:5, y:yOffest, width:Int(tempView.frame.size.width/2-10), height:40))
                classPickerView.dataSource = self
                classPickerView.delegate = self
                classPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
                classPickerView.layer.borderWidth = 1.0
                classPickerView.layer.borderColor = UIColor.black.cgColor
                classPickerView.tag = 23
                scrollView.addSubview(classPickerView)
                
                selectedIndex = 0
                for i in 0...levels.count-1 {
                    let l = String(levels[i])
                    if l == levelStr {
                        selectedIndex = i
                    }
                }
                
                let levelPickerView = UIPickerView.init(frame: CGRect.init(x:Int(tempView.frame.size.width/2+5), y:yOffest, width:Int(tempView.frame.size.width/2-10), height:40))
                levelPickerView.dataSource = self
                levelPickerView.delegate = self
                levelPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
                levelPickerView.layer.borderWidth = 1.0
                levelPickerView.layer.borderColor = UIColor.black.cgColor
                levelPickerView.tag = 24
                scrollView.addSubview(levelPickerView)
                
                yOffest = yOffest+45
            }
            
            let multiClassButton = UIButton.init(type: UIButtonType.custom)
            multiClassButton.frame = CGRect.init(x:5, y:yOffest, width:Int(tempView.frame.size.width/2-10), height:30)
            multiClassButton.setTitle("+ Multiclass", for:UIControlState.normal)
            multiClassButton.addTarget(self, action: #selector(self.mcAction), for: UIControlEvents.touchUpInside)
            multiClassButton.layer.borderWidth = 1.0
            multiClassButton.layer.borderColor = UIColor.black.cgColor
            multiClassButton.setTitleColor(UIColor.black, for:UIControlState.normal)
            multiClassButton.tag = 25
            scrollView.addSubview(multiClassButton)
            
            view.addSubview(tempView)
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 125)
            
            textField.endEditing(true)
        }
        else if textField.tag == 11 {
            // Race
            let tempView = createBasicView()
            tempView.tag = 30
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let raceTitle = UILabel.init(frame: CGRect.init(x:5, y:5, width:tempView.frame.size.width-10, height:30))
            raceTitle.text = "Race"
            raceTitle.textAlignment = NSTextAlignment.center
            raceTitle.tag = 31
            scrollView.addSubview(raceTitle)
            
            var selectedIndex = 0
            for i in 0...allRaces.count-1 {
                let r = allRaces[i]["race"] as! String
                let currentRace = appDelegate.character.race["title"].string
                if r == currentRace {
                    selectedIndex = i
                }
            }
            
            let racePickerView = UIPickerView.init(frame: CGRect.init(x:5, y:40, width:Int(tempView.frame.size.width-10), height:40))
            racePickerView.dataSource = self
            racePickerView.delegate = self
            racePickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            racePickerView.layer.borderWidth = 1.0
            racePickerView.layer.borderColor = UIColor.black.cgColor
            racePickerView.tag = 32
            scrollView.addSubview(racePickerView)
            
            selectedIndex = 0
            for i in 0...allRaces.count-1 {
                let r = allRaces[i]["race"] as! String
                let currentRace = appDelegate.character.race["title"].string
                if r == currentRace {
                    let subRaces:Array<String> = allRaces[i]["subraces"] as! Array<String>
                    for j in 0...subRaces.count-1 {
                        let sr = subRaces[j]
                        let currentSubrace = appDelegate.character.race["subrace"].string
                        if sr == currentSubrace {
                            selectedIndex = j
                        }
                    }
                    
                }
            }
            
            let subviewPickerView = UIPickerView.init(frame:  CGRect.init(x:5, y:85, width:Int(tempView.frame.size.width-10), height:40))
            subviewPickerView.dataSource = self
            subviewPickerView.delegate = self
            subviewPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            subviewPickerView.layer.borderWidth = 1.0
            subviewPickerView.layer.borderColor = UIColor.black.cgColor
            subviewPickerView.tag = 33
            scrollView.addSubview(subviewPickerView)
            
            view.addSubview(tempView)
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 125)
            
            textField.endEditing(true)
        }
        else if textField.tag == 12 {
            // Background
            let tempView = createBasicView()
            tempView.tag = 40
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let backgroundTitle = UILabel.init(frame: CGRect.init(x:5, y:5, width:tempView.frame.size.width-10, height:30))
            backgroundTitle.text = "Background"
            backgroundTitle.textAlignment = NSTextAlignment.center
            backgroundTitle.tag = 41
            scrollView.addSubview(backgroundTitle)
            
            var selectedIndex = 0
            for i in 0...allBackgrounds.count-1 {
                let bg = allBackgrounds[i] 
                let currentBackground = appDelegate.character.background["title"].string
                if bg == currentBackground {
                    selectedIndex = i
                }
            }
            
            let backgroundPickerView = UIPickerView.init(frame: CGRect.init(x:5, y:40, width:Int(tempView.frame.size.width-10), height:40))
            backgroundPickerView.dataSource = self
            backgroundPickerView.delegate = self
            backgroundPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            backgroundPickerView.layer.borderWidth = 1.0
            backgroundPickerView.layer.borderColor = UIColor.black.cgColor
            backgroundPickerView.tag = 42
            scrollView.addSubview(backgroundPickerView)
            
            view.addSubview(tempView)
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 90)
            
            textField.endEditing(true)
        }
        if textField.tag == 13 {
            // Alignment
            let tempView = createBasicView()
            tempView.tag = 40
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let alignmentTitle = UILabel.init(frame: CGRect.init(x:5, y:5, width:tempView.frame.size.width-10, height:30))
            alignmentTitle.text = "Alignment"
            alignmentTitle.textAlignment = NSTextAlignment.center
            alignmentTitle.tag = 41
            scrollView.addSubview(alignmentTitle)
            
            // Lawful Good
            let lgBtn = UIButton.init(type: UIButtonType.custom)
            lgBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:40, width:40, height:40)
            lgBtn.setTitle("LG", for:UIControlState.normal)
            lgBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            lgBtn.layer.borderWidth = 1.0
            lgBtn.layer.borderColor = UIColor.black.cgColor
            lgBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            lgBtn.tag = 42
            scrollView.addSubview(lgBtn)
            
            // Neutral Good
            let ngBtn = UIButton.init(type: UIButtonType.custom)
            ngBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:40, width:40, height:40)
            ngBtn.setTitle("NG", for:UIControlState.normal)
            ngBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            ngBtn.layer.borderWidth = 1.0
            ngBtn.layer.borderColor = UIColor.black.cgColor
            ngBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            ngBtn.tag = 43
            scrollView.addSubview(ngBtn)
            
            // Chaotic Good
            let cgBtn = UIButton.init(type: UIButtonType.custom)
            cgBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:40, width:40, height:40)
            cgBtn.setTitle("CG", for:UIControlState.normal)
            cgBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            cgBtn.layer.borderWidth = 1.0
            cgBtn.layer.borderColor = UIColor.black.cgColor
            cgBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            cgBtn.tag = 44
            scrollView.addSubview(cgBtn)
            
            // Lawful Neutral
            let lnBtn = UIButton.init(type: UIButtonType.custom)
            lnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:85, width:40, height:40)
            lnBtn.setTitle("LN", for:UIControlState.normal)
            lnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            lnBtn.layer.borderWidth = 1.0
            lnBtn.layer.borderColor = UIColor.black.cgColor
            lnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            lnBtn.tag = 45
            scrollView.addSubview(lnBtn)
            
            // True Neutral
            let tnBtn = UIButton.init(type: UIButtonType.custom)
            tnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:85, width:40, height:40)
            tnBtn.setTitle("TN", for:UIControlState.normal)
            tnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            tnBtn.layer.borderWidth = 1.0
            tnBtn.layer.borderColor = UIColor.black.cgColor
            tnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            tnBtn.tag = 46
            scrollView.addSubview(tnBtn)
            
            // Chaotic Neutral
            let cnBtn = UIButton.init(type: UIButtonType.custom)
            cnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:85, width:40, height:40)
            cnBtn.setTitle("CN", for:UIControlState.normal)
            cnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            cnBtn.layer.borderWidth = 1.0
            cnBtn.layer.borderColor = UIColor.black.cgColor
            cnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            cnBtn.tag = 47
            scrollView.addSubview(cnBtn)
            
            // Lawful Evil
            let leBtn = UIButton.init(type: UIButtonType.custom)
            leBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:130, width:40, height:40)
            leBtn.setTitle("LE", for:UIControlState.normal)
            leBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            leBtn.layer.borderWidth = 1.0
            leBtn.layer.borderColor = UIColor.black.cgColor
            leBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            leBtn.tag = 48
            scrollView.addSubview(leBtn)
            
            // Neutral Evil
            let neBtn = UIButton.init(type: UIButtonType.custom)
            neBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:130, width:40, height:40)
            neBtn.setTitle("NE", for:UIControlState.normal)
            neBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            neBtn.layer.borderWidth = 1.0
            neBtn.layer.borderColor = UIColor.black.cgColor
            neBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            neBtn.tag = 49
            scrollView.addSubview(neBtn)
                
            // Chaotic Evil
            let ceBtn = UIButton.init(type: UIButtonType.custom)
            ceBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:130, width:40, height:40)
            ceBtn.setTitle("CE", for:UIControlState.normal)
            ceBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            ceBtn.layer.borderWidth = 1.0
            ceBtn.layer.borderColor = UIColor.black.cgColor
            ceBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            ceBtn.tag = 50
            scrollView.addSubview(ceBtn)
            
            if appDelegate.character.alignment == "LG" {
                lgBtn.isSelected = true
                lgBtn.backgroundColor = UIColor.black
                lgBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "NG" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = true
                ngBtn.backgroundColor = UIColor.black
                ngBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "CG" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = true
                cgBtn.backgroundColor = UIColor.black
                cgBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "LN" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = true
                lnBtn.backgroundColor = UIColor.black
                lnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "TN" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = true
                tnBtn.backgroundColor = UIColor.black
                tnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                
            }
            else if appDelegate.character.alignment == "CN" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = true
                cnBtn.backgroundColor = UIColor.black
                cnBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "LE" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = true
                leBtn.backgroundColor = UIColor.black
                leBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "NE" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = true
                neBtn.backgroundColor = UIColor.black
                neBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                ceBtn.isSelected = false
                ceBtn.backgroundColor = UIColor.white
                ceBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            else if appDelegate.character.alignment == "CE" {
                lgBtn.isSelected = false
                lgBtn.backgroundColor = UIColor.white
                lgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ngBtn.isSelected = false
                ngBtn.backgroundColor = UIColor.white
                ngBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cgBtn.isSelected = false
                cgBtn.backgroundColor = UIColor.white
                cgBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                lnBtn.isSelected = false
                lnBtn.backgroundColor = UIColor.white
                lnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                tnBtn.isSelected = false
                tnBtn.backgroundColor = UIColor.white
                tnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                cnBtn.isSelected = false
                cnBtn.backgroundColor = UIColor.white
                cnBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                leBtn.isSelected = false
                leBtn.backgroundColor = UIColor.white
                leBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                neBtn.isSelected = false
                neBtn.backgroundColor = UIColor.white
                neBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                ceBtn.isSelected = true
                ceBtn.backgroundColor = UIColor.black
                ceBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            }
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 90)
            
            view.addSubview(tempView)
            
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 14 {
            // Experience
            
        }
        else if textField.tag == 102 {
            // Current HP
            appDelegate.character.currentHP = Int(textField.text!)!
            
            hpEffectValue = 0
            let parentView = textField.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 106 {
                    let effectTextField = view as! UITextField
                    effectTextField.text = String(hpEffectValue)
                }
                if view.tag == 107 {
                    let stepper = view as! UIStepper
                    stepper.value = Double(hpEffectValue)
                }
            }
        }
        else if textField.tag == 104 {
            // Max HP
            appDelegate.character.maxHP = Int(textField.text!)!
            
            hpEffectValue = 0
            let parentView = textField.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 106 {
                    let effectTextField = view as! UITextField
                    effectTextField.text = String(hpEffectValue)
                }
                if view.tag == 107 {
                    let stepper = view as! UIStepper
                    stepper.value = Double(hpEffectValue)
                }
            }
        }
        else if textField.tag == 106 {
            // Effect HP Value
            hpEffectValue = Int(textField.text!)!
            let parentView = textField.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 107 {
                    let stepper = view as! UIStepper
                    stepper.value = Double(hpEffectValue)
                }
            }
        }
        else if textField.tag == 202 {
            // Current Hit Die
            appDelegate.character.currentHitDice = Int(textField.text!)!
        }
        else if textField.tag == 206 {
            // Max Hit Die
            appDelegate.character.maxHitDice = Int(textField.text!)!
        }
        else if textField.tag == 208 {
            // Hit Die Type
            appDelegate.character.hitDieType = Int(textField.text!)!
        }
        else if textField.tag == 212 {
            // Extra Hit Die 1 Current
            appDelegate.character.extra1CurrentHitDice = Int(textField.text!)!
        }
        else if textField.tag == 216 {
            // Extra Hit Die 1 Max
            appDelegate.character.extra1MaxHitDice = Int(textField.text!)!
        }
        else if textField.tag == 218 {
            // Extra Hit Die 1 Type
            appDelegate.character.extra1HitDieType = Int(textField.text!)!
        }
        else if textField.tag == 222 {
            // Extra Hit Die 2 Current
            appDelegate.character.extra2CurrentHitDice = Int(textField.text!)!
        }
        else if textField.tag == 226 {
            // Extra Hit Die 2 Max
            appDelegate.character.extra2MaxHitDice = Int(textField.text!)!
        }
        else if textField.tag == 228 {
            // Extra Hit Die 2 Type
            appDelegate.character.extra2HitDieType = Int(textField.text!)!
        }
        else if textField.tag == 232 {
            // Extra Hit Die 3 Current
            appDelegate.character.extra3CurrentHitDice = Int(textField.text!)!
        }
        else if textField.tag == 236 {
            // Extra Hit Die 3 Max
            appDelegate.character.extra3MaxHitDice = Int(textField.text!)!
        }
        else if textField.tag == 238 {
            // Extra Hit Die 3 Type
            appDelegate.character.extra3HitDieType = Int(textField.text!)!
        }
        else if textField.tag == 311 {
            // Misc AC Bonus
            appDelegate.character.ACMiscBonus = Int(textField.text!)!
        }
        else if textField.tag == 402 {
            // Proficiency Bonus
            appDelegate.character.proficiencyBonus = Int(textField.text!)!
        }
        else if textField.tag == 502 {
            // Strength Score
            appDelegate.character.strScore = Int(textField.text!)!
            appDelegate.character.strBonus = appDelegate.character.getBonus(score: appDelegate.character.strScore)
            appDelegate.character.strSave = appDelegate.character.getSave(bonus: appDelegate.character.strBonus, attribute: "STR")
        }
        else if textField.tag == 602 {
            // Dexterity Score
            appDelegate.character.dexScore = Int(textField.text!)!
            appDelegate.character.dexBonus = appDelegate.character.getBonus(score: appDelegate.character.dexScore)
            appDelegate.character.dexSave = appDelegate.character.getSave(bonus: appDelegate.character.dexBonus, attribute: "DEX")
        }
        else if textField.tag == 702 {
            // Constitution Score
            appDelegate.character.conScore = Int(textField.text!)!
            appDelegate.character.conBonus = appDelegate.character.getBonus(score: appDelegate.character.conScore)
            appDelegate.character.conSave = appDelegate.character.getSave(bonus: appDelegate.character.conBonus, attribute: "CON")
        }
        else if textField.tag == 802 {
            // Intelligence Score
            appDelegate.character.intScore = Int(textField.text!)!
            appDelegate.character.intBonus = appDelegate.character.getBonus(score: appDelegate.character.intScore)
            appDelegate.character.intSave = appDelegate.character.getSave(bonus: appDelegate.character.intBonus, attribute: "INT")
        }
        else if textField.tag == 902 {
            // Wisdom Score
            appDelegate.character.wisScore = Int(textField.text!)!
            appDelegate.character.wisBonus = appDelegate.character.getBonus(score: appDelegate.character.wisScore)
            appDelegate.character.wisSave = appDelegate.character.getSave(bonus: appDelegate.character.wisBonus, attribute: "WIS")
        }
        else if textField.tag == 1002 {
            // Charisma Score
            appDelegate.character.chaScore = Int(textField.text!)!
            appDelegate.character.chaBonus = appDelegate.character.getBonus(score: appDelegate.character.chaScore)
            appDelegate.character.chaSave = appDelegate.character.getSave(bonus: appDelegate.character.chaBonus, attribute: "CHA")
        }
        else if textField.tag == 1107 {
            // Initiative Misc Bonus
            appDelegate.character.initiativeMiscBonus = Int(textField.text!)!
        }
        else if textField.tag == 1303 {
            // Base Speed
            switch appDelegate.character.speedType {
            case 0:
                // Walk
                appDelegate.character.walkSpeed = Int(textField.text!)!
                break
            case 1:
                // Burrow
                appDelegate.character.burrowSpeed = Int(textField.text!)!
                break
            case 2:
                // Climb
                appDelegate.character.climbSpeed = Int(textField.text!)!
                break
            case 3:
                // Fly
                appDelegate.character.flySpeed = Int(textField.text!)!
                break
            case 4:
                // Swim
                appDelegate.character.swimSpeed = Int(textField.text!)!
                break
            default: break
            }
        }
        else if textField.tag == 1305 {
            // Misc Speed Bonus
            switch appDelegate.character.speedType {
            case 0:
                // Walk
                appDelegate.character.walkSpeedMiscBonus = Int(textField.text!)!
                break
            case 1:
                // Burrow
                appDelegate.character.burrowSpeedMiscBonus = Int(textField.text!)!
                break
            case 2:
                // Climb
                appDelegate.character.climbSpeedMiscBonus = Int(textField.text!)!
                break
            case 3:
                // Fly
                appDelegate.character.flySpeedMiscBonus = Int(textField.text!)!
                break
            case 4:
                // Swim
                appDelegate.character.swimSpeedMiscBonus = Int(textField.text!)!
                break
            default: break
            }
        }
        else {
            // Skills
            
        }
        return true
    }
    
// UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 23 || pickerView.tag == 26 {
            return allClasses.count
        }
        else if pickerView.tag == 32 {
            return allClasses.count
        }
        else if pickerView.tag == 33 {
            for i in 0...allRaces.count-1 {
                let r = allRaces[i]["race"] as! String
                let currentRace = appDelegate.character.race["title"].string
                if r == currentRace {
                    let subRaces:Array<String> = allRaces[i]["subraces"] as! Array<String>
                    return subRaces.count
                }
            }
            return 0
        }
        else if pickerView.tag == 42 {
            return allBackgrounds.count
        }
        else {
            return levels.count
        }
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
        
        if pickerView.tag == 23 || pickerView.tag == 26 {
            pickerLabel?.text = allClasses[row]
        }
        else if pickerView.tag == 32 {
            pickerLabel?.text = allRaces[row]["race"] as? String
        }
        else if pickerView.tag == 33 {
            for i in 0...allRaces.count-1 {
                let r = allRaces[i]["race"] as! String
                let currentRace = appDelegate.character.race["title"].string
                if r == currentRace {
                    let subRaces:Array<String> = allRaces[i]["subraces"] as! Array<String>
                    pickerLabel?.text = subRaces[row]
                }
            }
            
        }
        else if pickerView.tag == 42 {
            pickerLabel?.text = allBackgrounds[row]
        }
        else {
            pickerLabel?.text = String(levels[row])
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width-20
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    
    @IBAction func typePickerViewSelected(sender: AnyObject) {
        
    }
}

