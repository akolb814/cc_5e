//
//  WeaponFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class WeaponFactory {
    
    static func getWeapon(character: Character, json: JSON, context: NSManagedObjectContext) -> Weapon {
        let weapon = Weapon(context: context)
        weapon.category = json["category"].string
        weapon.magic_bonus = json["attack_bonus"]["magic_bonus"].int32!
        weapon.misc_bonus = json["attack_bonus"]["misc_bonus"].int32!
        weapon.properties = json["properties"].string
        weapon.range = json["range"].string
        weapon.ability = CharacterFactory.getAbility(character: character, name: json["attack_bonus"]["ability"].string!, context: context)
        weapon.damage = DamageFactory.getDamage(json:json["damage"], context: context)
        weapon.cost = json["cost"].string
        weapon.info = json["description"].string
        weapon.name = json["name"].string
        weapon.quantity = json["quantity"].int32!
        weapon.weight = json["weight"].string
        return weapon
    }
    
    static func getEmptyWeapon(character: Character, context: NSManagedObjectContext) -> Weapon {
        let weapon = Weapon(context: context)
        weapon.category = ""
        weapon.magic_bonus = 0
        weapon.misc_bonus = 0
        weapon.properties = ""
        weapon.range = ""
        weapon.ability = CharacterFactory.getAbility(character: character, name: "INT", context: context)
        weapon.damage = DamageFactory.getEmptyDamage(context: context)
        weapon.cost = ""
        weapon.info = ""
        weapon.name = ""
        weapon.quantity = 1
        weapon.weight = ""
        return weapon
    }
    
}
