//
//  SpellcastingViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class SpellcastingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Spell Attack
    @IBOutlet weak var saView: UIView!
    @IBOutlet weak var saTitle: UILabel!
    @IBOutlet weak var saValue: UILabel!
    @IBOutlet weak var saButton: UIButton!
    
    // Spell DC
    @IBOutlet weak var sdcView: UIView!
    @IBOutlet weak var sdcTitle: UILabel!
    @IBOutlet weak var sdcValue: UILabel!
    @IBOutlet weak var sdcButton: UIButton!
    
    // Caster Level
    @IBOutlet weak var clView: UIView!
    @IBOutlet weak var clTitle: UILabel!
    @IBOutlet weak var clValue: UILabel!
    @IBOutlet weak var clButton: UIButton!
    
    // Resource
    @IBOutlet weak var resourceView: UIView!
    @IBOutlet weak var resourceTitle: UILabel!
    @IBOutlet weak var resourceValue: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    
    // Spell TableView
    @IBOutlet weak var spellsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var spellcasting = Spellcasting()
    var newSpell = false
    var newSpellCustom = false
    override func viewDidLoad() {
        super.viewDidLoad()

        spellcasting = Character.Selected.spellcasting!
        // Do any additional setup after loading the view.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        spellsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        spellsTable.addGestureRecognizer(longPressGesture)
        
        self.setMiscDisplayData()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue:"SpellSlotUpdate"), object: nil, queue: nil, using: spellSlotUpdate)
        nc.addObserver(forName: Notification.Name(rawValue:"shortRest"), object: nil, queue: nil, using: updateFromRest)
        nc.addObserver(forName: Notification.Name(rawValue:"longRest"), object: nil, queue: nil, using: updateFromRest)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spellsTable.reloadData()
    }
    
    func updateFromRest(notification: Notification) -> Void {
        setMiscDisplayData()
        spellsTable.reloadData()
    }
    
    func spellSlotUpdate(notification: Notification) -> Void {
        spellsTable.reloadData()
    }
    
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: spellsTable)
        let indexPath = spellsTable.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizerState.began) {
            print("Long press on row, at \(indexPath!.row)")
            // Get selected spell
            let spellLevel = spellcasting.spells_by_level?.allObjects[(indexPath?.section)!] as! Spells_by_Level
            let spell = spellLevel.spells?.allObjects[(indexPath?.row)!-1] as! Spell
            
            let baseTag = (1000 * ((indexPath?.section)!+1)) + (100*((indexPath?.row)!-1))
            // Create spell adjusting view
            let tempView = createBasicView()
            tempView.tag = baseTag
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
            title.text = "Edit Spell"
            title.textAlignment = NSTextAlignment.center
            title.tag = baseTag + 1
            scrollView.addSubview(title)
            
            // Name - tf
            let nameLabel = UILabel.init(frame: CGRect.init(x: 20, y: 30, width: tempView.frame.size.width-140, height: 20))
            nameLabel.text = "Spell Name"
            nameLabel.font = UIFont.systemFont(ofSize: 10)
            nameLabel.textAlignment = NSTextAlignment.left
            nameLabel.numberOfLines = 1
            nameLabel.tag = baseTag + 2
            scrollView.addSubview(nameLabel)
            
            let nameField = UITextField.init(frame: CGRect.init(x:20, y:50, width:tempView.frame.size.width-120, height:30))
            nameField.text = spell.name
            nameField.textAlignment = NSTextAlignment.left
            nameField.isEnabled = true
            nameField.textColor = UIColor.black
            nameField.layer.borderWidth = 1.0
            nameField.layer.borderColor = UIColor.black.cgColor
            nameField.tag = baseTag + 3
            scrollView.addSubview(nameField)
            
            // Concentration - switch
            let concentrationLabel = UILabel(frame: CGRect.init(x: tempView.frame.size.width - 100, y: 30, width: 80, height: 20))
            concentrationLabel.text = "Concentration"
            concentrationLabel.font = UIFont.systemFont(ofSize: 10)
            concentrationLabel.textAlignment = NSTextAlignment.right
            concentrationLabel.numberOfLines = 1
            concentrationLabel.tag = baseTag + 4
            scrollView.addSubview(concentrationLabel)
            
            let concentrationSwitch = UISwitch(frame: CGRect.init(x: tempView.frame.size.width - 71, y: 50, width:51, height:31))
            concentrationSwitch.isOn = spell.concentration
            concentrationSwitch.tag = baseTag + 5
            scrollView.addSubview(concentrationSwitch)
            
            // School - tf
            let schoolLabel = UILabel.init(frame: CGRect.init(x: 20, y: 80, width: tempView.frame.size.width-140, height: 20))
            schoolLabel.text = "School"
            schoolLabel.font = UIFont.systemFont(ofSize: 10)
            schoolLabel.textAlignment = NSTextAlignment.left
            schoolLabel.numberOfLines = 1
            schoolLabel.tag = baseTag + 6
            scrollView.addSubview(schoolLabel)
            
            var spellSchoolIndex = 0
            for index in 0...Types.SpellSchoolStrings.count-1 {
                if spell.school == Types.SpellSchoolStrings[index] {
                    spellSchoolIndex = index
                }
            }
            
            let schoolPickerView = UIPickerView.init(frame: CGRect.init(x:20, y: 97, width:scrollView.frame.size.width-120, height:34))
            schoolPickerView.dataSource = self
            schoolPickerView.delegate = self
            schoolPickerView.layer.borderWidth = 1.0
            schoolPickerView.layer.borderColor = UIColor.black.cgColor
            schoolPickerView.selectRow(spellSchoolIndex, inComponent: 0, animated: false)
            schoolPickerView.tag = baseTag + 7
            scrollView.addSubview(schoolPickerView)
            
            // Prepared - switch
            let preparedLabel = UILabel(frame: CGRect.init(x: tempView.frame.size.width - 100, y: 80, width: 80, height: 20))
            preparedLabel.text = "Prepared"
            preparedLabel.font = UIFont.systemFont(ofSize: 10)
            preparedLabel.textAlignment = NSTextAlignment.right
            preparedLabel.numberOfLines = 1
            preparedLabel.tag = baseTag + 8
            scrollView.addSubview(preparedLabel)
            
            let preparedSwitch = UISwitch(frame: CGRect.init(x: tempView.frame.size.width - 71, y: 100, width:51, height:31))
            preparedSwitch.isOn = spell.prepared
            preparedSwitch.tag = baseTag + 9
            scrollView.addSubview(preparedSwitch)
            
            // Casting time - tf
            let castingLabel = UILabel.init(frame: CGRect.init(x: 20, y: 130, width: tempView.frame.size.width-40, height: 20))
            castingLabel.text = "Casting Time"
            castingLabel.font = UIFont.systemFont(ofSize: 10)
            castingLabel.textAlignment = NSTextAlignment.left
            castingLabel.numberOfLines = 1
            castingLabel.tag = baseTag + 10
            scrollView.addSubview(castingLabel)
            
            let castingField = UITextField.init(frame: CGRect.init(x:20, y:150, width:tempView.frame.size.width-40, height:30))
            castingField.text = spell.casting_time
            castingField.textAlignment = NSTextAlignment.left
            castingField.isEnabled = false
            castingField.textColor = UIColor.black
            castingField.layer.borderWidth = 1.0
            castingField.layer.borderColor = UIColor.black.cgColor
            castingField.tag = baseTag + 11
            scrollView.addSubview(castingField)
            
            // Range - tf
            let rangeLabel = UILabel.init(frame: CGRect.init(x: 20, y: 180, width: tempView.frame.size.width-40, height: 20))
            rangeLabel.text = "Range"
            rangeLabel.font = UIFont.systemFont(ofSize: 10)
            rangeLabel.textAlignment = NSTextAlignment.left
            rangeLabel.numberOfLines = 1
            rangeLabel.tag = baseTag + 12
            scrollView.addSubview(rangeLabel)
            
            let rangeField = UITextField.init(frame: CGRect.init(x:20, y:200, width:tempView.frame.size.width-40, height:30))
            rangeField.text = spell.range
            rangeField.textAlignment = NSTextAlignment.left
            rangeField.isEnabled = true
            rangeField.textColor = UIColor.black
            rangeField.layer.borderWidth = 1.0
            rangeField.layer.borderColor = UIColor.black.cgColor
            rangeField.tag = baseTag + 13
            scrollView.addSubview(rangeField)
            
            // Components - tf
            let componentsLabel = UILabel.init(frame: CGRect.init(x: 20, y: 230, width: tempView.frame.size.width-40, height: 20))
            componentsLabel.text = "Components"
            componentsLabel.font = UIFont.systemFont(ofSize: 10)
            componentsLabel.textAlignment = NSTextAlignment.left
            componentsLabel.numberOfLines = 1
            componentsLabel.tag = baseTag + 14
            scrollView.addSubview(componentsLabel)
            
            let componentsField = UITextField.init(frame: CGRect.init(x:20, y:250, width:tempView.frame.size.width-40, height:30))
            componentsField.text = spell.components
            componentsField.textAlignment = NSTextAlignment.left
            componentsField.isEnabled = true
            componentsField.textColor = UIColor.black
            componentsField.layer.borderWidth = 1.0
            componentsField.layer.borderColor = UIColor.black.cgColor
            componentsField.tag = baseTag + 15
            scrollView.addSubview(componentsField)
            
            // Duration - tf
            let durationLabel = UILabel.init(frame: CGRect.init(x: 20, y: 280, width: tempView.frame.size.width-40, height: 20))
            durationLabel.text = "Duration"
            durationLabel.font = UIFont.systemFont(ofSize: 10)
            durationLabel.textAlignment = NSTextAlignment.left
            durationLabel.numberOfLines = 1
            durationLabel.tag = baseTag + 16
            scrollView.addSubview(durationLabel)
            
            let durationField = UITextField.init(frame: CGRect.init(x:20, y:300, width:tempView.frame.size.width-40, height:30))
            durationField.text = spell.duration
            durationField.textAlignment = NSTextAlignment.left
            durationField.isEnabled = true
            durationField.textColor = UIColor.black
            durationField.layer.borderWidth = 1.0
            durationField.layer.borderColor = UIColor.black.cgColor
            durationField.tag = baseTag + 17
            scrollView.addSubview(durationField)
            
            // Info - tv
            let infoLabel = UILabel.init(frame: CGRect.init(x: 20, y: 330, width: tempView.frame.size.width-40, height: 20))
            infoLabel.text = "Description"
            infoLabel.font = UIFont.systemFont(ofSize: 10)
            infoLabel.textAlignment = NSTextAlignment.left
            infoLabel.numberOfLines = 1
            infoLabel.tag = baseTag + 18
            scrollView.addSubview(infoLabel)
            
            let infoView = UITextView.init(frame: CGRect.init(x: 20, y: 350, width: tempView.frame.size.width-40, height: 100))
            infoView.text = spell.info
            infoView.textColor = UIColor.black
            infoView.layer.borderWidth = 1.0
            infoView.layer.borderColor = UIColor.black.cgColor
            infoView.tag = baseTag + 19
            
            let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
            var infoFrame = infoView.frame
            infoFrame.size.height = infoContentSize.height
            infoView.frame = infoFrame
            
            scrollView.addSubview(infoView)
            
            // Higher level - tv
            let hlLabel = UILabel.init(frame: CGRect.init(x: 20, y: infoView.frame.origin.y + infoView.frame.size.height, width: tempView.frame.size.width-40, height: 20))
            hlLabel.text = "Higher Level"
            hlLabel.font = UIFont.systemFont(ofSize: 10)
            hlLabel.textAlignment = NSTextAlignment.left
            hlLabel.numberOfLines = 1
            hlLabel.tag = baseTag + 20
            scrollView.addSubview(hlLabel)
            
            let hlView = UITextView.init(frame: CGRect.init(x: 20, y: hlLabel.frame.origin.y + hlLabel.frame.size.height, width: tempView.frame.size.width-40, height: 50))
            hlView.text = spell.higher_level
            hlView.textColor = UIColor.black
            hlView.layer.borderWidth = 1.0
            hlView.layer.borderColor = UIColor.black.cgColor
            hlView.tag = baseTag + 21
            
            let hlContentSize = hlView.sizeThatFits(hlView.bounds.size)
            var hlFrame = hlView.frame
            hlFrame.size.height = hlContentSize.height
            hlView.frame = hlFrame
            
            scrollView.addSubview(hlView)
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: hlView.frame.origin.y + hlView.frame.size.height + 10)
            
            view.addSubview(tempView)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setMiscDisplayData() {
        // Spell Attack
        var spellAttack = Character.Selected.proficiency_bonus
        var spellDC = 8+Character.Selected.proficiency_bonus
        let spellAbility = spellcasting.ability!.name!
        switch spellAbility {
        case "STR":
            spellAttack = spellAttack + Character.Selected.strBonus //Add STR bonus
            spellDC = spellDC + Character.Selected.strBonus
        case "DEX":
            spellAttack = spellAttack + Character.Selected.dexBonus //Add DEX bonus
            spellDC = spellDC + Character.Selected.dexBonus
        case "CON":
            spellAttack = spellAttack + Character.Selected.conBonus //Add CON bonus
            spellDC = spellDC + Character.Selected.conBonus
        case "INT":
            spellAttack = spellAttack + Character.Selected.intBonus //Add INT bonus
            spellDC = spellDC + Character.Selected.intBonus
        case "WIS":
            spellAttack = spellAttack + Character.Selected.wisBonus //Add WIS bonus
            spellDC = spellDC + Character.Selected.wisBonus
        case "CHA":
            spellAttack = spellAttack + Character.Selected.chaBonus //Add CHA bonus
            spellDC = spellDC + Character.Selected.chaBonus
        default: break
        }
        
        spellAttack += spellcasting.attack_bonus
        spellDC += spellcasting.dc_bonus
        
        saValue.text = "+"+String(spellAttack)
        
        // Spell DC
        sdcValue.text = String(spellDC)
        
        // Caster Level
        clValue.text = String(spellcasting.caster_level)
        
        // Resource
        for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
            if resource.spellcasting == true {
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
        
        saView.layer.borderWidth = 1.0
        saView.layer.borderColor = UIColor.black.cgColor
        
        sdcView.layer.borderWidth = 1.0
        sdcView.layer.borderColor = UIColor.black.cgColor
        
        clView.layer.borderWidth = 1.0
        clView.layer.borderColor = UIColor.black.cgColor
        
        resourceView.layer.borderWidth = 1.0
        resourceView.layer.borderColor = UIColor.black.cgColor
        
        spellsTable.layer.borderWidth = 1.0
        spellsTable.layer.borderColor = UIColor.black.cgColor
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
    
    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == 409 {
            // Resource
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 402 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
    }
    
    func applyAction(button: UIButton) {
        let parentView:UIView = button.superview!
        
        switch parentView.tag {
        case 100:
            // Spell Attack
            for case let view in parentView.subviews {
                if view.tag == 107 {
                    // Misc bonus
                    let miscTextField = view as! UITextField
                    Character.Selected.spellcasting?.attack_bonus = Int32(miscTextField.text!)!
                }
                else if view.tag == 109 {
                    // seg control
                    let segControl = view as! UISegmentedControl
                    switch segControl.selectedSegmentIndex {
                    case 0:
                        // STR
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                        break
                    case 1:
                        // DEX
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                        break
                    case 2:
                        // CON
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                        break
                    case 3:
                        // INT
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                        break
                    case 4:
                        // WIS
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                        break
                    case 5:
                        // CHA
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                        break
                    default:
                        break
                    }
                }
            }
            setMiscDisplayData()
            break
            
        case 200:
            // Spell DC
            for case let view in parentView.subviews {
                if view.tag == 209 {
                    // Misc bonus
                    let miscTextField = view as! UITextField
                    Character.Selected.spellcasting?.dc_bonus = Int32(miscTextField.text!)!
                }
                else if view.tag == 211 {
                    // seg control
                    let segControl = view as! UISegmentedControl
                    switch segControl.selectedSegmentIndex {
                    case 0:
                        // STR
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "STR", context: context)
                        break
                    case 1:
                        // DEX
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "DEX", context: context)
                        break
                    case 2:
                        // CON
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CON", context: context)
                        break
                    case 3:
                        // INT
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "INT", context: context)
                        break
                    case 4:
                        // WIS
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "WIS", context: context)
                        break
                    case 5:
                        // CHA
                        Character.Selected.spellcasting?.ability = CharacterFactory.getAbility(character: Character.Selected, name: "CHA", context: context)
                        break
                    default:
                        break
                    }
                }
            }
            setMiscDisplayData()
            break
        
        case 300:
            // Caster Level
            for case let view in parentView.subviews {
                if view.tag == 302 {
                    // Caster Level
                    let clTextField = view as! UITextField
                    Character.Selected.spellcasting?.caster_level = Int32(clTextField.text!)!
                }
            }
            setMiscDisplayData()
            break
            
        case 400:
            // Resource
            var newCurrentResourceValue: Int32!
            var newDieType: Int32!
            var newMaxResourceValue: Int32!
            for case let view in parentView.subviews {
                if view.tag == 402 {
                    // Current remaining
                    let textField = view as! UITextField
                    newCurrentResourceValue = Int32(textField.text!)
                }
                else if view.tag == 404 || view.tag == 408 {
                    // Die type
                    let textField = view as! UITextField
                    newDieType = Int32(textField.text!)
                }
                else if view.tag == 406 {
                    // Max
                    let textField = view as! UITextField
                    newMaxResourceValue = Int32(textField.text!)
                }
            }
            
            for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                if resource.spellcasting == true {
                    
                    if newCurrentResourceValue == nil {
                        newCurrentResourceValue = resource.current_value
                    }
                    else if newMaxResourceValue == nil {
                        newMaxResourceValue = resource.max_value
                    }
                    else if newDieType == nil {
                        newDieType = resource.die_type
                    }
                    
                    resourceTitle.text = resource.name
                    resource.current_value = newCurrentResourceValue
                    resource.max_value = newMaxResourceValue
                    resource.die_type = newDieType
                    
                    var resourceDisplay = ""
                    if resource.die_type == 0 {
                        if resource.max_value == 0 {
                            resourceDisplay = String(resource.current_value)
                        }
                        else {
                            resourceDisplay = String(resource.current_value)+"/"+String(resource.max_value)
                        }
                    }
                    else {
                        if resource.max_value == 0 {
                            resourceDisplay = String(resource.current_value)+"d"+String(resource.die_type)
                        }
                        else {
                            resourceDisplay = String(resource.current_value)+"d"+String(resource.die_type)+"/"+String(resource.max_value)+"d"+String(resource.die_type)
                        }
                    }
                    
                    resourceValue.text = resourceDisplay
                }
            }
            break
            
        default:
            if parentView.tag >= 1000 {
                // Spell detail view
                let array = String(parentView.tag).characters.flatMap{Int(String($0))}
                let spellSection = array[0]
                let spellIndex = array [1]
                let spellLevel = spellcasting.spells_by_level?.allObjects[spellSection-1] as! Spells_by_Level
                let spell = spellLevel.spells?.allObjects[spellIndex] as! Spell
                
                let baseTag = (spellSection*1000)+(spellIndex*100)
                for case let view in parentView.subviews {
                    if let scrollView = view as? UIScrollView {
                        for case let view in scrollView.subviews {
                            if view.tag == baseTag+3 {
                                // Name - TF
                                let textField = view as! UITextField
                                spell.name = textField.text
                            }
                            else if view.tag == baseTag+5 {
                                // Concentration - Switch
                                let cSwitch = view as! UISwitch
                                spell.concentration = cSwitch.isOn
                            }
                            else if view.tag == baseTag+7 {
                                // School - TF
                                let textField = view as! UITextField
                                spell.school = textField.text
                            }
                            else if view.tag == baseTag+9 {
                                // Prepared - Switch
                                let pSwitch = view as! UISwitch
                                spell.prepared = pSwitch.isOn
                            }
                            else if view.tag == baseTag+11 {
                                // Casting Time - TF
                                let textField = view as! UITextField
                                spell.casting_time = textField.text
                            }
                            else if view.tag == baseTag+13 {
                                // Range - TF
                                let textField = view as! UITextField
                                spell.range = textField.text
                            }
                            else if view.tag == baseTag+15 {
                                // Components - TF
                                let textField = view as! UITextField
                                spell.components = textField.text
                            }
                            else if view.tag == baseTag+17 {
                                // Duration - TF
                                let textField = view as! UITextField
                                spell.duration = textField.text
                            }
                            else if view.tag == baseTag+19 {
                                // Info - TV
                                let textView = view as! UITextView
                                spell.info = textView.text
                            }
                            else if view.tag == baseTag+21 {
                                // Higher Level - TV
                                let textView = view as! UITextView
                                spell.higher_level = textView.text
                            }
                        }
                    }
                }
                
                spellLevel.removeFromSpells(spellLevel.spells?.allObjects[spellIndex] as! Spell)
                spellLevel.addToSpells(spell)
                spellcasting.removeFromSpells_by_level(spellcasting.spells_by_level?.allObjects[spellSection-1] as! Spells_by_Level)
                spellcasting.addToSpells_by_level(spellLevel)
                
                spellsTable.reloadData()
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
        let parentView:UIView = segControl.superview!
        
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
            if view.tag == 104 || view.tag == 206 {
                // Attribute Label
                let attributeLabel = view as! UILabel
                attributeLabel.text = title+"\nBonus"
            }
            else if view.tag == 105 || view.tag == 207 {
                // Attribute Textfield
                let attributeTextField = view as! UITextField
                attributeTextField.text = bonus
            }
        }
    }
    
    // Edit Spell Attack
    @IBAction func saAction(button: UIButton) {
        // Create spell attack adjusting view
        let tempView = createBasicView()
        tempView.tag = 100
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
        title.text = "Spell Attack"
        title.textAlignment = NSTextAlignment.center
        title.tag = 101
        tempView.addSubview(title)
        view.addSubview(tempView)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-105, y: 30, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = 102
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:60, width:40, height:30))
        profField.text = String(Character.Selected.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 103
        tempView.addSubview(profField)
        
        let attributeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-45, y: 30, width: 90, height: 30))
        attributeLabel.font = UIFont.systemFont(ofSize: 10)
        attributeLabel.textAlignment = NSTextAlignment.center
        attributeLabel.numberOfLines = 2
        attributeLabel.tag = 104
        tempView.addSubview(attributeLabel)
        
        let attributeField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:60, width:40, height:30))
        attributeField.textAlignment = NSTextAlignment.center
        attributeField.isEnabled = false
        attributeField.textColor = UIColor.darkGray
        attributeField.layer.borderWidth = 1.0
        attributeField.layer.borderColor = UIColor.darkGray.cgColor
        attributeField.tag = 105
        tempView.addSubview(attributeField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+15, y: 30, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 106
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+40, y:60, width:40, height:30))
        miscField.text = String((Character.Selected.spellcasting?.attack_bonus)!)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 107
        tempView.addSubview(miscField)
        
        let saLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        saLabel.text = "Spellcasting Ability"
        saLabel.textAlignment = NSTextAlignment.center
        saLabel.tag = 108
        tempView.addSubview(saLabel)
        
        var saIndex = 0
        var saText = ""
        let spellAbility = spellcasting.ability!.name!
        switch spellAbility {
        case "STR":
            saIndex = 0
            saText = "Strength"
            attributeField.text = String(Character.Selected.strBonus)
        case "DEX":
            saIndex = 1
            saText = "Dexterity"
            attributeField.text = String(Character.Selected.dexBonus)
        case "CON":
            saIndex = 2
            saText = "Constitution"
            attributeField.text = String(Character.Selected.conBonus)
        case "INT":
            saIndex = 3
            saText = "Intelligence"
            attributeField.text = String(Character.Selected.intBonus)
        case "WIS":
            saIndex = 4
            saText = "Wisdom"
            attributeField.text = String(Character.Selected.wisBonus)
        case "CHA":
            saIndex = 5
            saText = "Charisma"
            attributeField.text = String(Character.Selected.chaBonus)
        default: break
        }
        
        let sa = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        sa.insertSegment(withTitle:"STR", at:0, animated:false)
        sa.insertSegment(withTitle:"DEX", at:1, animated:false)
        sa.insertSegment(withTitle:"CON", at:2, animated:false)
        sa.insertSegment(withTitle:"INT", at:3, animated:false)
        sa.insertSegment(withTitle:"WIS", at:4, animated:false)
        sa.insertSegment(withTitle:"CHA", at:5, animated:false)
        sa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        sa.selectedSegmentIndex = saIndex
        sa.tag = 109
        tempView.addSubview(sa)
        
        attributeLabel.text = saText+"\nBonus"
    }
    
    // Edit Spell DC
    @IBAction func sdcAction(button: UIButton) {
        // Create spell DC adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Spell DC"
        title.textAlignment = NSTextAlignment.center
        title.tag = 201
        tempView.addSubview(title)
        view.addSubview(tempView)
        
        let baseLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-135, y: 30, width: 90, height: 30))
        baseLabel.text = "Base\nValue"
        baseLabel.font = UIFont.systemFont(ofSize: 10)
        baseLabel.textAlignment = NSTextAlignment.center
        baseLabel.numberOfLines = 2
        baseLabel.tag = 202
        tempView.addSubview(baseLabel)
        
        let baseField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-110, y:60, width:40, height:30))
        baseField.text = String(8)
        baseField.textAlignment = NSTextAlignment.center
        baseField.isEnabled = false
        baseField.textColor = UIColor.darkGray
        baseField.layer.borderWidth = 1.0
        baseField.layer.borderColor = UIColor.darkGray.cgColor
        baseField.tag = 203
        tempView.addSubview(baseField)
        
        let profLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 30, width: 90, height: 30))
        profLabel.text = "Proficiency\nBonus"
        profLabel.font = UIFont.systemFont(ofSize: 10)
        profLabel.textAlignment = NSTextAlignment.center
        profLabel.numberOfLines = 2
        profLabel.tag = 204
        tempView.addSubview(profLabel)
        
        let profField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:60, width:40, height:30))
        profField.text = String(Character.Selected.proficiencyBonus)
        profField.textAlignment = NSTextAlignment.center
        profField.isEnabled = false
        profField.textColor = UIColor.darkGray
        profField.layer.borderWidth = 1.0
        profField.layer.borderColor = UIColor.darkGray.cgColor
        profField.tag = 205
        tempView.addSubview(profField)
        
        let attributeLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-15, y: 30, width: 90, height: 30))
        attributeLabel.font = UIFont.systemFont(ofSize: 10)
        attributeLabel.textAlignment = NSTextAlignment.center
        attributeLabel.numberOfLines = 2
        attributeLabel.tag = 206
        tempView.addSubview(attributeLabel)
        
        let attributeField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:60, width:40, height:30))
        attributeField.textAlignment = NSTextAlignment.center
        attributeField.isEnabled = false
        attributeField.textColor = UIColor.darkGray
        attributeField.layer.borderWidth = 1.0
        attributeField.layer.borderColor = UIColor.darkGray.cgColor
        attributeField.tag = 207
        tempView.addSubview(attributeField)
        
        let miscLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+45, y: 30, width: 90, height: 30))
        miscLabel.text = "Misc\nBonus"
        miscLabel.font = UIFont.systemFont(ofSize: 10)
        miscLabel.textAlignment = NSTextAlignment.center
        miscLabel.numberOfLines = 2
        miscLabel.tag = 208
        tempView.addSubview(miscLabel)
        
        let miscField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+70, y:60, width:40, height:30))
        miscField.text = String((Character.Selected.spellcasting?.dc_bonus)!)
        miscField.textAlignment = NSTextAlignment.center
        miscField.layer.borderWidth = 1.0
        miscField.layer.borderColor = UIColor.black.cgColor
        miscField.tag = 209
        tempView.addSubview(miscField)
        
        let saLabel = UILabel.init(frame: CGRect.init(x:10, y:100, width:tempView.frame.size.width-20, height:30))
        saLabel.text = "Spellcasting Ability"
        saLabel.textAlignment = NSTextAlignment.center
        saLabel.tag = 210
        tempView.addSubview(saLabel)
        
        var saIndex = 0
        var saText = ""
        let spellAbility = spellcasting.ability!.name!
        switch spellAbility {
        case "STR":
            saIndex = 0
            saText = "Strength"
            attributeField.text = String(Character.Selected.strBonus)
        case "DEX":
            saIndex = 1
            saText = "Dexterity"
            attributeField.text = String(Character.Selected.dexBonus)
        case "CON":
            saIndex = 2
            saText = "Constitution"
            attributeField.text = String(Character.Selected.conBonus)
        case "INT":
            saIndex = 3
            saText = "Intelligence"
            attributeField.text = String(Character.Selected.intBonus)
        case "WIS":
            saIndex = 4
            saText = "Wisdom"
            attributeField.text = String(Character.Selected.wisBonus)
        case "CHA":
            saIndex = 5
            saText = "Charisma"
            attributeField.text = String(Character.Selected.chaBonus)
        default: break
        }
        
        let sa = UISegmentedControl.init(frame: CGRect.init(x:10, y:135, width:tempView.frame.size.width-20, height:30))
        sa.insertSegment(withTitle:"STR", at:0, animated:false)
        sa.insertSegment(withTitle:"DEX", at:1, animated:false)
        sa.insertSegment(withTitle:"CON", at:2, animated:false)
        sa.insertSegment(withTitle:"INT", at:3, animated:false)
        sa.insertSegment(withTitle:"WIS", at:4, animated:false)
        sa.insertSegment(withTitle:"CHA", at:5, animated:false)
        sa.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        sa.selectedSegmentIndex = saIndex
        sa.tag = 211
        tempView.addSubview(sa)
        
        attributeLabel.text = saText+"\nBonus"
    }
    
    // Edit Caster Level
    @IBAction func clAction(button: UIButton) {
        // Create caster level adjusting view
        let tempView = createBasicView()
        tempView.tag = 300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Caster Level"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        tempView.addSubview(title)
        view.addSubview(tempView)
        
        let clField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:50, width:40, height:30))
        let casterLevel = spellcasting.caster_level
        clField.text = String(casterLevel)
        clField.textAlignment = NSTextAlignment.center
        clField.layer.borderWidth = 1.0
        clField.layer.borderColor = UIColor.black.cgColor
        clField.tag = 302
        tempView.addSubview(clField)
    }
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        // Create resource adjusting view
        let tempView = createBasicView()
        tempView.tag = 400
        
        for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
            if resource.spellcasting == true {
                let currentResourceValue: Int32 = resource.current_value
                let maxResourceValue: Int32 = resource.max_value
                let dieType: Int32 = resource.die_type
                
                let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
                title.text = resource.name
                title.textAlignment = NSTextAlignment.center
                title.tag = 401
                tempView.addSubview(title)
                
                if dieType == 0 {
                    if maxResourceValue == 0 {
                        // current
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-20, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 402
                        tempView.addSubview(currentResource)
                    }
                    else {
                        // current / max
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 402
                        tempView.addSubview(currentResource)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 405
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 406
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
                        currentResource.tag = 402
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 403
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 404
                        tempView.addSubview(rd1)
                    }
                    else {
                        // current d die / max d die
                        let currentResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:35, width:40, height:30))
                        currentResource.text = String(currentResourceValue)
                        currentResource.textAlignment = NSTextAlignment.center
                        currentResource.layer.borderWidth = 1.0
                        currentResource.layer.borderColor = UIColor.black.cgColor
                        currentResource.tag = 402
                        tempView.addSubview(currentResource)
                        
                        let d1 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:35, width:30, height:30))
                        d1.text = "d"
                        d1.textAlignment = NSTextAlignment.center
                        d1.tag = 403
                        tempView.addSubview(d1)
                        
                        let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
                        rd1.text = String(dieType)
                        rd1.textAlignment = NSTextAlignment.center
                        rd1.isUserInteractionEnabled = false
                        rd1.textColor = UIColor.darkGray
                        rd1.layer.borderWidth = 1.0
                        rd1.layer.borderColor = UIColor.darkGray.cgColor
                        rd1.tag = 404
                        tempView.addSubview(rd1)
                        
                        let slash = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-15, y:35, width:30, height:30))
                        slash.text = "/"
                        slash.textAlignment = NSTextAlignment.center
                        slash.tag = 405
                        tempView.addSubview(slash)
                        
                        let maxResource = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+10, y:35, width:40, height:30))
                        maxResource.text = String(maxResourceValue)
                        maxResource.textAlignment = NSTextAlignment.center
                        maxResource.layer.borderWidth = 1.0
                        maxResource.layer.borderColor = UIColor.black.cgColor
                        maxResource.tag = 406
                        tempView.addSubview(maxResource)
                        
                        let d2 = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+50, y:35, width:30, height:30))
                        d2.text = "d"
                        d2.textAlignment = NSTextAlignment.center
                        d2.tag = 407
                        tempView.addSubview(d2)
                        
                        let rd2 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:35, width:40, height:30))
                        rd2.text = String(dieType)
                        rd2.textAlignment = NSTextAlignment.center
                        rd2.layer.borderWidth = 1.0
                        rd2.layer.borderColor = UIColor.black.cgColor
                        rd2.tag = 408
                        tempView.addSubview(rd2)
                    }
                }
                
                let stepper = UIStepper.init(frame: CGRect.init(x:tempView.frame.size.width/2-47, y:90, width:94, height:29))
                stepper.value = Double(currentResourceValue)
                stepper.minimumValue = 0
                stepper.maximumValue = Double(maxResourceValue)
                stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
                stepper.tag = 409
                tempView.addSubview(stepper)
            }
        }
        view.addSubview(tempView)
    }
    
    // UITableView Delegate & Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return spellcasting.spells_by_level?.allObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != spellcasting.spells_by_level?.allObjects.count {
            let spellLevel = spellcasting.spells_by_level?.allObjects[section] as! Spells_by_Level
            let expanded = spellLevel.expanded
            if expanded {
                return (spellLevel.spells?.allObjects.count ?? 0)!+1+1
            }
            else {
                return 1
            }
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != spellcasting.spells_by_level?.allObjects.count {
            if indexPath.row == 0 {
                // spell level cell
                return 30
            }
            else {
                let spellLevel = spellcasting.spells_by_level?.allObjects[indexPath.section] as! Spells_by_Level
                if indexPath.row == (spellLevel.spells?.allObjects.count)!+1 {
                    // new spell cell
                    return 30
                }
                else {
                    // spell cell
                    let spell = spellLevel.spells?.allObjects[indexPath.row-1] as! Spell
                    
                    let expanded = spell.expanded
                    if expanded {
                        let nameHeight = spell.name?.heightWithConstrainedWidth(width: view.frame.width-40, font: UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold))
                        let schoolHeight = spell.school?.heightWithConstrainedWidth(width: view.frame.width-40, font: UIFont.systemFont(ofSize: 17))
                        let castingHeight = spell.casting_time?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                        let rangeHeight = spell.range?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                        let componentsHeight = spell.components?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                        let durationHeight = spell.duration?.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17))
                        var descriptionHeight: CGFloat = 0
                        if spell.higher_level == "" {
                            descriptionHeight = (spell.info!.heightWithConstrainedWidth(width: view.frame.width-10, font: UIFont.systemFont(ofSize: 17)))
                            descriptionHeight += 70
                        }
                        else {
                            let boldText = "At Higher Levels."
                            let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
                            let attributedString = NSMutableAttributedString(string:spell.info!+"\n", attributes:attrs)
                            let attributedHeight = attributedString.heightWithConstrainedWidth(width: view.frame.width-10)
                            
                            let boldAttrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
                            let boldString = NSMutableAttributedString(string:boldText, attributes:boldAttrs)
                            let boldHeight = boldString.heightWithConstrainedWidth(width: view.frame.width-10)
                            
                            attributedString.append(boldString)
                            let attributedString2 = NSMutableAttributedString(string:"" + spell.higher_level!, attributes:attrs)
                            let attributedHeight2 = attributedString2.heightWithConstrainedWidth(width: view.frame.width-10)
                            attributedString.append(attributedString2)
                            
                            descriptionHeight = attributedHeight + boldHeight + attributedHeight2
                        }
                        
                        var height = nameHeight! + schoolHeight!
                        height += castingHeight!
                        height += rangeHeight!
                        height += componentsHeight!
                        height += durationHeight!
                        height += descriptionHeight
                        height += 35
                        
                        return height
                    }
                    else {
                        return 35
                    }
                }
            }
        }
        else {
            // new spell cell
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != spellcasting.spells_by_level?.allObjects.count {
            let spellLevel = spellcasting.spells_by_level?.allObjects[indexPath.section] as! Spells_by_Level
            let remainingSlots = spellLevel.remaining_slots
            let totalSlots = spellLevel.total_slots
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpellLevelTableViewCell", for: indexPath) as! SpellLevelTableViewCell
                cell.parentViewController = self
                cell.spellLevelContent = spellLevel
                
                // 1st, 2nd, 3rd, 4th, 5th, 6th, 7th, 8th, 9th
                var suffix = ""
                switch spellLevel.level {
                case 1:
                    suffix = "st"
                case 2:
                    suffix = "nd"
                case 3:
                    suffix = "rd"
                default:
                    suffix = "th"
                }
                if spellLevel.level == 0 {
                    cell.spellLevel.text = "Cantrips"
                    cell.spellSlots.isHidden = true
                }
                else {
                    cell.spellLevel.text = String(spellLevel.level)+suffix+" Level Spells"
                    cell.spellSlots.setTitle(String(remainingSlots)+"/"+String(totalSlots), for: UIControlState.normal)
                }
                return cell
            }
            else if indexPath.row == (spellLevel.spells?.allObjects.count)!+1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
                    return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SpellTableViewCell", for: indexPath) as! SpellTableViewCell
                
                cell.level = indexPath.section
                cell.parentViewController = self
                
                let spell = spellLevel.spells?.allObjects[indexPath.row-1] as! Spell
                cell.spellName.text = spell.name
                cell.spellSchool.text = spell.school
                cell.castingTime.text = spell.casting_time
                cell.range.text = spell.range
                cell.components.text = spell.components
                cell.duration.text = spell.duration
                cell.concentration.isHidden = !spell.concentration
                if spell.higher_level == "" {
                    cell.spellDescription.text = spell.info
                }
                else {
                    let boldText = "At Higher Levels."
                    let attrs = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]
                    let attributedString = NSMutableAttributedString(string:spell.info!+"\n")
                    let boldString = NSMutableAttributedString(string:boldText, attributes:attrs)
                    attributedString.append(boldString)
                    let attributedString2 = NSMutableAttributedString(string:" "+spell.higher_level!)
                    attributedString.append(attributedString2)
                    cell.spellDescription.attributedText = attributedString
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell", for: indexPath) as! NewTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section != spellcasting.spells_by_level?.allObjects.count {
            let spellLevel = spellcasting.spells_by_level?.allObjects[indexPath.section] as! Spells_by_Level
            if indexPath.row == 0 {
                // Spell Level
                var expanded = spellLevel.expanded
                expanded = !expanded
                spellLevel.expanded = expanded
                tableView.reloadData()
            }
            else if indexPath.row == (spellLevel.spells?.allObjects.count)!+1 {
                // New Spell
                let baseTag = (1000 * ((indexPath.section)+1)) + (100*((indexPath.row)-1))
                createNewSpell(spellLevel: spellLevel, baseTag: baseTag)
            }
            else {
                // Spell
                let spell = spellLevel.spells?.allObjects[indexPath.row-1] as! Spell
                var expanded = spell.expanded
                expanded = !expanded
                spell.expanded = expanded
                tableView.reloadData()
            }
        }
        else {
            // New
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Create New Spell
    func createNewSpell(spellLevel: Spells_by_Level, baseTag: Int) {
        let tempView = createBasicView()
        tempView.tag = baseTag
        
        newSpell = true
        
        // 1st, 2nd, 3rd, 4th, 5th, 6th, 7th, 8th, 9th
        var spellLevelStr = ""
        var suffix = ""
        switch spellLevel.level {
        case 1:
            suffix = "st"
        case 2:
            suffix = "nd"
        case 3:
            suffix = "rd"
        default:
            suffix = "th"
        }
        if spellLevel.level == 0 {
            spellLevelStr = "Cantrip"
        }
        else {
            spellLevelStr = String(spellLevel.level)+suffix+" Level Spell"
        }
        
        let newLabel = UILabel(frame: CGRect.init(x: 10, y: 5, width: tempView.frame.size.width - 20, height: 30))
        newLabel.text = "New " + spellLevelStr
        newLabel.textAlignment = NSTextAlignment.center
        newLabel.font = UIFont.systemFont(ofSize: 14)
        tempView.addSubview(newLabel)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 45, width: tempView.frame.size.width, height: tempView.frame.size.height-50-50))
        scrollView.tag = baseTag
        tempView.addSubview(scrollView)
        
        createNewSpell(spellLevel: spellLevel, baseTag: baseTag, scrollView: scrollView)
        
        view.addSubview(tempView)
    }
    
    func createNewSpell(spellLevel: Spells_by_Level, baseTag: Int, scrollView: UIScrollView) {
        let customLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 70, height: 30))
        customLabel.text = "Custom"
        customLabel.textAlignment = .right
        customLabel.tag = baseTag + 1
        scrollView.addSubview(customLabel)
        
        let customSwitch = UISwitch(frame: CGRect(x: 85, y: 5, width: 51, height: 31))
        customSwitch.isOn = newSpellCustom
        customSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        customSwitch.tag = baseTag + 2
        scrollView.addSubview(customSwitch)
        
        let spellPickerView = UIPickerView.init(frame: CGRect.init(x: 10, y: 40, width: scrollView.frame.size.width-20, height: 60))
        spellPickerView.dataSource = self
        spellPickerView.delegate = self
        spellPickerView.layer.borderWidth = 1.0
        spellPickerView.layer.borderColor = UIColor.black.cgColor
        spellPickerView.isUserInteractionEnabled = !newSpellCustom
        spellPickerView.tag = baseTag + 3
