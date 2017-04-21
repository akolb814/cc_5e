//
//  ArmorFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class ArmorFactory {
    
    static func getArmor(character: Character, json: JSON, context: NSManagedObjectContext) -> Armor {
        let armor = Armor(context: context)
        armor.equipped = json["equipped"].bool!
        armor.magic_bonus = json["magic_bonus"].int32!
        armor.max_dex = json["max_dex"].int32!
        armor.misc_bonus = json["misc_bonus"].int32!
        armor.shield = json["shield"].bool!
        armor.stealth_disadvantage = json["stealth_disadvantage"].bool!
        armor.str_requirement = json["str_requirement"].int32!
        armor.value = json["value"].int32!
        armor.ability_mod = CharacterFactory.getAbility(character: character, name: "DEX", context: context)
        armor.cost = json["cost"].string
        armor.info = json["description"].string
        armor.name = json["name"].string
        armor.quantity = json["quantity"].int32!
        armor.weight = json["weight"].string
        return armor
    }
    
    static func getEmptyArmor(character: Character, context: NSManagedObjectContext) -> Armor {
        let armor = Armor(context: context)
        armor.equipped = false
        armor.magic_bonus = 0
        armor.max_dex = 20
        armor.misc_bonus = 0
        armor.shield = false
        armor.stealth_disadvantage = false
        armor.str_requirement = 0
        armor.value = 10
        armor.ability_mod = CharacterFactory.getAbility(character: character, name: "DEX", context: context)
        armor.cost = ""
        armor.info = ""
        armor.name = ""
        armor.quantity = 1
        armor.weight = ""
        return armor
    }
    
}
