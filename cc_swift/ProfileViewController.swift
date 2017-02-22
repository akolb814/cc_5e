//
//  ProfileViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/4/17.
//
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
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
        
        let firstClass: JSON = appDelegate.character.classes[0]
        let classStr = firstClass["class"].string!
        let level = firstClass["level"].int!
        
        navigationItem.title = appDelegate.character.name
        classField.text = classStr + " " + String(level)
        let race = appDelegate.character.race
        raceField.text = race["title"].string
        let background = appDelegate.character.background
        backgroundField.text = background["title"].string
        alignmentField.text = appDelegate.character.alignment
        experienceField.text = appDelegate.character.experience
        
        // Class Features
        classTextView.text = firstClass["features"].string!
        let classTextViewHeight = classTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        classHeight.constant = 20+classTextViewHeight
        
        // Racial Features
        racialTextView.text = race["features"].string!
        let racialTextViewHeight = racialTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        racialHeight.constant = 20+racialTextViewHeight
        
        // Background Features
        backgroundTextView.text = background["features"].string!
        let backgroundTextViewHeight = backgroundTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        backgroundHeight.constant = 20+backgroundTextViewHeight
        
        // Weapon Proficiencies
        weaponTextView.text = appDelegate.character.weaponProficiencies
        let weaponTextViewHeight = weaponTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        
        // Armor Proficiencies
        armorTextView.text = appDelegate.character.armorProficienceies
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
        toolTextView.text = appDelegate.character.toolProficiencies
        let toolTextViewHeight = toolTextView.text.heightWithConstrainedWidth(width: view.frame.width/2-21, font: UIFont.systemFont(ofSize: 17))
        
        // Languages Known
        languagesTextView.text = appDelegate.character.languages
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
        personalityTextView.text = appDelegate.character.personalityTraits
        let personalityTextViewHeight = personalityTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        personalityHeight.constant = 20+personalityTextViewHeight
        
        // Ideals
        idealsTextView.text = appDelegate.character.ideals
        let idealsTextViewHeight = idealsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        idealsHeight.constant = 20+idealsTextViewHeight
        
        // Bonds
        bondsTextView.text = appDelegate.character.bonds
        let bondsTextViewHeight = bondsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        bondsHeight.constant = 20+bondsTextViewHeight
        
        // Flaws
        flawsTextView.text = appDelegate.character.flaws
        let flawsTextViewHeight = flawsTextView.text.heightWithConstrainedWidth(width: view.frame.width-16, font: UIFont.systemFont(ofSize: 17))
        flawsHeight.constant = 20+flawsTextViewHeight
        
        // Notes
        notesTextView.text = appDelegate.character.notes
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
