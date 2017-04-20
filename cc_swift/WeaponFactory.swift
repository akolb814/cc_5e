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
    
    static func getWeapon(json: JSON, context: NSManagedObjectContext) -> Weapon {
        let weapon = Weapon(context: context)
        weapon.category = json["category"].string
        weapon.magic_bonus = json["magic_bonus"].int32!
        weapon.misc_bonus = json["misc_bonus"].int32!
        weapon.properties = json["properties"].string
        weapon.range = json["range"].string
        weapon.ability = CharacterFactory.getAbility(name: "INT", json:json, context: context)
        weapon.damage = DamageFactory.getDamage(json:json, context: context)
        weapon.cost = json["cost"].string
        weapon.info = json["description"].string
        weapon.name = json["name"].string
        weapon.quantity = json["quantity"].int32!
        weapon.weight = json["weight"].string
        return weapon
    }
    
    static func getEmptyWeapon(context: NSManagedObjectContext) -> Weapon {
        let weapon = Weapon(context: context)
        weapon.category = ""
        weapon.magic_bonus = 0
        weapon.misc_bonus = 0
        weapon.properties = ""
        weapon.range = ""
        weapon.ability = CharacterFactory.getEmptyAbility(name: "INT", context: context)
        weapon.damage = DamageFactory.getEmptyDamage(context: context)
        weapon.cost = ""
        weapon.info = ""
        weapon.name = ""
        weapon.quantity = 1
        weapon.weight = ""
        return weapon
    }
    
}
