//
//  CurrencyFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class CurrencyFactory {
    
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
