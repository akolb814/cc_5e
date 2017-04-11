//
//  BackgroundFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/30/17.
//
//

import Foundation
import CoreData

class BackgroundFactory {
    
    static func getDefaultBackground(context: NSManagedObjectContext) -> Background {
        return getAcolyteBackground(context: context)
    }
    
    static func getAcolyteBackground(context: NSManagedObjectContext) -> Background {
        let acolyte = Background(context: context)
        acolyte.name = "Acolyte"
        acolyte.features = "You have spent your life in the service of a temple to a specific god or pantheon of gods. You act as an intermediary between the realm of the holy and the mortal world. performing sacred rites and offering sacrifices in order to conduct worshipers into the presence of the divine. You are not necessarily a cleric—performing sacred rites is not the same thing as channeling divine power."
        return acolyte
    }

}
