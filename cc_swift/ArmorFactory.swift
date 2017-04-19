//
//  ArmorFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class ArmorFactory {
    
    static func getEmptyArmor(context: NSManagedObjectContext) -> Armor {
        let armor = Armor(context: context)
        armor.equipped = false
        armor.magic_bonus = 0
        armor.max_dex = 20
        armor.misc_bonus = 0
        armor.shield = false
        armor.stealth_disadvantage = false
        armor.str_requirement = 0
        armor.value = 10
        armor.ability_mod = CharacterFactory.getEmptyAbility(name: "DEX", context: context)
        armor.cost = ""
        armor.info = ""
        armor.name = ""
        armor.quantity = 1
        armor.weight = ""
        return armor
    }
    
}
