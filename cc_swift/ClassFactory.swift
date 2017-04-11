//
//  ClassFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/27/17.
//
//

import CoreData
import Foundation

class ClassFactory {
    
    static func getDefaultClass(context: NSManagedObjectContext) -> Class {
        var defaultClass = getBarbarian(context: context)
        defaultClass.primary = true
        return defaultClass
    }
    
    static func getBarbarian(context: NSManagedObjectContext) -> Class {
        var barbarian = Class(context: context)
        barbarian.name = Types.Classes.Barbarian.rawValue
        barbarian.hit_die = 8
        barbarian.level = 1
        
        return barbarian
    }
    
}
