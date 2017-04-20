//
//  ClassFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/27/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class ClassFactory {
    
    static func getDefaultClass(context: NSManagedObjectContext) -> Class {
        var defaultClass = getBarbarian(context: context)
        defaultClass.primary = true
        return defaultClass
    }
    
    static func getClass(json: JSON, context: NSManagedObjectContext) -> Class {
        let newClass = Class(context: context)
        newClass.name = json["class"].string
        newClass.hit_die = json["hitDie"].int32!
        newClass.level = json["level"].int32!
        newClass.features = json["features"].string
        newClass.specialization = SpecializationFactory.getEmptySpecialization(context: context)
        return newClass
    }
    
    static func getBarbarian(context: NSManagedObjectContext) -> Class {
        var barbarian = Class(context: context)
        barbarian.name = Types.Classes.Barbarian.rawValue
        barbarian.hit_die = 8
        barbarian.level = 1
        barbarian.features = ""
        barbarian.specialization = SpecializationFactory.getEmptySpecialization(context: context)
        
        return barbarian
    }
    
}
