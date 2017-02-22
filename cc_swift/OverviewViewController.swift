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
        let passivePerception = 10+skillValue
        ppValue.text = String(passivePerception)
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
    
    // Edit HP
    @IBAction func hpAction(button: UIButton) {
        
    }
    
    // Edit Hit Dice
    @IBAction func hdAction(button: UIButton) {
        
    }
    
    // Edit Armor Class
    @IBAction func acAction(button: UIButton) {
        
    }
    
    // Edit Proficiency Bonus
    @IBAction func profAction(button: UIButton) {
        
    }
    
    // Edit Strength Score
    @IBAction func strAction(button: UIButton) {
        
    }
    
    // Edit Dexterity Score
    @IBAction func dexAction(button: UIButton) {
        
    }
    
    // Edit Constitution Score
    @IBAction func conAction(button: UIButton) {
        
    }
    
    // Edit Intelligence Score
    @IBAction func intAction(button: UIButton) {
        
    }
    
    // Edit Wisdom Score
    @IBAction func wisAction(button: UIButton) {
        
    }
    
    // Edit Charisma Score
    @IBAction func chaAction(button: UIButton) {
        
    }
    
    // Edit Initiative
    @IBAction func initAction(button: UIButton) {
        
    }
    
    // Edit Passive Perception
    @IBAction func ppAction(button: UIButton) {
        
    }
    
    // Edit Speed
    @IBAction func speedAction(button: UIButton) {
        
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
    }
    
    // UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

