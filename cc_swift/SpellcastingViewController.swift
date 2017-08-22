//
//  SpellcastingViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class SpellcastingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //spellcasting = SpellcastingFactory.getEmptySpellcasting(context: context)
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
            // HD
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
            
            break
            
        case 200:
            
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
        miscField.text = String(0)//String(Character.Selected.miscInitBonus)
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
        sa.tag = 108
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
        miscField.text = String(0)//Character.Selected.spellcasting?.dc_bonus)
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
        // Create spell attack adjusting view
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
        // Create spell attack adjusting view
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
                return (spellLevel.spells?.allObjects.count ?? 0)!+1
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
                // spell cell
                let spellLevel = spellcasting.spells_by_level?.allObjects[indexPath.section] as! Spells_by_Level
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
            var spellLevel = spellcasting.spells_by_level?.allObjects[indexPath.section] as! Spells_by_Level
            if indexPath.row == 0 {
                // Spell Level
                var expanded = spellLevel.expanded
                expanded = !expanded
                spellLevel.expanded = expanded
                //spellcastingDict.spells_by_level?.allObjects[indexPath.section] = spellLevelDict
                tableView.reloadData()
            }
            else {
                // Spell
                var spell = spellLevel.spells?.allObjects[indexPath.row-1] as! Spell
                var expanded = spell.expanded
                expanded = !expanded
                spell.expanded = expanded
                //spellLevelDict["prepared_spells"][indexPath.row-1] = spellDict
                //spellcastingDict["spells"][indexPath.section] = spellLevelDict
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
