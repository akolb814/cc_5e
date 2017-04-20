//
//  CurrencyFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class CurrencyFactory {
    
    static func getCurrency(json: JSON, context: NSManagedObjectContext) -> Currency {
        let currency = Currency(context: context)
        currency.copper = json["copper"].int32!
        currency.electrum = json["electrum"].int32!
        currency.gold = json["gold"].int32!
        currency.platinum = json["platinum"].int32!
        currency.silver = json["silver"].int32!
        return currency
    }
    
    static func getEmptyCurrency(context: NSManagedObjectContext) -> Currency {
        let currency = Currency(context: context)
        currency.copper = 0
        currency.electrum = 0
        currency.gold = 0
        currency.platinum = 0
        currency.silver = 0
        return currency
    }
    
}
