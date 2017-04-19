//
//  SpellcastingFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/30/17.
//
//
import Foundation
import CoreData

class SpellcastingFactory {
    
    static func getEmptySpellcasting(context: NSManagedObjectContext) -> Spellcasting {
        let spellcasting = Spellcasting(context: context)
        spellcasting.caster_level = 0
        spellcasting.dc_bonus = 0
        spellcasting.attack_bonus = 0
        spellcasting.ability = CharacterFactory.getEmptyAbility(name: "INT", context: context)
        
        var spells_by_level: [Spells_by_Level] = []
        spells_by_level.append(SpellLevelFactory.getEmptySpellLevel(context: context))
        spellcasting.spells_by_level = NSSet(array: spells_by_level)
        
        return spellcasting
    }
    

    
}
