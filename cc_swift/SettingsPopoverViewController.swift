//
//  SettingsPopoverViewController.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/27/17.
//
//

import UIKit

class SettingsPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    let settings = ["Change Name", "Level Up", "Short/Long Rest", "Export", "Help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingsTable.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableView Delegate & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.text = settings[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Change Name
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"ChangeName"), object: nil, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
            break
        case 1:
            // Level Up
            break
        case 2:
            // Short/Long Rest
            break
        case 3:
            // Export
            break
        case 4:
            // Help
            break
        default:
            break
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
