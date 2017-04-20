//
//  SpecializationFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData
import SwiftyJSON

class SpecializationFactory {
    
    static func getSpecialization(json: JSON, context: NSManagedObjectContext) -> Specialization {
        let specialization = Specialization(context: context)
        specialization.features = json["features"].string
        specialization.id = json["id"].int32!
        specialization.name = json["name"].string
        return specialization
    }
    
    static func getEmptySpecialization(context: NSManagedObjectContext) -> Specialization {
        let specialization = Specialization(context: context)
        specialization.features = ""
        specialization.id = 0
        specialization.name = ""
        return specialization
    }
    
}
