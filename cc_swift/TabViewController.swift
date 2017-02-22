//
//  TabViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 2/13/17.
//
//

import UIKit

class TabViewController: UITabBarController {
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = appDelegate.character.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftAction(button: UIBarButtonItem) {
        
    }
    
    @IBAction func rightAction(button: UIBarButtonItem) {
        
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
