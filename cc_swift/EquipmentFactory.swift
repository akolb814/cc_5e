//
//  EquipmentFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/30/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class EquipmentFactory {
    
    static func getEquipment(character: Character, json: JSON, context: NSManagedObjectContext) -> Equipment {
        let equipment = Equipment(context: context)
        var armor: [Armor] = []
        for (index,armorJSON):(String,JSON) in json["equipment"]["armor"] {
            let armor_object = ArmorFactory.getArmor(character: character, json: armorJSON, context: context)
            armor.append(armor_object)
        }
        equipment.armor = NSSet(array: armor)
        
        equipment.currency = CurrencyFactory.getCurrency(json: json["equipment"]["currency"], context:context)
        
        var item: [Item] = []
        for (index,itemJSON):(String,JSON) in json["equipment"]["other"] {
            let item_object = ItemFactory.getItem(json: itemJSON, context: context)
            item.append(item_object)
        }
        equipment.other = NSSet(array: item)
        
        var tool: [Tool] = []
        for (index,toolJSON):(String,JSON) in json["equipment"]["tools"] {
            let tool_object = ToolFactory.getTool(character: character, json: toolJSON, context: context)
            tool.append(tool_object)
        }
        equipment.tools = NSSet(array: tool)
        
        var weapon: [Weapon] = []
        for (index,weaponJSON):(String,JSON) in json["equipment"]["weapons"] {
            let weapon_object = WeaponFactory.getWeapon(character: character, json:weaponJSON, context: context)
            weapon.append(weapon_object)
        }
        equipment.weapons = NSSet(array: weapon)
        
        return equipment
    }
    
    static func getEmptyEquipment(character: Character, context: NSManagedObjectContext) -> Equipment {
        let equipment = Equipment(context: context)
        
        var armor: [Armor] = []
        armor.append(ArmorFactory.getEmptyArmor(character: character, context: context))
        equipment.armor = NSSet(array: armor)
        
        equipment.currency = CurrencyFactory.getEmptyCurrency(context:context)
        
        var item: [Item] = []
        item.append(ItemFactory.getEmptyItem(context: context))
        equipment.other = NSSet(array: item)
        
        var tool: [Tool] = []
        tool.append(ToolFactory.getEmptyTool(character: character, context: context))
        equipment.tools = NSSet(array: tool)
        
        var weapon: [Weapon] = []
        weapon.append(WeaponFactory.getEmptyWeapon(character: character, context: context))
        equipment.weapons = NSSet(array: weapon)
        
        return equipment
    }
    
}
