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
        spellcasting.ability = CharacterFactory.getEmptyAbility(name: "STR", context: context)
        return spellcasting
    }
    

    
}
