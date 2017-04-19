//
//  ItemFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class ItemFactory {
    
    static func getEmptyItem(context: NSManagedObjectContext) -> Item {
        let item = Item(context: context)
        item.cost = ""
        item.info = ""
        item.name = ""
        item.quantity = 1
        item.weight = ""
        return item
    }
    
}
