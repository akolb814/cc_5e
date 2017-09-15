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
        
        view.addSubview(tempView)
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
    
    func switchChanged(sender: UISwitch) {
        longRest = sender.isOn
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
                // Long Rest; Reset all spell slots, hp, and hit dice
            }
            else {
                // Short Rest; Spend Hit Dice to heal, reset class specific details
            }
        }
        parentView.removeFromSuperview()
    }
    
    func cancelAction(button: UIButton) {
        let parentView = button.superview
        parentView?.removeFromSuperview()
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
