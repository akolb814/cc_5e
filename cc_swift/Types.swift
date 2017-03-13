//
//  Types.swift
//  cc_swift
//
//  Created by Rip Britton on 3/9/17.
//
//

import Foundation

class Types {
    static let DamageStrings = ["Bludgeoning", "Piercing", "Slashing", "Acid", "Cold", "Fire", "Force", "Lightning", "Necrotic", "Poison", "Psychic", "Radiant", "Thunder"]
    
    static let AbilitiesStrings = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
    
    static let SkillsStrings = ["Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", "History", "Insight", "Intimidation", "Investigation", "Medicine", "Nature", "Perception", "Performance", "Persuasion", "Religion", "Sleight of Hand", "Stealth", "Survival"]
    
    static let SkillToAbilityDictionary: [String: String] =  [
        "Acrobatics": "DEX",
        "Animal Handling": "WIS",
        "Arcana":"INT",
        "Athletics": "STR",
        "Deception": "CHA",
        "History": "INT",
        "Insight": "WIS",
        "Intimidation": "CHA",
        "Investigation": "INT",
        "Medicine": "WIS",
        "Nature": "INT",
        "Perception": "WIS",
        "Performance": "CHA",
        "Persuasion": "CHA",
        "Religion": "INT",
        "Sleight of Hand": "DEX",
        "Stealth": "DEX",
        "Survival" : "WIS"]
    
    enum Damage: String {
        case Bludgeoning = "Bludgeoning"
        case Piercing = "Piercing"
        case Slashing = "Slashing"
        case Acid = "Acid"
        case Cold = "Cold"
        case Fire = "Fire"
        case Force = "Force"
        case Lightning = "Lightning"
        case Necrotic = "Necrotic"
        case Poison = "Poison"
        case Psychic = "Psychic"
        case Radiant = "Radiant"
        case Thunder = "Thunder"
    }
    
    enum Abilities: String {
        case STR = "STR"
        case DEX = "DEX"
        case CON = "CON"
        case INT = "INT"
        case WIS = "WIS"
        case CHA = "CHA"
    }
    
    enum Skills: String {
        case Acrobatics = "Acrobatics"
        case Animal_Handling = "Animal Handling"
        case Arcana = "Arcana"
        case Athletics = "Athletics"
        case Deception = "Deception"
        case History = "History"
        case Insight = "Insight"
        case Intimidation = "Intimidation"
        case Investigation = "Investigation"
        case Medicine = "Medicine"
        case Nature = "Nature"
        case Perception = "Perception"
        case Performance = "Performance"
        case Persuasion = "Persuasion"
        case Religion = "Religion"
        case Sleight_of_Hand = "Sleight of Hand"
        case Stealth = "Stealth"
        case Survival = "Survival"
    }

}
