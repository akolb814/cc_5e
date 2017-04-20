//
//  SpellLevelFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData
import SwiftyJSON

class SpellLevelFactory {
    
    static func getEmptySpellLevel(context: NSManagedObjectContext) -> Spells_by_Level {
        let spellLevel = Spells_by_Level(context: context)
        spellLevel.expanded = false
        spellLevel.level = 0
        spellLevel.name = "Cantrips"
        spellLevel.remaining_slots = 0
        spellLevel.total_slots = 0
        
        var spells: [Spell] = []
        spells.append(SpellFactory.getEmptySpell(context: context))
        spells.append(SpellFactory.getEmptySpell(context: context))
        spellLevel.spells = NSSet(array: spells)
        
        return spellLevel
    }
    
    static func getSpellLevel(json: JSON, context: NSManagedObjectContext) -> Spells_by_Level {
        let spellLevel = Spells_by_Level(context: context)
        spellLevel.expanded = json["expanded"].bool!
        spellLevel.level = json["level"].int32!
        spellLevel.name = "Cantrips"
        spellLevel.remaining_slots = json["remaining_slots"].int32!
        spellLevel.total_slots = json["total_slots"].int32!
        
        var spells: [Spell] = []
        for (index,spell):(String,JSON) in json["prepared_spells"] {
            print(index)
            spells.append(SpellFactory.getSpell(json: spell, context: context))
        }
        spellLevel.spells = NSSet(array: spells)
        
        return spellLevel
    }
    
}
