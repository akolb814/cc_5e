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
    var hpEffectValue = 0
    let damageTypes = ["Bludgeoning", "Piercing", "Slashing", "Acid", "Cold", "Fire", "Force", "Lightning", "Necrotic", "Poison", "Psychic", "Radiant", "Thunder"]
    
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
            hpValue.text = String(appDelegate.character.currentHP)+"/"+String(appDelegate.character.maxHP)
            
            if appDelegate.character.currentHP == 0 {
                // Death Saves
            }
            break
            
        case 200:
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
            break
            
        case 300:
            // Proficiency Bonus
            profValue.text = "+"+String(appDelegate.character.proficiencyBonus)
            break
            
        case 400:
            // Armor Class
            acValue.text = String(appDelegate.character.AC)
            break
            
        case 500:
            // Speed
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
            break
            
        case 600:
            // Initiative
            if appDelegate.character.initiative < 0 {
                initValue.text = String(appDelegate.character.initiative)
            }
            else {
                initValue.text = "+"+String(appDelegate.character.initiative)
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
    
    // Edit Resource
    @IBAction func resourceAction(button: UIButton) {
        // Create resource adjusting view
        let tempView = createBasicView()
        tempView.tag = 200
        
        let currentResourceValue: Int = appDelegate.character.martialResource["current_value"].int!
        let maxResourceValue: Int = appDelegate.character.martialResource["max_value"].int!
        let dieType: Int = appDelegate.character.martialResource["die_type"].int!
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = appDelegate.character.martialResource["name"].string
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
                
                let rd1 = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:35, width:40, height:30))
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
        profField.text = String(appDelegate.character.proficiencyBonus)
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
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Armor Class"
        title.textAlignment = NSTextAlignment.center
        title.tag = 401
        tempView.addSubview(title)
        
        // Armor value, Shield Value, Dex Bonus, Max Dex, Misc Mod, Additional Ability Mod (Monk/Barb)
        
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
        profField.text = String(appDelegate.character.proficiencyBonus)
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
        dexField.text = String(appDelegate.character.dexBonus)
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
        miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
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
        
        if indexPath.section == 0 {
            let tempView = createBasicView()
            tempView.tag = 700 + (indexPath.row * 100)
            
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
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let title = UITextField.init(frame: CGRect.init(x:10, y:5, width:tempView.frame.size.width-20, height:30))
            title.text = weapon["name"].string?.capitalized
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
            reachField.text = weapon["range"].string!
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
            scrollView.addSubview(damageTypePickerView)
            
            let attackLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: tempView.frame.size.width-20, height: 30))
            attackLabel.text = "Attack Ability"
            attackLabel.textAlignment = NSTextAlignment.center
            attackLabel.tag = 700 + (indexPath.row * 100) + 6
            scrollView.addSubview(attackLabel)
            
            var aaIndex = 0
            switch abilityType {
            case "STR":
                aaIndex = 0
//                attributeField.text = String(appDelegate.character.strBonus)
            case "DEX":
                aaIndex = 1
//                attributeField.text = String(appDelegate.character.dexBonus)
            case "CON":
                aaIndex = 2
//                attributeField.text = String(appDelegate.character.conBonus)
            case "INT":
                aaIndex = 3
//                attributeField.text = String(appDelegate.character.intBonus)
            case "WIS":
                aaIndex = 4
//                attributeField.text = String(appDelegate.character.wisBonus)
            case "CHA":
                aaIndex = 5
//                attributeField.text = String(appDelegate.character.chaBonus)
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
            profField.text = String(appDelegate.character.proficiencyBonus)
            profField.textAlignment = NSTextAlignment.center
            profField.isEnabled = false
            profField.textColor = UIColor.darkGray
            profField.layer.borderWidth = 1.0
            profField.layer.borderColor = UIColor.darkGray.cgColor
            profField.tag = 700 + (indexPath.row * 100) + 9
            scrollView.addSubview(profField)
            
            let dexLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-75, y: 145, width: 90, height: 30))
            dexLabel.text = "Dexterity\nBonus"
            dexLabel.font = UIFont.systemFont(ofSize: 10)
            dexLabel.textAlignment = NSTextAlignment.center
            dexLabel.numberOfLines = 2
            dexLabel.tag = 700 + (indexPath.row * 100) + 10
            scrollView.addSubview(dexLabel)
            
            let dexField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-50, y:170, width:40, height:30))
            dexField.text = String(appDelegate.character.dexBonus)
            dexField.textAlignment = NSTextAlignment.center
            dexField.layer.borderWidth = 1.0
            dexField.layer.borderColor = UIColor.black.cgColor
            dexField.tag = 700 + (indexPath.row * 100) + 11
            scrollView.addSubview(dexField)
            
            let magicLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 145, width: 90, height: 30))
            magicLabel.text = "Magic Item\nAttack Bonus"
            magicLabel.font = UIFont.systemFont(ofSize: 10)
            magicLabel.textAlignment = NSTextAlignment.center
            magicLabel.numberOfLines = 2
            magicLabel.tag = 700 + (indexPath.row * 100) + 12
            scrollView.addSubview(magicLabel)
            
            let magicField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:170, width:40, height:30))
            magicField.text = String(0)//String(appDelegate.character.miscInitBonus)
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
            miscField.text = String(0)//String(appDelegate.character.miscInitBonus)
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
            profWithSwitch.isOn = false
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
            abilityDmgSwitch.isOn = false
            abilityDmgSwitch.tag = 1109
            scrollView.addSubview(abilityDmgSwitch)
            
            let magicDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2-10, y: 205, width: 90, height: 40))
            magicDmgLabel.text = "Magic Item\nDamage\nBonus"
            magicDmgLabel.font = UIFont.systemFont(ofSize: 10)
            magicDmgLabel.textAlignment = NSTextAlignment.center
            magicDmgLabel.numberOfLines = 3
            magicDmgLabel.tag = 700 + (indexPath.row * 100) + 19
            scrollView.addSubview(magicDmgLabel)
            
            let magicDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+15, y:245, width:40, height:30))
            magicDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
            magicDmgField.textAlignment = NSTextAlignment.center
            magicDmgField.layer.borderWidth = 1.0
            magicDmgField.layer.borderColor = UIColor.black.cgColor
            magicDmgField.tag = 700 + (indexPath.row * 100) + 20
            scrollView.addSubview(magicDmgField)
            
            let miscDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+55, y: 205, width: 90, height: 40))
            miscDmgLabel.text = "Misc\nDamage\nBonus"
            miscDmgLabel.font = UIFont.systemFont(ofSize: 10)
            miscDmgLabel.textAlignment = NSTextAlignment.center
            miscDmgLabel.numberOfLines = 3
            miscDmgLabel.tag = 700 + (indexPath.row * 100) + 21
            scrollView.addSubview(miscDmgLabel)
            
            let miscDmgField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:245, width:40, height:30))
            miscDmgField.text = String(0)//String(appDelegate.character.miscInitBonus)
            miscDmgField.textAlignment = NSTextAlignment.center
            miscDmgField.layer.borderWidth = 1.0
            miscDmgField.layer.borderColor = UIColor.black.cgColor
            miscDmgField.tag = 700 + (indexPath.row * 100) + 22
            scrollView.addSubview(miscDmgField)
            
            let weaponDmgLabel = UILabel.init(frame: CGRect.init(x: 10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
            weaponDmgLabel.text = "Weapon Damage Die"
            weaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
            weaponDmgLabel.textAlignment = NSTextAlignment.center
            weaponDmgLabel.tag = 700 + (indexPath.row * 100) + 23
            scrollView.addSubview(weaponDmgLabel)
            
            let extraWeaponDmgLabel = UILabel.init(frame: CGRect.init(x: tempView.frame.size.width/2+10, y: 280, width: tempView.frame.size.width/2-20, height: 30))
            extraWeaponDmgLabel.text = "Extra Damage Die"
            extraWeaponDmgLabel.font = UIFont.systemFont(ofSize: 10)
            extraWeaponDmgLabel.textAlignment = NSTextAlignment.center
            extraWeaponDmgLabel.tag = 700 + (indexPath.row * 100) + 24
            scrollView.addSubview(extraWeaponDmgLabel)
            
            let weaponDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-120, y:320, width:40, height:30))
            weaponDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
            weaponDieAmount.textAlignment = NSTextAlignment.center
            weaponDieAmount.layer.borderWidth = 1.0
            weaponDieAmount.layer.borderColor = UIColor.black.cgColor
            weaponDieAmount.tag = 700 + (indexPath.row * 100) + 25
            scrollView.addSubview(weaponDieAmount)
            
            let weaponD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2-80, y:320, width:20, height:30))
            weaponD.text = "d"
            weaponD.textAlignment = NSTextAlignment.center
            weaponD.tag = 700 + (indexPath.row * 100) + 26
            scrollView.addSubview(weaponD)
            
            let weaponDie = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2-60, y:320, width:40, height:30))
            weaponDie.text = String(6)//String(appDelegate.character.miscInitBonus)
            weaponDie.textAlignment = NSTextAlignment.center
            weaponDie.layer.borderWidth = 1.0
            weaponDie.layer.borderColor = UIColor.black.cgColor
            weaponDie.tag = 700 + (indexPath.row * 100) + 27
            scrollView.addSubview(weaponDie)
            
            let extraDieSwitch = UISwitch.init(frame: CGRect.init(x: tempView.frame.size.width/2+40, y: 305, width:51, height:31))
            extraDieSwitch.isOn = false
            extraDieSwitch.tag = 700 + (indexPath.row * 100) + 28
            scrollView.addSubview(extraDieSwitch)
            
            let extraDieAmount = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+20, y:340, width:40, height:30))
            extraDieAmount.text = String(1)//String(appDelegate.character.miscInitBonus)
            extraDieAmount.textAlignment = NSTextAlignment.center
            extraDieAmount.layer.borderWidth = 1.0
            extraDieAmount.layer.borderColor = UIColor.black.cgColor
            extraDieAmount.tag = 700 + (indexPath.row * 100) + 29
            scrollView.addSubview(extraDieAmount)
            
            let extraD = UILabel.init(frame: CGRect.init(x:tempView.frame.size.width/2+60, y:340, width:20, height:30))
            extraD.text = "d"
            extraD.textAlignment = NSTextAlignment.center
            extraD.tag = 700 + (indexPath.row * 100) + 30
            scrollView.addSubview(extraD)
            
            let extraDieField = UITextField.init(frame: CGRect.init(x:tempView.frame.size.width/2+80, y:340, width:40, height:30))
            extraDieField.text = String(6)//String(appDelegate.character.miscInitBonus)
            extraDieField.textAlignment = NSTextAlignment.center
            extraDieField.layer.borderWidth = 1.0
            extraDieField.layer.borderColor = UIColor.black.cgColor
            extraDieField.tag = 700 + (indexPath.row * 100) + 31
            scrollView.addSubview(extraDieField)
            
            scrollView.contentSize = CGSize.init(width: tempView.frame.size.width, height: 380)
            
            view.addSubview(tempView)
        }
        else {
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return damageTypes.count
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
        
        pickerLabel?.text = damageTypes[row]
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

