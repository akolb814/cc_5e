//
//  OverviewViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 12/20/16.
//
//

import UIKit
import SwiftyJSON

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
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
    var character: Character = Character()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        skillsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        character.loadCharacterFromJson(filename: "character.json")
        
        self.setAbilityScores()
        self.setMiscDisplayData()
    }
    
    func setMiscDisplayData() {
        let firstClass: JSON = appDelegate.character.classes[0] 
        let classStr = firstClass["class"].string!
        let hitDie = firstClass["hitDie"].int!
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
        hdValue.text = String(appDelegate.character.currentHitDice)+"d"+String(hitDie)+"\n/"+String(level)+"d"+String(hitDie)
        
        profValue.text = "+"+String(appDelegate.character.proficiencyBonus)
        acValue.text = String(appDelegate.character.AC)
        if appDelegate.character.initiative < 0 {
            initValue.text = String(appDelegate.character.initiative)
        }
        else {
            initValue.text = "+"+String(appDelegate.character.initiative)
        }
        
        speedValue.text = String(appDelegate.character.speed)
        
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
            if appDelegate.character.initiative < 0 {
                initValue.text = String(appDelegate.character.initiative)
            }
            else {
                initValue.text = "+"+String(appDelegate.character.initiative)
            }
            break
            
        case 1200:
            // Passive Perception
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
            let passivePerception = 10+skillValue
            ppValue.text = String(passivePerception)
            break
            
        case 1300:
            // Speed
            speedValue.text = String(appDelegate.character.speed)
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
        else if segControl.tag == 1305 {
            // Speed Type
            
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
    }
    
    func switchAction(sender: UISwitch) {
        if sender.tag == 504 {
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
        else if sender.tag == 1106 {
            // Initiative Alert Feat
            
        }
        else if sender.tag == 1108 {
            // Initiative Half Proficiency
            
        }
        else if sender.tag == 1110 {
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
    
    // Edit Hit Dice
    @IBAction func hdAction(button: UIButton) {
        let firstClass: JSON = appDelegate.character.classes[0]
        let level = firstClass["level"].int!
        let hitDie = firstClass["hitDie"].int!
        
        // Create hit dice adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Hit Dice"
        title.textAlignment = NSTextAlignment.center
        title.tag = 201
        tempView.addSubview(title)
        
        let currentHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:35, width:40, height:30))
        currentHD.text = String(appDelegate.character.currentHitDice)
        currentHD.textAlignment = NSTextAlignment.center
        currentHD.layer.borderWidth = 1.0
        currentHD.layer.borderColor = UIColor.black.cgColor
        currentHD.tag = 202
        tempView.addSubview(currentHD)
        
        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:35, width:30, height:30))
        d1.text = "d"
        d1.textAlignment = NSTextAlignment.center
        d1.tag = 203
        tempView.addSubview(d1)
        
        let hd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
        hd1.text = String(hitDie)
        hd1.textAlignment = NSTextAlignment.center
        hd1.isUserInteractionEnabled = false
        hd1.textColor = UIColor.darkGray
        hd1.layer.borderWidth = 1.0
        hd1.layer.borderColor = UIColor.darkGray.cgColor
        hd1.tag = 204
        tempView.addSubview(hd1)
        
        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
        slash.text = "/"
        slash.textAlignment = NSTextAlignment.center
        slash.tag = 205
        tempView.addSubview(slash)
        
        let maxHD = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
        maxHD.text = String(level)
        maxHD.textAlignment = NSTextAlignment.center
        maxHD.layer.borderWidth = 1.0
        maxHD.layer.borderColor = UIColor.black.cgColor
        maxHD.tag = 206
        tempView.addSubview(maxHD)
        
        let d2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:35, width:30, height:30))
        d2.text = "d"
        d2.textAlignment = NSTextAlignment.center
        d2.tag = 207
        tempView.addSubview(d2)
        
        let hd2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:35, width:40, height:30))
        hd2.text = String(hitDie)
        hd2.textAlignment = NSTextAlignment.center
        hd2.layer.borderWidth = 1.0
        hd2.layer.borderColor = UIColor.black.cgColor
        hd2.tag = 208
        tempView.addSubview(hd2)
        
        let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:90, width:94, height:29))
        stepper.value = Double(appDelegate.character.currentHitDice)
        stepper.minimumValue = 0
        stepper.maximumValue = Double(level)
        stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        stepper.tag = 209
        tempView.addSubview(stepper)
        
        view.addSubview(tempView)
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        // Create armor class adjusting view
        let tempView = createBasicView()
        tempView.tag = 300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Armor Class"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        tempView.addSubview(title)
        
        // Armor value, Shield Value, Dex Bonus, Max Dex, Misc Mod, Additional Ability Mod (Monk/Barb)
        
        
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
        profLabel.tag = 1111
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
        profField.text = String(appDelegate.character.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 1102
        tempView.addSubview(profField)
        
        let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
        dexLabel.text = "Dexterity\nBonus"
        dexLabel.font = UIFont.systemFont(ofSize: 10)
        dexLabel.textAlignment = NSTextAlignment.center
        dexLabel.numberOfLines = 2
        dexLabel.tag = 1112
        tempView.addSubview(dexLabel)
        
        let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        dexField.text = String(appDelegate.character.dexBonus)
        dexField.textAlignment = NSTextAlignment.center
        dexField.layer.borderWidth = 1.0
        dexField.layer.borderColor = UIColor.black.cgColor
        dexField.tag = 1103
        tempView.addSubview(dexField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 1113
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
        miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 1104
        tempView.addSubview(miscField)
        
        let alertLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-90, y:85, width:120, height:30))
        alertLabel.text = "Alert Feat"
        alertLabel.textAlignment = NSTextAlignment.right
        alertLabel.tag = 1105
        tempView.addSubview(alertLabel)
        
        let alertSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
        alertSwitch.isOn = false
        alertSwitch.tag = 1106
        tempView.addSubview(alertSwitch)
        
        let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
        halfProfLabel.text = "Half Proficiency"
        halfProfLabel.textAlignment = NSTextAlignment.right
        halfProfLabel.tag = 1107
        tempView.addSubview(halfProfLabel)
        
        let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
        halfProfSwitch.isOn = false
        halfProfSwitch.tag = 1108
        tempView.addSubview(halfProfSwitch)
        
        let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
        roundUpLabel.text = "Round Up"
        roundUpLabel.textAlignment = NSTextAlignment.right
        roundUpLabel.tag = 1109
        tempView.addSubview(roundUpLabel)
        
        let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
        roundUpSwitch.isOn = false
        roundUpSwitch.tag = 1110
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
        baseLabel.tag = 1306
        tempView.addSubview(baseLabel)
        
        let baseField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:65, width:40, height:30))
        baseField.text = String(appDelegate.character.speed)
        baseField.textAlignment = NSTextAlignment.center
        baseField.layer.borderWidth = 1.0
        baseField.layer.borderColor = UIColor.black.cgColor
        baseField.tag = 1302
        tempView.addSubview(baseField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-5, y: 35, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 1307
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:65, width:40, height:30))
        miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 1303
        tempView.addSubview(miscField)
        
        let movementLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        movementLabel.text = "Movement Type"
        movementLabel.textAlignment = NSTextAlignment.center
        movementLabel.tag = 1304
        tempView.addSubview(movementLabel)
        
        let movementType = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        movementType.insertSegment(withTitle:"Walk", at:0, animated:false)
        movementType.insertSegment(withTitle:"Burrow", at:1, animated:false)
        movementType.insertSegment(withTitle:"Climb", at:2, animated:false)
        movementType.insertSegment(withTitle:"Fly", at:3, animated:false)
        movementType.insertSegment(withTitle:"Swim", at:4, animated:false)
        movementType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        movementType.selectedSegmentIndex = 0
        movementType.tag = 1305
        tempView.addSubview(movementType)
        
        view.addSubview(tempView)
    }
    
    // UITableView Delegate & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.character.skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit selected skill value
        tableView.deselectRow(at: indexPath, animated: true)
        
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
        profLabel.tag = tag+11
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:50, width:40, height:30))
        profField.text = String(appDelegate.character.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = tag+2
        tempView.addSubview(profField)
        
        let attributeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 25, width: 90, height: 30))
        attributeLabel.text = attributeDisplay+"\nBonus"
        attributeLabel.font = UIFont.systemFont(ofSize: 10)
        attributeLabel.textAlignment = NSTextAlignment.center
        attributeLabel.numberOfLines = 2
        attributeLabel.tag = 612
        tempView.addSubview(attributeLabel)
        
        let attributeField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        attributeField.text = String(attributeValue)
        attributeField.textAlignment = NSTextAlignment.center
        attributeField.layer.borderWidth = 1.0
        attributeField.layer.borderColor = UIColor.black.cgColor
        attributeField.tag = tag+3
        tempView.addSubview(attributeField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 25, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 613
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:50, width:40, height:30))
        miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = tag+4
        tempView.addSubview(miscField)
        
        let skillProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:85, width:150, height:30))
        skillProfLabel.text = "Skill Proficiency"
        skillProfLabel.textAlignment = NSTextAlignment.right
        skillProfLabel.tag = tag+5
        tempView.addSubview(skillProfLabel)
        
        let skillProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:85, width:51, height:31))
        skillProfSwitch.isOn = false
        skillProfSwitch.tag = tag+6
        tempView.addSubview(skillProfSwitch)
        
        let halfProfLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:120, width:150, height:30))
        if skillProfSwitch.isOn {
            halfProfLabel.text = "Double Proficiency"
        }
        else {
            halfProfLabel.text = "Half Proficiency"
        }
        halfProfLabel.textAlignment = NSTextAlignment.right
        halfProfLabel.tag = tag+7
        tempView.addSubview(halfProfLabel)
        
        let halfProfSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:120, width:51, height:31))
        halfProfSwitch.tag = tag+8
        tempView.addSubview(halfProfSwitch)
        
        let roundUpLabel = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:155, width:150, height:30))
        roundUpLabel.text = "Round Up"
        roundUpLabel.textAlignment = NSTextAlignment.right
        roundUpLabel.tag = tag+9
        tempView.addSubview(roundUpLabel)
        
        let roundUpSwitch = UISwitch.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:155, width:51, height:31))
        roundUpSwitch.isOn = false
        roundUpSwitch.tag = tag+10
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
    
    // UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