//        spellPickerView.selectRow(0, inComponent: 0, animated: false)
        scrollView.addSubview(spellPickerView)
        
        // Concentration - switch
        let concentrationLabel = UILabel(frame: CGRect.init(x: scrollView.frame.size.width - 100, y: 110, width: 80, height: 20))
        concentrationLabel.text = "Concentration"
        concentrationLabel.font = UIFont.systemFont(ofSize: 10)
        concentrationLabel.textAlignment = NSTextAlignment.right
        concentrationLabel.numberOfLines = 1
        concentrationLabel.tag = baseTag + 4
        scrollView.addSubview(concentrationLabel)
        
        let concentrationSwitch = UISwitch(frame: CGRect.init(x: scrollView.frame.size.width - 71, y: 130, width:51, height:31))
        concentrationSwitch.isOn = true//spell.concentration
        concentrationSwitch.tag = baseTag + 5
        scrollView.addSubview(concentrationSwitch)
        
        // School - tf
        let schoolLabel = UILabel.init(frame: CGRect.init(x: 20, y: 110, width: scrollView.frame.size.width-140, height: 20))
        schoolLabel.text = "School"
        schoolLabel.font = UIFont.systemFont(ofSize: 10)
        schoolLabel.textAlignment = NSTextAlignment.left
        schoolLabel.numberOfLines = 1
        schoolLabel.tag = baseTag + 6
        scrollView.addSubview(schoolLabel)
        
        let schoolPickerView = UIPickerView.init(frame: CGRect.init(x:20, y: 126, width:scrollView.frame.size.width-120, height:36))
        schoolPickerView.dataSource = self
        schoolPickerView.delegate = self
        schoolPickerView.layer.borderWidth = 1.0
        schoolPickerView.layer.borderColor = UIColor.black.cgColor
        schoolPickerView.isUserInteractionEnabled = newSpellCustom
