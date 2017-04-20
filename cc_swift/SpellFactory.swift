//
//  SpellFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData
import SwiftyJSON

class SpellFactory {
    
    static func getEmptySpell(context: NSManagedObjectContext) -> Spell {
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
    
    static func getSpell(json: JSON, context: NSManagedObjectContext) -> Spell {
        let spell = Spell(context: context)
        spell.casting_time = json["casting_time"].string
        spell.components = json["components"].string
        spell.concentration = json["concentration"].bool!
        spell.duration = json["duration"].string
        spell.expanded = json["expanded"].bool!
        spell.higher_level = json["higher_level"].string
        spell.info = json["description"].string
        spell.name = json["name"].string
        spell.prepared = json["prepared"].bool!
        spell.range = json["range"].string
        spell.school = json["school"].string
        return spell
    }
    
}
