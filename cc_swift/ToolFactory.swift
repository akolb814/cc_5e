//
//  ToolFactory.swift
//  cc_swift
//
//  Created by Andrew Kolb on 4/18/17.
//
//

import CoreData
import Foundation

class ToolFactory {
    
    static func getEmptyTool(context: NSManagedObjectContext) -> Tool {
        let tool = Tool(context: context)
        tool.proficient = false
        tool.ability = CharacterFactory.getEmptyAbility(name: "INT", context: context)
        tool.cost = ""
        tool.info = ""
        tool.name = ""
        tool.quantity = 1
        tool.weight = ""
        return tool
    }
    
}