//        schoolPickerView.selectRow(0, inComponent: 0, animated: false)
        schoolPickerView.tag = baseTag + 7
        scrollView.addSubview(schoolPickerView)
        
        // Prepared - switch
        let preparedLabel = UILabel(frame: CGRect.init(x: scrollView.frame.size.width - 100, y: 170, width: 80, height: 20))
        preparedLabel.text = "Prepared"
        preparedLabel.font = UIFont.systemFont(ofSize: 10)
        preparedLabel.textAlignment = NSTextAlignment.right
        preparedLabel.numberOfLines = 1
        preparedLabel.tag = baseTag + 8
        scrollView.addSubview(preparedLabel)
        
        let preparedSwitch = UISwitch(frame: CGRect.init(x: scrollView.frame.size.width - 71, y: 190, width:51, height:31))
        preparedSwitch.isOn = true//spell.prepared
        preparedSwitch.tag = baseTag + 9
        scrollView.addSubview(preparedSwitch)
        
        // Casting time - tf
        let castingLabel = UILabel.init(frame: CGRect.init(x: 20, y: 170, width: scrollView.frame.size.width-140, height: 20))
        castingLabel.text = "Casting Time"
        castingLabel.font = UIFont.systemFont(ofSize: 10)
        castingLabel.textAlignment = NSTextAlignment.left
        castingLabel.numberOfLines = 1
        castingLabel.tag = baseTag + 10
        scrollView.addSubview(castingLabel)
        
        let castingField = UITextField.init(frame: CGRect.init(x:20, y:190, width: scrollView.frame.size.width-120, height: 30))
        castingField.text = ""//spell.casting_time
        castingField.textAlignment = NSTextAlignment.left
        castingField.isEnabled = false
        castingField.textColor = UIColor.black
        castingField.layer.borderWidth = 1.0
        castingField.layer.borderColor = UIColor.black.cgColor
        castingField.tag = baseTag + 11
        scrollView.addSubview(castingField)
        
        // Range - tf
        let rangeLabel = UILabel.init(frame: CGRect.init(x: 20, y: 230, width: scrollView.frame.size.width-40, height: 20))
        rangeLabel.text = "Range"
        rangeLabel.font = UIFont.systemFont(ofSize: 10)
        rangeLabel.textAlignment = NSTextAlignment.left
        rangeLabel.numberOfLines = 1
        rangeLabel.tag = baseTag + 12
        scrollView.addSubview(rangeLabel)
        
        let rangeField = UITextField.init(frame: CGRect.init(x: 20, y: 250, width: scrollView.frame.size.width-40, height: 30))
        rangeField.text = ""//spell.range
        rangeField.textAlignment = NSTextAlignment.left
        rangeField.isEnabled = true
        rangeField.textColor = UIColor.black
        rangeField.layer.borderWidth = 1.0
        rangeField.layer.borderColor = UIColor.black.cgColor
        rangeField.tag = baseTag + 13
        scrollView.addSubview(rangeField)
        
        // Components - tf
        let componentsLabel = UILabel.init(frame: CGRect.init(x: 20, y: 290, width: scrollView.frame.size.width-40, height: 20))
        componentsLabel.text = "Components"
        componentsLabel.font = UIFont.systemFont(ofSize: 10)
        componentsLabel.textAlignment = NSTextAlignment.left
        componentsLabel.numberOfLines = 1
        componentsLabel.tag = baseTag + 14
        scrollView.addSubview(componentsLabel)
        
        let componentsField = UITextField.init(frame: CGRect.init(x:20, y:310, width:scrollView.frame.size.width-40, height:30))
        componentsField.text = ""//spell.components
        componentsField.textAlignment = NSTextAlignment.left
        componentsField.isEnabled = true
        componentsField.textColor = UIColor.black
        componentsField.layer.borderWidth = 1.0
        componentsField.layer.borderColor = UIColor.black.cgColor
        componentsField.tag = baseTag + 15
        scrollView.addSubview(componentsField)
        
        // Duration - tf
        let durationLabel = UILabel.init(frame: CGRect.init(x: 20, y: 350, width: scrollView.frame.size.width-40, height: 20))
        durationLabel.text = "Duration"
        durationLabel.font = UIFont.systemFont(ofSize: 10)
        durationLabel.textAlignment = NSTextAlignment.left
        durationLabel.numberOfLines = 1
        durationLabel.tag = baseTag + 16
        scrollView.addSubview(durationLabel)
        
        let durationField = UITextField.init(frame: CGRect.init(x:20, y:370, width:scrollView.frame.size.width-40, height:30))
        durationField.text = ""//spell.duration
        durationField.textAlignment = NSTextAlignment.left
        durationField.isEnabled = true
        durationField.textColor = UIColor.black
        durationField.layer.borderWidth = 1.0
        durationField.layer.borderColor = UIColor.black.cgColor
        durationField.tag = baseTag + 17
        scrollView.addSubview(durationField)
        
        // Info - tv
        let infoLabel = UILabel.init(frame: CGRect.init(x: 20, y: 410, width: scrollView.frame.size.width-40, height: 20))
        infoLabel.text = "Description"
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = NSTextAlignment.left
        infoLabel.numberOfLines = 1
        infoLabel.tag = baseTag + 18
        scrollView.addSubview(infoLabel)
        
        let infoView = UITextView.init(frame: CGRect.init(x: 20, y: 430, width: scrollView.frame.size.width-40, height: 100))
        infoView.text = ""//spell.info
        infoView.textColor = UIColor.black
        infoView.layer.borderWidth = 1.0
        infoView.layer.borderColor = UIColor.black.cgColor
        infoView.tag = baseTag + 19
        
        let infoContentSize = infoView.sizeThatFits(infoView.bounds.size)
        var infoFrame = infoView.frame
        infoFrame.size.height = infoContentSize.height
        infoView.frame = infoFrame
        
        scrollView.addSubview(infoView)
        
        // Higher level - tv
        let hlLabel = UILabel.init(frame: CGRect.init(x: 20, y: infoView.frame.origin.y + infoView.frame.size.height, width: scrollView.frame.size.width-40, height: 20))
        hlLabel.text = "Higher Level"
        hlLabel.font = UIFont.systemFont(ofSize: 10)
        hlLabel.textAlignment = NSTextAlignment.left
        hlLabel.numberOfLines = 1
        hlLabel.tag = baseTag + 20
        scrollView.addSubview(hlLabel)
        
        let hlView = UITextView.init(frame: CGRect.init(x: 20, y: hlLabel.frame.origin.y + hlLabel.frame.size.height, width: scrollView.frame.size.width-40, height: 50))
        hlView.text = ""//spell.higher_level
        hlView.textColor = UIColor.black
        hlView.layer.borderWidth = 1.0
        hlView.layer.borderColor = UIColor.black.cgColor
        hlView.tag = baseTag + 21
        
        let hlContentSize = hlView.sizeThatFits(hlView.bounds.size)
        var hlFrame = hlView.frame
        hlFrame.size.height = hlContentSize.height
        hlView.frame = hlFrame
        
        scrollView.addSubview(hlView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: hlView.frame.origin.y + hlView.frame.size.height + 10)
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
            
            newSpellCustom = sender.isOn
            let spellLevel = spellcasting.spells_by_level?.allObjects[baseTag/1000] as! Spells_by_Level
            createNewSpell(spellLevel: spellLevel, baseTag: baseTag, scrollView: parentView as! UIScrollView)
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
            if pickerView.tag == (baseTag)! + 3 {
                return Types.SpellSchoolStrings.count
            }
            else {
                return Types.SpellSchoolStrings.count
            }
        }
        else {
            return Types.SpellSchoolStrings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.superview != nil {
            let parentView = pickerView.superview
            let baseTag = parentView?.tag
            if pickerView.tag == baseTag! + 9 {
//                appDelegate.character. = Types.SpellSchoolStrings[row] as? String
            }
            else {
//                appDelegate.character. = Types.SpellSchoolStrings[row] as? String
            }
        }
        else {
//            appDelegate.character. = Types.SpellSchoolStrings[row] as? String
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
            
            if pickerView.tag == baseTag! + 3 {
                if newSpellCustom == true {
                    pickerLabel?.textColor = UIColor.darkGray
                }
                else {
                    pickerLabel?.textColor = UIColor.black
                }
                
                pickerLabel?.text = Types.SpellSchoolStrings[row]
            }
            else {
                pickerLabel?.textColor = UIColor.black
                pickerLabel?.text = Types.SpellSchoolStrings[row]
            }
        }
        else {
            pickerLabel?.textColor = UIColor.black
            pickerLabel?.text = Types.SpellSchoolStrings[row]
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

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}
