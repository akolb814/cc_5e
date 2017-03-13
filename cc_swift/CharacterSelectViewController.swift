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
        let character = CharacterFactory.getEmptyCharacter(name: "New Character", context:context)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        tableView.reloadData()
    }
    

}
