//
//  SpellFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData

class SpellFactory {
    
    static func getEmptySpells(context: NSManagedObjectContext) -> Spell {
        let spell = Spell(context: context)
        spell.casting_time = ""
        spell.components = ""
        spell.concentration = false
        spell.duration = ""
        spell.expanded = false
        spell.higher_level = ""
        spell.info = ""
        spell.name = ""
        spell.prepared = false
        spell.range = ""
        spell.school = ""
        return spell
    }
    

    
}
