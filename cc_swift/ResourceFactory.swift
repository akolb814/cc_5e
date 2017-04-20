//
//  ResourceFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData
import SwiftyJSON

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
    
    static func getResource(json: JSON, context: NSManagedObjectContext) -> Resource {
        let resource = Resource(context: context)
        resource.spellcasting = json["spellcasting"].bool!
        resource.current_value = json["current_value"].int32!
        resource.die_type = json["die_type"].int32!
        resource.max_value = json["max_value"].int32!
        resource.name = json["name"].string
        return resource
    }
    
}
