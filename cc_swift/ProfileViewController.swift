//
//  ProfileViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // Scrollview
    @IBOutlet weak var scrollView:UIScrollView!
    
    // TextFields
    @IBOutlet weak var classField:UITextField!
    @IBOutlet weak var experienceField:UITextField!
    @IBOutlet weak var raceField:UITextField!
    @IBOutlet weak var backgroundField:UITextField!
    @IBOutlet weak var alignmentField:UITextField!
    
    // Class Features
    @IBOutlet weak var classView: UIView!
    @IBOutlet weak var classHeight: NSLayoutConstraint!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classTextView: UITextView!
    
    // Racial Features
    @IBOutlet weak var racialView: UIView!
    @IBOutlet weak var racialHeight: NSLayoutConstraint!
    @IBOutlet weak var racialTitle: UILabel!
    @IBOutlet weak var racialTextView: UITextView!
    
    // Background Features
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundTitle: UILabel!
    @IBOutlet weak var backgroundTextView: UITextView!
    
    // Weapon Proficiencies
    @IBOutlet weak var weaponView: UIView!
    @IBOutlet weak var weaponHeight: NSLayoutConstraint!
    @IBOutlet weak var weaponTitle: UILabel!
    @IBOutlet weak var weaponTextView: UITextView!
    
    // Armor Proficiencies
    @IBOutlet weak var armorView: UIView!
    @IBOutlet weak var armorHeight: NSLayoutConstraint!
    @IBOutlet weak var armorTitle: UILabel!
    @IBOutlet weak var armorTextView: UITextView!
    
    // Tool Proficiencies
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var toolHeight: NSLayoutConstraint!
    @IBOutlet weak var toolTitle: UILabel!
    @IBOutlet weak var toolTextView: UITextView!
    
    // Languages Known
    @IBOutlet weak var languagesView: UIView!
    @IBOutlet weak var languageHeight: NSLayoutConstraint!
    @IBOutlet weak var languagesTitle: UILabel!
    @IBOutlet weak var languagesTextView: UITextView!
    
    // Personality Traits
    @IBOutlet weak var personalityView: UIView!
    @IBOutlet weak var personalityHeight: NSLayoutConstraint!
    @IBOutlet weak var personalityTitle: UILabel!
    @IBOutlet weak var personalityTextView: UITextView!
    
    // Ideals
    @IBOutlet weak var idealsView: UIView!
    @IBOutlet weak var idealsHeight: NSLayoutConstraint!
    @IBOutlet weak var idealsTitle: UILabel!
    @IBOutlet weak var idealsTextView: UITextView!
    
    // Bonds
    @IBOutlet weak var bondsView: UIView!
    @IBOutlet weak var bondsHeight: NSLayoutConstraint!
    @IBOutlet weak var bondsTitle: UILabel!
    @IBOutlet weak var bondsTextView: UITextView!
    
    // Flaws
    @IBOutlet weak var flawsView: UIView!
    @IBOutlet weak var flawsHeight: NSLayoutConstraint!
    @IBOutlet weak var flawsTitle: UILabel!
    @IBOutlet weak var flawsTextView: UITextView!
    
    // Notes
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesHeight: NSLayoutConstraint!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        self.setMiscDisplayData()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: Notification.Name(rawValue:"shortRest"), object: nil, queue: nil, using: updateFromRest)
        nc.addObserver(forName: Notification.Name(rawValue:"longRest"), object: nil, queue: nil, using: updateFromRest)
    }
    
    func updateFromRest(notification: Notification) -> Void {
        
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
        
        let primaryClass: Class = Character.Selected.primaryClass
        
        navigationItem.title = Character.Selected.name
        classField.text = primaryClass.name! + " " + String(primaryClass.level)
        let race = Character.Selected.race
        raceField.text = race?.name
        let background = Character.Selected.background
        backgroundField.text = background?.name
        alignmentField.text = Character.Selected.alignment
        experienceField.text = String(Character.Selected.experience)
        
        // Class Features
        classTextView.text = primaryClass.features
        let classTextViewHeight = classTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        classHeight.constant = 20+classTextViewHeight
        
        // Racial Features
        racialTextView.text = race?.features
        let racialTextViewHeight = racialTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        racialHeight.constant = 20+racialTextViewHeight
        
        // Background Features
        backgroundTextView.text = background?.features
        let backgroundTextViewHeight = backgroundTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        backgroundHeight.constant = 20+backgroundTextViewHeight
        
        // Weapon Proficiencies
        weaponTextView.text = Character.Selected.weapon_proficiencies
        let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        // Armor Proficiencies
        armorTextView.text = Character.Selected.armor_proficiencies
        let armorTextViewHeight = armorTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        // Armor and weapon views must be same size, check which one is larger and use that one for both views
        if weaponTextViewHeight <= armorTextViewHeight {
            armorHeight.constant = 20+armorTextViewHeight
            weaponHeight.constant = 20+armorTextViewHeight
        }
        else {
            armorHeight.constant = 20+weaponTextViewHeight
            weaponHeight.constant = 20+weaponTextViewHeight
        }
        
        // Tool Proficiencies
        toolTextView.text = Character.Selected.tool_proficiencies
        let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        // Languages Known
        languagesTextView.text = Character.Selected.languages
        let languagesTextViewHeight = languagesTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        // Tool and languages views must be same size, check which one is larger and use that one for both views
        if toolTextViewHeight <= languagesTextViewHeight {
            toolHeight.constant = 20+languagesTextViewHeight
            languageHeight.constant = 20+languagesTextViewHeight
        }
        else {
            toolHeight.constant = 20+toolTextViewHeight
            languageHeight.constant = 20+toolTextViewHeight
        }
        
        // Personality Traits
        personalityTextView.text = Character.Selected.personality_traits
        let personalityTextViewHeight = personalityTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        personalityHeight.constant = 20+personalityTextViewHeight
        
        // Ideals
        idealsTextView.text = Character.Selected.ideals
        let idealsTextViewHeight = idealsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        idealsHeight.constant = 20+idealsTextViewHeight
        
        // Bonds
        bondsTextView.text = Character.Selected.bonds
        let bondsTextViewHeight = bondsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        bondsHeight.constant = 20+bondsTextViewHeight
        
        // Flaws
        flawsTextView.text = Character.Selected.flaws
        let flawsTextViewHeight = flawsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        flawsHeight.constant = 20+flawsTextViewHeight
        
        // Notes
        notesTextView.text = Character.Selected.notes
        let notesTextViewHeight = notesTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        notesHeight.constant = 20+notesTextViewHeight
        
        classView.layer.borderWidth = 1.0
        classView.layer.borderColor = UIColor.black.cgColor
        
        racialView.layer.borderWidth = 1.0
        racialView.layer.borderColor = UIColor.black.cgColor
        
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        weaponView.layer.borderWidth = 1.0
        weaponView.layer.borderColor = UIColor.black.cgColor
        
        armorView.layer.borderWidth = 1.0
        armorView.layer.borderColor = UIColor.black.cgColor
        
        toolView.layer.borderWidth = 1.0
        toolView.layer.borderColor = UIColor.black.cgColor
        
        languagesView.layer.borderWidth = 1.0
        languagesView.layer.borderColor = UIColor.black.cgColor
        
        personalityView.layer.borderWidth = 1.0
        personalityView.layer.borderColor = UIColor.black.cgColor
        
        idealsView.layer.borderWidth = 1.0
        idealsView.layer.borderColor = UIColor.black.cgColor
        
        bondsView.layer.borderWidth = 1.0
        bondsView.layer.borderColor = UIColor.black.cgColor
        
        flawsView.layer.borderWidth = 1.0
        flawsView.layer.borderColor = UIColor.black.cgColor
        
        notesView.layer.borderWidth = 1.0
        notesView.layer.borderColor = UIColor.black.cgColor
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
        case 20:
            break
            
        default:
            break
            
        }
        
        if (parentView.tag >= 500 && parentView.tag < 1100) {
            
        } else if (parentView.tag >= 4000) {
            
        }
        
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
    }
    
    // UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == classField {
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
                for i in 0...Types.ClassStrings.count-1 {
                    let c = Types.ClassStrings[i]
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
                for i in 0...Types.levels.count-1 {
                    let l = String(Types.levels[i])
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
        else if textField == experienceField {
            // Update the experience value
            Character.Selected.experience = Int32(experienceField.text!)!
        }
        else if textField == raceField {
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
            for i in 0...Types.RaceStrings.count-1 {
                let r = Types.RaceStrings[i]
                let currentRace = Character.Selected.race?.name
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
            for i in 0...Types.RaceStrings.count-1 {
                let r = Types.RaceStrings[i]
                let currentRace = Character.Selected.race?.name
                if r == currentRace {
                    let subRaces:[String] = Types.SubraceToRaceDictionary[r]!
                    for j in 0...subRaces.count-1 {
                        let sr = subRaces[j]
                        let currentSubrace = Character.Selected.race?.subrace?.name
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
        else if textField == backgroundField {
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
            for i in 0...Types.BackgroundStrings.count-1 {
                let bg = Types.BackgroundStrings[i]
                let currentBackground = Character.Selected.background?.name
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
        else if textField == alignmentField {
            // Alignment
            let tempView = createBasicView()
            tempView.tag = 50
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: tempView.frame.size.width, height: tempView.frame.size.height-50))
            tempView.addSubview(scrollView)
            
            let alignmentTitle = UILabel.init(frame: CGRect.init(x:5, y:5, width:tempView.frame.size.width-10, height:30))
            alignmentTitle.text = "Alignment"
            alignmentTitle.textAlignment = NSTextAlignment.center
            alignmentTitle.tag = 51
            scrollView.addSubview(alignmentTitle)
            
            // Lawful Good
            let lgBtn = UIButton.init(type: UIButtonType.custom)
            lgBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:40, width:40, height:40)
            lgBtn.setTitle("LG", for:UIControlState.normal)
            lgBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            lgBtn.layer.borderWidth = 1.0
            lgBtn.layer.borderColor = UIColor.black.cgColor
            lgBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            lgBtn.tag = 52
            scrollView.addSubview(lgBtn)
            
            // Neutral Good
            let ngBtn = UIButton.init(type: UIButtonType.custom)
            ngBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:40, width:40, height:40)
            ngBtn.setTitle("NG", for:UIControlState.normal)
            ngBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            ngBtn.layer.borderWidth = 1.0
            ngBtn.layer.borderColor = UIColor.black.cgColor
            ngBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            ngBtn.tag = 53
            scrollView.addSubview(ngBtn)
            
            // Chaotic Good
            let cgBtn = UIButton.init(type: UIButtonType.custom)
            cgBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:40, width:40, height:40)
            cgBtn.setTitle("CG", for:UIControlState.normal)
            cgBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            cgBtn.layer.borderWidth = 1.0
            cgBtn.layer.borderColor = UIColor.black.cgColor
            cgBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            cgBtn.tag = 54
            scrollView.addSubview(cgBtn)
            
            // Lawful Neutral
            let lnBtn = UIButton.init(type: UIButtonType.custom)
            lnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:85, width:40, height:40)
            lnBtn.setTitle("LN", for:UIControlState.normal)
            lnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            lnBtn.layer.borderWidth = 1.0
            lnBtn.layer.borderColor = UIColor.black.cgColor
            lnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            lnBtn.tag = 55
            scrollView.addSubview(lnBtn)
            
            // True Neutral
            let tnBtn = UIButton.init(type: UIButtonType.custom)
            tnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:85, width:40, height:40)
            tnBtn.setTitle("TN", for:UIControlState.normal)
            tnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            tnBtn.layer.borderWidth = 1.0
            tnBtn.layer.borderColor = UIColor.black.cgColor
            tnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            tnBtn.tag = 56
            scrollView.addSubview(tnBtn)
            
            // Chaotic Neutral
            let cnBtn = UIButton.init(type: UIButtonType.custom)
            cnBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:85, width:40, height:40)
            cnBtn.setTitle("CN", for:UIControlState.normal)
            cnBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            cnBtn.layer.borderWidth = 1.0
            cnBtn.layer.borderColor = UIColor.black.cgColor
            cnBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            cnBtn.tag = 57
            scrollView.addSubview(cnBtn)
            
            // Lawful Evil
            let leBtn = UIButton.init(type: UIButtonType.custom)
            leBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-65, y:130, width:40, height:40)
            leBtn.setTitle("LE", for:UIControlState.normal)
            leBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            leBtn.layer.borderWidth = 1.0
            leBtn.layer.borderColor = UIColor.black.cgColor
            leBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            leBtn.tag = 58
            scrollView.addSubview(leBtn)
            
            // Neutral Evil
            let neBtn = UIButton.init(type: UIButtonType.custom)
            neBtn.frame = CGRect.init(x:scrollView.frame.size.width/2-20, y:130, width:40, height:40)
            neBtn.setTitle("NE", for:UIControlState.normal)
            neBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            neBtn.layer.borderWidth = 1.0
            neBtn.layer.borderColor = UIColor.black.cgColor
            neBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            neBtn.tag = 59
            scrollView.addSubview(neBtn)
            
            // Chaotic Evil
            let ceBtn = UIButton.init(type: UIButtonType.custom)
            ceBtn.frame = CGRect.init(x:scrollView.frame.size.width/2+25, y:130, width:40, height:40)
            ceBtn.setTitle("CE", for:UIControlState.normal)
            ceBtn.addTarget(self, action: #selector(self.alignmentAction), for: UIControlEvents.touchUpInside)
            ceBtn.layer.borderWidth = 1.0
            ceBtn.layer.borderColor = UIColor.black.cgColor
            ceBtn.setTitleColor(UIColor.black, for:UIControlState.normal)
            ceBtn.tag = 60
            scrollView.addSubview(ceBtn)
            
            if Character.Selected.alignment == "LG" {
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
            else if Character.Selected.alignment == "NG" {
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
            else if Character.Selected.alignment == "CG" {
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
            else if Character.Selected.alignment == "LN" {
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
            else if Character.Selected.alignment == "TN" {
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
            else if Character.Selected.alignment == "CN" {
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
            else if Character.Selected.alignment == "LE" {
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
            else if Character.Selected.alignment == "NE" {
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
            else if Character.Selected.alignment == "CE" {
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
        return false
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
    
    // UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == classTextView {
            // Open view to breakdown all class features and edit them
            return false
        }
        else if textView == racialTextView {
            // Open view to breakdown all racial features
            return false
        }
        else if textView == backgroundTextView {
            // Open view to breakdown all background features
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == classTextView {
            let classTextViewHeight = classTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            classHeight.constant = 20+classTextViewHeight
        }
        else if textView == racialTextView {
            let racialTextViewHeight = racialTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            racialHeight.constant = 20+racialTextViewHeight
        }
        else if textView == backgroundTextView {
            let backgroundTextViewHeight = backgroundTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            backgroundHeight.constant = 20+backgroundTextViewHeight
        }
        else if textView == weaponTextView {
            Character.Selected.weapon_proficiencies = textView.text
            
            let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let armorTextViewHeight = armorTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Armor and weapon views must be same size, check which one is larger and use that one for both views
            if weaponTextViewHeight <= armorTextViewHeight {
                armorHeight.constant = 20+armorTextViewHeight
                weaponHeight.constant = 20+armorTextViewHeight
            }
            else {
                armorHeight.constant = 20+weaponTextViewHeight
                weaponHeight.constant = 20+weaponTextViewHeight
            }
        }
        else if textView == armorTextView {
            Character.Selected.armor_proficiencies = textView.text
            
            let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let armorTextViewHeight = armorTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Armor and weapon views must be same size, check which one is larger and use that one for both views
            if weaponTextViewHeight <= armorTextViewHeight {
                armorHeight.constant = 20+armorTextViewHeight
                weaponHeight.constant = 20+armorTextViewHeight
            }
            else {
                armorHeight.constant = 20+weaponTextViewHeight
                weaponHeight.constant = 20+weaponTextViewHeight
            }
            
        }
        else if textView == toolTextView {
            Character.Selected.tool_proficiencies = textView.text
            
            let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let languagesTextViewHeight = languagesTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Tool and languages views must be same size, check which one is larger and use that one for both views
            if toolTextViewHeight <= languagesTextViewHeight {
                toolHeight.constant = 20+languagesTextViewHeight
                languageHeight.constant = 20+languagesTextViewHeight
            }
            else {
                toolHeight.constant = 20+toolTextViewHeight
                languageHeight.constant = 20+toolTextViewHeight
            }
        }
        else if textView == languagesTextView {
            Character.Selected.languages = textView.text
            
            let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let languagesTextViewHeight = languagesTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Tool and languages views must be same size, check which one is larger and use that one for both views
            if toolTextViewHeight <= languagesTextViewHeight {
                toolHeight.constant = 20+languagesTextViewHeight
                languageHeight.constant = 20+languagesTextViewHeight
            }
            else {
                toolHeight.constant = 20+toolTextViewHeight
                languageHeight.constant = 20+toolTextViewHeight
            }
        }
        else if textView == personalityTextView {
            Character.Selected.personality_traits = textView.text
            let personalityTextViewHeight = personalityTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            personalityHeight.constant = 20+personalityTextViewHeight
        }
        else if textView == idealsTextView {
            Character.Selected.ideals = textView.text
            let idealsTextViewHeight = idealsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            idealsHeight.constant = 20+idealsTextViewHeight
        }
        else if textView == bondsTextView {
            Character.Selected.bonds = textView.text
            let bondsTextViewHeight = bondsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            bondsHeight.constant = 20+bondsTextViewHeight
        }
        else if textView == flawsTextView {
            Character.Selected.flaws = textView.text
            let flawsTextViewHeight = flawsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            flawsHeight.constant = 20+flawsTextViewHeight
        }
        else if textView == notesTextView {
            Character.Selected.notes = textView.text
            let notesTextViewHeight = notesTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            notesHeight.constant = 20+notesTextViewHeight
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == classTextView {
            let classTextViewHeight = classTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            classHeight.constant = 20+classTextViewHeight
        }
        else if textView == racialTextView {
            let racialTextViewHeight = racialTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            racialHeight.constant = 20+racialTextViewHeight
        }
        else if textView == backgroundTextView {
            let backgroundTextViewHeight = backgroundTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            backgroundHeight.constant = 20+backgroundTextViewHeight
        }
        else if textView == weaponTextView {
            Character.Selected.weapon_proficiencies = textView.text
            
            let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let armorTextViewHeight = armorTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Armor and weapon views must be same size, check which one is larger and use that one for both views
            if weaponTextViewHeight <= armorTextViewHeight {
                armorHeight.constant = 20+armorTextViewHeight
                weaponHeight.constant = 20+armorTextViewHeight
            }
            else {
                armorHeight.constant = 20+weaponTextViewHeight
                weaponHeight.constant = 20+weaponTextViewHeight
            }
        }
        else if textView == armorTextView {
            Character.Selected.armor_proficiencies = textView.text
            
            let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let armorTextViewHeight = armorTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Armor and weapon views must be same size, check which one is larger and use that one for both views
            if weaponTextViewHeight <= armorTextViewHeight {
                armorHeight.constant = 20+armorTextViewHeight
                weaponHeight.constant = 20+armorTextViewHeight
            }
            else {
                armorHeight.constant = 20+weaponTextViewHeight
                weaponHeight.constant = 20+weaponTextViewHeight
            }
            
        }
        else if textView == toolTextView {
            Character.Selected.tool_proficiencies = textView.text
            
            let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let languagesTextViewHeight = languagesTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Tool and languages views must be same size, check which one is larger and use that one for both views
            if toolTextViewHeight <= languagesTextViewHeight {
                toolHeight.constant = 20+languagesTextViewHeight
                languageHeight.constant = 20+languagesTextViewHeight
            }
            else {
                toolHeight.constant = 20+toolTextViewHeight
                languageHeight.constant = 20+toolTextViewHeight
            }
        }
        else if textView == languagesTextView {
            Character.Selected.languages = textView.text
            
            let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            let languagesTextViewHeight = languagesTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
            
            // Tool and languages views must be same size, check which one is larger and use that one for both views
            if toolTextViewHeight <= languagesTextViewHeight {
                toolHeight.constant = 20+languagesTextViewHeight
                languageHeight.constant = 20+languagesTextViewHeight
            }
            else {
                toolHeight.constant = 20+toolTextViewHeight
                languageHeight.constant = 20+toolTextViewHeight
            }
        }
        else if textView == personalityTextView {
            Character.Selected.personality_traits = textView.text
            let personalityTextViewHeight = personalityTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            personalityHeight.constant = 20+personalityTextViewHeight
        }
        else if textView == idealsTextView {
            Character.Selected.ideals = textView.text
            let idealsTextViewHeight = idealsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            idealsHeight.constant = 20+idealsTextViewHeight
        }
        else if textView == bondsTextView {
            Character.Selected.bonds = textView.text
            let bondsTextViewHeight = bondsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            bondsHeight.constant = 20+bondsTextViewHeight
        }
        else if textView == flawsTextView {
            Character.Selected.flaws = textView.text
            let flawsTextViewHeight = flawsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            flawsHeight.constant = 20+flawsTextViewHeight
        }
        else if textView == notesTextView {
            Character.Selected.notes = textView.text
            let notesTextViewHeight = notesTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
            notesHeight.constant = 20+notesTextViewHeight
        }
    }
    
    // UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 23 || pickerView.tag == 26 {
            return Types.ClassStrings.count
        }
        else if pickerView.tag == 32 {
            return Types.ClassStrings.count
        }
        else if pickerView.tag == 33 {
            for i in 0...Types.RaceStrings.count-1 {
                let r = Types.RaceStrings[i]
                let currentRace = Character.Selected.race?.name
                if r == currentRace {
                    let subRaces:[String] = Types.SubraceToRaceDictionary[r]!
                    return subRaces.count
                }
            }
            return 0
        }
        else if pickerView.tag == 42 {
            return Types.BackgroundStrings.count
        }
        else {
            return Types.levels.count
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
            pickerLabel?.text = Types.ClassStrings[row]
        }
        else if pickerView.tag == 32 {
            pickerLabel?.text = Types.RaceStrings[row]
        }
        else if pickerView.tag == 33 {
            for i in 0...Types.RaceStrings.count-1 {
                let r = Types.RaceStrings[i]
                let currentRace = Character.Selected.race?.name
                if r == currentRace {
                    let subRaces:[String] = Types.SubraceToRaceDictionary[r]!
                    pickerLabel?.text = subRaces[row]
                }
            }
            
        }
        else if pickerView.tag == 42 {
            pickerLabel?.text = Types.BackgroundStrings[row]
        }
        else {
            pickerLabel?.text = String(Types.levels[row])
        }
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width-20
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
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
