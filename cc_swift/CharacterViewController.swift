//
//  TabViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 2/13/17.
//
//

import UIKit

class CharacterViewController: UITabBarController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var longRest = false
    var hpEffectValue: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.title = Character.Selected.name
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue:"ChangeName"), object: nil, queue: nil, using: changeName)
        nc.addObserver(forName: Notification.Name(rawValue:"LevelUp"), object: nil, queue: nil, using: levelUp)
        nc.addObserver(forName: Notification.Name(rawValue:"Rest"), object: nil, queue: nil, using: rest)
        nc.addObserver(forName: Notification.Name(rawValue:"ExportCharacter"), object: nil, queue: nil, using: exportCharacter)
        nc.addObserver(forName: Notification.Name(rawValue:"Help"), object: nil, queue: nil, using: help)
    }
    
    func changeName(notification: Notification) -> Void {
        let tempView = createBasicView()
        tempView.tag = 100
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Change Name"
        title.textAlignment = NSTextAlignment.center
        title.tag = 101
        tempView.addSubview(title)
        
        let newName = UITextField.init(frame: CGRect.init(x:10, y:35, width:tempView.frame.size.width-20, height:30))
        newName.text = String("")
        newName.textAlignment = NSTextAlignment.center
        newName.layer.borderWidth = 1.0
        newName.layer.borderColor = UIColor.black.cgColor
        newName.tag = 102
        newName.delegate = self
        tempView.addSubview(newName)
        newName.becomeFirstResponder()
        
        view.addSubview(tempView)
    }
    
    func levelUp(notification: Notification) -> Void {
        let tempView = createBasicView()
        tempView.tag = 200
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Level Up"
        title.textAlignment = NSTextAlignment.center
        title.tag = 201
        tempView.addSubview(title)
        
        view.addSubview(tempView)
    }
    
    func rest(notification: Notification) -> Void {
        let tempView = createBasicView()
        tempView.tag = 300
        
        let title = UILabel.init(frame: CGRect.init(x:10, y:10, width:tempView.frame.size.width-20, height:30))
        title.text = "Rest"
        title.textAlignment = NSTextAlignment.center
        title.tag = 301
        tempView.addSubview(title)
        
        let shortLabel = UILabel(frame: CGRect(x: tempView.frame.size.width/2-80, y: 50, width: 50, height: 30))
        shortLabel.text = "Short"
        shortLabel.textAlignment = .right
        shortLabel.tag = 302
        tempView.addSubview(shortLabel)
        
        let restSwitch = UISwitch(frame: CGRect(x: tempView.frame.size.width/2-25, y: 50, width: 51, height: 31))
        restSwitch.isOn = longRest
        restSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        restSwitch.tag = 303
        tempView.addSubview(restSwitch)
        
        let longLabel = UILabel(frame: CGRect(x: tempView.frame.size.width/2+31, y: 50, width: 40, height: 30))
        longLabel.text = "Long"
        longLabel.tag = 304
        tempView.addSubview(longLabel)
        
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 80, width: tempView.frame.size.width, height: tempView.frame.size.height-80-50))
        scrollView.tag = 300
        tempView.addSubview(scrollView)
        
        if longRest == true {
            createLongRestDetails(scrollView: scrollView)
        }
        else {
            createShortRestDetails(scrollView: scrollView)
        }
        
        view.addSubview(tempView)
    }
    
    func createLongRestDetails(scrollView: UIScrollView) {
        let baseTag = scrollView.tag
        
        let instructionTextView = UITextView.init(frame: CGRect.init(x: 10, y: 10, width: scrollView.frame.size.width-20, height: 180))
        instructionTextView.text = "A long rest is a period of extended downtime, at least 8 hours long, during which a character sleeps or performs light activity: reading, talking, eating, or standing watch for no more than 2 hours. If the rest is interrupted by a period of strenuous activity—at least 1 hour of walking, fighting, casting Spells, or similar adventuring activity—the characters must begin the rest again to gain any benefit from it.\nAt the end of a long rest, a character regains all lost hit points. The character also regains spent Hit Dice, up to a number of dice equal to half of the character’s total number of them (minimum of one die).\nA character can’t benefit from more than one long rest in a 24-hour period, and a character must have at least 1 hit point at the start of the rest to gain its benefits."
        instructionTextView.isUserInteractionEnabled = false
        instructionTextView.tag = baseTag + 1
        
        let instructionContentSize = instructionTextView.sizeThatFits(instructionTextView.bounds.size)
        var instructionFrame = instructionTextView.frame
        instructionFrame.size.height = instructionContentSize.height
        instructionTextView.frame = instructionFrame
        
        scrollView.addSubview(instructionTextView)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 440 + instructionTextView.frame.size.height + 10)
    }
    
    func createShortRestDetails(scrollView: UIScrollView) {
        let baseTag = scrollView.tag
        
        let instructionTextView = UITextView.init(frame: CGRect.init(x: 10, y: 10, width: scrollView.frame.size.width-20, height: 90))
        instructionTextView.text = "A short rest is a period of downtime, at least 1 hour long, during which a character does nothing more strenuous than eating, drinking, reading, and tending to wounds.\nA character can spend one or more Hit Dice at the end of a short rest, up to the character’s maximum number of Hit Dice."
        instructionTextView.isUserInteractionEnabled = false
        instructionTextView.tag = baseTag + 1
        
        let instructionContentSize = instructionTextView.sizeThatFits(instructionTextView.bounds.size)
        var instructionFrame = instructionTextView.frame
        instructionFrame.size.height = instructionContentSize.height
        instructionTextView.frame = instructionFrame
        
        scrollView.addSubview(instructionTextView)
        
        let spendLabel = UILabel.init(frame: CGRect.init(x: 10, y: instructionTextView.frame.origin.y + instructionTextView.frame.size.height + 10, width: scrollView.frame.size.width - 20, height: 30))
        spendLabel.text = "Spend Hit Dice"
        spendLabel.textAlignment = .center
        spendLabel.tag = baseTag + 2
        scrollView.addSubview(spendLabel)
        
        let firstClass = Character.Selected.primaryClass
        let level = firstClass.level
        let hitDie = firstClass.hit_die
        
        let currentHD = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-120, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:40, height:30))
        currentHD.text = String(Character.Selected.current_hit_dice)
        currentHD.textAlignment = NSTextAlignment.center
        currentHD.layer.borderWidth = 1.0
        currentHD.layer.borderColor = UIColor.black.cgColor
        currentHD.tag = baseTag + 3
        currentHD.delegate = self
        scrollView.addSubview(currentHD)
        
        let d1 = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2-80, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:30, height:30))
        d1.text = "d"
        d1.textAlignment = NSTextAlignment.center
        d1.tag = baseTag + 4
        scrollView.addSubview(d1)
        
        let hd1 = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-50, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:40, height:30))
        hd1.text = String(hitDie)
        hd1.textAlignment = NSTextAlignment.center
        hd1.isUserInteractionEnabled = false
        hd1.textColor = UIColor.darkGray
        hd1.layer.borderWidth = 1.0
        hd1.layer.borderColor = UIColor.darkGray.cgColor
        hd1.tag = baseTag + 5
        scrollView.addSubview(hd1)
        
        let slash = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2-15, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:30, height:30))
        slash.text = "/"
        slash.textAlignment = NSTextAlignment.center
        slash.tag = baseTag + 6
        scrollView.addSubview(slash)
        
        let maxHD = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+10, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:40, height:30))
        maxHD.text = String(level)
        maxHD.textAlignment = NSTextAlignment.center
        maxHD.layer.borderWidth = 1.0
        maxHD.layer.borderColor = UIColor.black.cgColor
        maxHD.tag = baseTag + 7
        maxHD.delegate = self
        scrollView.addSubview(maxHD)
        
        let d2 = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2+50, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:30, height:30))
        d2.text = "d"
        d2.textAlignment = NSTextAlignment.center
        d2.tag = baseTag + 8
        scrollView.addSubview(d2)
        
        let hd2 = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+80, y:spendLabel.frame.origin.y + spendLabel.frame.size.height, width:40, height:30))
        hd2.text = String(hitDie)
        hd2.textAlignment = NSTextAlignment.center
        hd2.layer.borderWidth = 1.0
        hd2.layer.borderColor = UIColor.black.cgColor
        hd2.tag = baseTag + 9
        hd2.delegate = self
        scrollView.addSubview(hd2)
        
        let stepper = UIStepper.init(frame: CGRect.init(x:scrollView.frame.size.width/2-47, y:hd2.frame.origin.y + hd2.frame.size.height + 10, width:94, height:29))
        stepper.value = Double(Character.Selected.current_hit_dice)
        stepper.minimumValue = 0
        stepper.maximumValue = Double(level)
        stepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        stepper.tag = baseTag + 10
        scrollView.addSubview(stepper)
        
        let newHpValue = UILabel.init(frame: CGRect.init(x: 10, y: stepper.frame.origin.y + stepper.frame.size.height + 10, width: scrollView.frame.size.width - 20, height: 30))
        newHpValue.text = "Set New HP Value"
        newHpValue.textAlignment = .center
        newHpValue.tag = baseTag + 11
        scrollView.addSubview(newHpValue)
        
        let currentHP = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-50, y:newHpValue.frame.origin.y + newHpValue.frame.size.height, width:40, height:30))
        currentHP.text = String(Character.Selected.current_hp)
        currentHP.textAlignment = NSTextAlignment.center
        currentHP.layer.borderWidth = 1.0
        currentHP.layer.borderColor = UIColor.black.cgColor
        currentHP.tag = baseTag + 12
        currentHP.delegate = self
        scrollView.addSubview(currentHP)
        
        let slash2 = UILabel.init(frame: CGRect.init(x:scrollView.frame.size.width/2-15, y:newHpValue.frame.origin.y + newHpValue.frame.size.height, width:30, height:30))
        slash2.text = "/"
        slash2.textAlignment = NSTextAlignment.center
        slash2.tag = baseTag + 13
        scrollView.addSubview(slash2)
        
        let maxHP = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2+10, y:newHpValue.frame.origin.y + newHpValue.frame.size.height, width:40, height:30))
        maxHP.text = String(Character.Selected.max_hp)
        maxHP.textAlignment = NSTextAlignment.center
        maxHP.layer.borderWidth = 1.0
        maxHP.layer.borderColor = UIColor.black.cgColor
        maxHP.tag = baseTag + 14
        maxHP.delegate = self
        scrollView.addSubview(maxHP)
        
        let effectType = UISegmentedControl.init(frame: CGRect.init(x:10, y:maxHP.frame.origin.y + maxHP.frame.size.height + 10, width:scrollView.frame.size.width-20, height:30))
        effectType.insertSegment(withTitle:"Damage", at:0, animated:false)
        effectType.insertSegment(withTitle:"Heal", at:1, animated:false)
        effectType.insertSegment(withTitle:"Temp", at:2, animated:false)
        effectType.addTarget(self, action:#selector(self.segmentChanged), for:UIControlEvents.valueChanged)
        effectType.selectedSegmentIndex = 1
        effectType.tag = baseTag + 15
        scrollView.addSubview(effectType)
        
        let effectValue = UITextField.init(frame: CGRect.init(x:scrollView.frame.size.width/2-20, y:effectType.frame.origin.y + effectType.frame.size.height + 10, width:40, height:30))
        effectValue.text = String(hpEffectValue)
        effectValue.textAlignment = NSTextAlignment.center
        effectValue.layer.borderWidth = 1.0
        effectValue.layer.borderColor = UIColor.black.cgColor
        effectValue.tag = baseTag + 16
        effectValue.delegate = self
        scrollView.addSubview(effectValue)
        
        let hpStepper = UIStepper.init(frame: CGRect.init(x:scrollView.frame.size.width/2-47, y:effectValue.frame.origin.y + effectValue.frame.size.height + 10, width:94, height:29))
        hpStepper.value = 0
        hpStepper.minimumValue = 0
        hpStepper.maximumValue = 1000
        hpStepper.addTarget(self, action:#selector(self.stepperChanged), for:UIControlEvents.valueChanged)
        hpStepper.tag = baseTag + 17
        scrollView.addSubview(hpStepper)
        
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: hpStepper.frame.origin.y + hpStepper.frame.size.height + 10)
    }
    
    func exportCharacter(notification: Notification) -> Void {
        
    }
    
    func help(notification: Notification) -> Void {
        
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
    
    func segmentChanged(segControl: UISegmentedControl) {
        let baseTag = segControl.superview?.tag
        if segControl.tag == (baseTag)! + 15 {
            
        }
    }
    
    func switchChanged(sender: UISwitch) {
        longRest = sender.isOn
        
        let parentView = sender.superview!
        var scrollView: UIScrollView!
        for case let view in parentView.subviews {
            if view.tag == parentView.tag {
                scrollView = view as! UIScrollView
            }
        }
        
        for case let view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        if longRest == true {
            createLongRestDetails(scrollView: scrollView)
        }
        else {
            createShortRestDetails(scrollView: scrollView)
        }
    }
    
    func applyAction(button: UIButton) {
        let parentView:UIView = button.superview!
        if parentView.tag == 100 {
            // Change Name
            for case let view in parentView.subviews {
                if view.tag == 102 {
                    let textField = view as! UITextField
                    Character.Selected.name = textField.text
                }
            }
            navigationItem.title = Character.Selected.name
        }
        else if parentView.tag == 200 {
            // Level Up
        }
        else if parentView.tag == 300 {
            // Rest
            if longRest == true {
                // Long Rest; Reset all spell slots, hp, and half hit dice used, and all resources
                let spellcasting = Character.Selected.spellcasting
                for index:Int in 0...(spellcasting?.spells_by_level?.allObjects.count)!-1 {
                    let spellLevel:Spells_by_Level = spellcasting?.spells_by_level?.allObjects[index] as! Spells_by_Level
                    spellLevel.remaining_slots = spellLevel.total_slots
                    
                    spellcasting?.removeFromSpells_by_level(spellcasting?.spells_by_level?.allObjects[index] as! Spells_by_Level)
                    spellcasting?.addToSpells_by_level(spellLevel)
                }
                
                Character.Selected.current_hp = Character.Selected.max_hp
                
                let firstClass = Character.Selected.primaryClass
                let level = firstClass.level
                let numHDUsed = level - Character.Selected.current_hit_dice
                let numHDReturned = numHDUsed/2
                Character.Selected.current_hit_dice = Character.Selected.current_hit_dice + numHDReturned
                
                if((Character.Selected.resources?.allObjects.count ?? 0)! > 0) {
                    for resource: Resource in Character.Selected.resources?.allObjects as! [Resource] {
                        if resource.max_value != 0 {
                            resource.current_value = resource.max_value
                        }
                    }
                }
                
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"longRest"), object: nil, userInfo: nil)
            }
            else {
                // Short Rest; Spend Hit Dice to heal, reset class specific content
                for view in parentView.subviews {
                    if view.tag == 300 {
                        let scrollView = view as! UIScrollView
                        let baseTag = scrollView.tag
                        for view in (scrollView.subviews) {
                            if view.tag == baseTag + 10 {
                                let stepper = view as! UIStepper
                                Character.Selected.current_hit_dice = Int32(stepper.value)
                            }
                            else if view.tag == baseTag + 15 {
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
                    }
                }
                
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"shortRest"), object: nil, userInfo: nil)
            }
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    func stepperChanged(stepper: UIStepper) {
        if stepper.tag == 310 {
            // HD
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 303 {
                    let textField = view as! UITextField
                    textField.text = String(Int(stepper.value))
                }
            }
        }
        else if stepper.tag == 317 {
            hpEffectValue = Int32(stepper.value)
            let parentView = stepper.superview
            for case let view in (parentView?.subviews)! {
                if view.tag == 316 {
                    let textField = view as! UITextField
                    textField.text = String(hpEffectValue)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftAction(button: UIBarButtonItem) {
        
    }
    
    @IBAction func rightAction(button: UIBarButtonItem) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "rightPopover" {
            let popoverViewController = segue.destination 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}
