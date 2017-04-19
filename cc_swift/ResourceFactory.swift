//
//  ResourceFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData

class ResourceFactory {
    
    static func getEmptyResource(context: NSManagedObjectContext) -> Resource {
        let resource = Resource(context: context)
        resource.spellcasting = true
        resource.current_value = 0
        resource.die_type = 0
        resource.max_value = 0
        resource.name = ""
        return resource
    }
    

    
}
