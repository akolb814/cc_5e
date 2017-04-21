//
//  CharacterSelectViewController.swift
//  cc_swift
//
//  Created by Rip Britton on 3/8/17.
//
//

import Foundation
import UIKit

class CharacterSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCharactersFromDb()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       Character.Selected = characters[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "character_cell") as! CharacterViewCell
        cell.update(characterIn: characters[indexPath.row])
        return cell
    }
    
    func loadCharactersFromDb() {
        do {
            characters = try context.fetch(Character.fetchRequest())
        } catch {
            print("Fetching failed...")
        }
    }
    
    @IBAction func didTapAddCharacter(_ sender: Any) {
        let alertView = UIAlertController.init(title: "New Character", message: "Create a new charatcer or load from a file?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction.init(title: "New Character", style: .default, handler: { (action:UIAlertAction) in
            let character = CharacterFactory.getEmptyCharacter(name: "New Character", context:self.context)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.loadCharactersFromDb()
            self.tableView.reloadData()
        }))
        alertView.addAction(UIAlertAction.init(title: "Load Character", style: .default, handler: { (action:UIAlertAction) in
            let character = CharacterJson.getCharacterFromJson(filename: "character")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.loadCharactersFromDb()
            self.tableView.reloadData()
        }))
        self.present(alertView, animated:true, completion: nil)
    }
    

}
