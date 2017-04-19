//
//  DamageFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class DamageFactory {
    
    static func getEmptyDamage(context: NSManagedObjectContext) -> Damage {
        let damage = Damage(context: context)
        damage.damage_type = ""
        damage.die_number = 1
        damage.die_type = 6
        damage.extra_die = false
        damage.extra_die_number = 0
        damage.extra_die_type = 0
        damage.magic_bonus = 0
        damage.misc_bonus = 0
        damage.mod_damage = false
        return damage
    }
    
}
