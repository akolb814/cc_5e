//
//  ItemFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class ItemFactory {
    
    static func getItem(json: JSON, context: NSManagedObjectContext) -> Item {
        let item = Item(context: context)
        item.cost = json["cost"].string
        item.info = json["description"].string
        item.name = json["name"].string
        item.quantity = json["quantity"].int32!
        item.weight = json["weight"].string
        return item
    }
    
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
