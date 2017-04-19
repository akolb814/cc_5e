//
//  EquipmentFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/30/17.
//
//

import CoreData
import Foundation

class EquipmentFactory {
    
    static func getEmptyEquipment(context: NSManagedObjectContext) -> Equipment {
        let equipment = Equipment(context: context)
        
        var armor: [Armor] = []
        armor.append(ArmorFactory.getEmptyArmor(context: context))
        equipment.armor = NSSet(array: armor)
        
        equipment.currency = CurrencyFactory.getEmptyCurrency(context:context)
        
        var item: [Item] = []
        item.append(ItemFactory.getEmptyItem(context: context))
        equipment.other = NSSet(array: item)
        
        var tool: [Tool] = []
        tool.append(ToolFactory.getEmptyTool(context: context))
        equipment.tools = NSSet(array: tool)
        
        var weapon: [Weapon] = []
        weapon.append(WeaponFactory.getEmptyWeapon(context: context))
        equipment.weapons = NSSet(array: weapon)
        
        return equipment
    }
    
}
