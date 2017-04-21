//
//  ToolFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation
import SwiftyJSON

class ToolFactory {
    
    static func getTool(character: Character, json: JSON, context: NSManagedObjectContext) -> Tool {
        let tool = Tool(context: context)
        tool.proficient = json["proficient"].bool!
        tool.ability = CharacterFactory.getAbility(character: character, name: "INT", context: context)
        tool.cost = json["cost"].string
        tool.info = json["description"].string
        tool.name = json["name"].string
        tool.quantity = json["quantity"].int32!
        tool.weight = json["weight"].string
        return tool
    }
    
    static func getEmptyTool(character: Character, context: NSManagedObjectContext) -> Tool {
        let tool = Tool(context: context)
        tool.proficient = false
        tool.ability = CharacterFactory.getAbility(character: character, name: "INT", context: context)
        tool.cost = ""
        tool.info = ""
        tool.name = ""
        tool.quantity = 1
        tool.weight = ""
        return tool
    }
    
}
