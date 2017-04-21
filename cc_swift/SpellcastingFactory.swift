//
//  SpellcastingFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/30/17.
//
//
import Foundation
import CoreData
import SwiftyJSON

class SpellcastingFactory {
    
    static func getEmptySpellcasting(character: Character, context: NSManagedObjectContext) -> Spellcasting {
        let spellcasting = Spellcasting(context: context)
        spellcasting.caster_level = 0
        spellcasting.dc_bonus = 0
        spellcasting.attack_bonus = 0
        spellcasting.ability = CharacterFactory.getAbility(character: character, name: "INT", context: context)
        
        var spells_by_level: [Spells_by_Level] = []
        spells_by_level.append(SpellLevelFactory.getEmptySpellLevel(context: context))
        spellcasting.spells_by_level = NSSet(array: spells_by_level)
        
        return spellcasting
    }
    
    static func getSpellcasting(character: Character, json: JSON ,context: NSManagedObjectContext) -> Spellcasting {
        let spellcasting = Spellcasting(context: context)
        spellcasting.caster_level = json["spellcasting"]["caster_level"].int32!
        spellcasting.dc_bonus = json["spellcasting"]["spell_dc_misc_bonus"].int32!
        spellcasting.attack_bonus = json["spellcasting"]["spell_attack_misc_bonus"].int32!
        spellcasting.ability = CharacterFactory.getAbility(character: character, name: json["spellcasting"]["spell_ability"].string!, context: context)
        
        var spells_by_level: [Spells_by_Level] = []
        for (index,spellLevel):(String,JSON) in json["spellcasting"]["spells"] {
            print(index)
            spells_by_level.append(SpellLevelFactory.getSpellLevel(json:spellLevel, context: context))
        }
        spellcasting.spells_by_level = NSSet(array: spells_by_level)
        
        return spellcasting
    }
    
}
