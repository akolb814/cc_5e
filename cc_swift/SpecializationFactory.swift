//
//  SpecializationFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/19/17.
//
//
import Foundation
import CoreData

class SpecializationFactory {
    
    static func getEmptySpecialization(context: NSManagedObjectContext) -> Specialization {
        let specialization = Specialization(context: context)
        specialization.features = ""
        specialization.id = 0
        specialization.name = ""
        return specialization
    }
    

    
}
