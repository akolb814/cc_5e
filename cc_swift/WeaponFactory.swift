//
//  WeaponFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class WeaponFactory {
    
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
