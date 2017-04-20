//
//  DamageFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class DamageFactory {
    
    static func getDamage(json: JSON, context: NSManagedObjectContext) -> Damage {
        let damage = Damage(context: context)
        damage.damage_type = json["damage_type"].string
        damage.die_number = json["die_number"].int32!
        damage.die_type = json["die_type"].int32!
        damage.extra_die = json["extra_die"].bool!
        damage.extra_die_number = json["extra_die_number"].int32!
        damage.extra_die_type = json["extra_die_type"].int32!
        damage.magic_bonus = json["magic_bonus"].int32!
        damage.misc_bonus = json["misc_bonus"].int32!
        damage.mod_damage = json["mod_damage"].bool!
        return damage
    }
    
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
