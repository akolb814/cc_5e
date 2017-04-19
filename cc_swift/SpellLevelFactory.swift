//
//  SpellLevelFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData

class SpellLevelFactory {
    
    static func getEmptySpellLevel(context: NSManagedObjectContext) -> Spells_by_Level {
        let spellLevel = Spells_by_Level(context: context)
        spellLevel.expanded = false
        spellLevel.level = 0
        spellLevel.name = "Cantrips"
        spellLevel.remaining_slots = 0
        spellLevel.total_slots = 0
        
        var spells: [Spell] = []
        spells.append(SpellFactory.getEmptySpells(context: context))
        spells.append(SpellFactory.getEmptySpells(context: context))
        spellLevel.spells = NSSet(array: spells)
        
        return spellLevel
    }
    

    
}
