//
//  CharacterJson.swift
//  cc_swift
//
//  Created by Rip Britton on 3/8/17.
//
//

import Foundation
import SwiftyJSON

class CharacterJson {
    
    static func getCharacterFromJson(filename: String) -> Character {
        var characterJson: JSON = [:]
        let character: Character = Character()

        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //                    print("jsonData:\(jsonObj)")
                    characterJson = jsonObj
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        /**
        character.name = characterJson["name"].stringValue
        character.classes = characterJson["classes"]
        character.race = characterJson["race"]
        character.background = characterJson["background"]
        character.alignment = characterJson["alignment"].stringValue
        character.experience = characterJson["experience"].stringValue
        
        character.speedType = characterJson["speed_type"].intValue
        character.walkSpeed = characterJson["walk_speed"].intValue
        character.walkSpeedMiscBonus = characterJson["walk_speed_misc_bonus"].intValue
        character.burrowSpeed = characterJson["burrow_speed"].intValue
        character.burrowSpeedMiscBonus = characterJson["burrow_speed_misc_bonus"].intValue
        character.climbSpeed = characterJson["climb_speed"].intValue
        character.climbSpeedMiscBonus = characterJson["climb_speed_misc_bonus"].intValue
        character.flySpeed = characterJson["fly_speed"].intValue
        character.flySpeedMiscBonus = characterJson["fly_speed_misc_bonus"].intValue
        character.swimSpeed = characterJson["swim_speed"].intValue
        character.swimSpeedMiscBonus = characterJson["swim_speed_misc_bonus"].intValue
        
        character.weaponProficiencies = characterJson["weapon_proficiencies"].stringValue
        character.armorProficienceies = characterJson["armor_proficiencies"].stringValue
        character.toolProficiencies = characterJson["tool_proficiencies"].stringValue
        character.languages = characterJson["languages"].stringValue
        character.personalityTraits = characterJson["personality_traits"].stringValue
        character.ideals = characterJson["ideals"].stringValue
        character.bonds = characterJson["bonds"].stringValue
        character.flaws = characterJson["flaws"].stringValue
        character.notes = characterJson["notes"].stringValue
        
        let ability_scores = characterJson["ability_scores"].dictionaryValue
        let str = ability_scores["STR"]?.dictionaryValue
        character.strScore = (str?["score"]?.intValue)!
        character.strBonus = (str?["bonus"]?.intValue)!
        character.strSave = (str?["save"]?.intValue)!
        
        let dex = ability_scores["DEX"]?.dictionaryValue
        character.dexScore = (dex?["score"]?.intValue)!
        character.dexBonus = (dex?["bonus"]?.intValue)!
        character.dexSave = (dex?["save"]?.intValue)!
        
        let con = ability_scores["CON"]?.dictionaryValue
        character.conScore = (con?["score"]?.intValue)!
        character.conBonus = (con?["bonus"]?.intValue)!
        character.conSave = (con?["save"]?.intValue)!
        
        let int = ability_scores["INT"]?.dictionaryValue
        character.intScore = (int?["score"]?.intValue)!
        character.intBonus = (int?["bonus"]?.intValue)!
        character.intSave = (int?["save"]?.intValue)!
        
        let wis = ability_scores["WIS"]?.dictionaryValue
        character.wisScore = (wis?["score"]?.intValue)!
        character.wisBonus = (wis?["bonus"]?.intValue)!
        character.wisSave = (wis?["save"]?.intValue)!
        
        let cha = ability_scores["CHA"]?.dictionaryValue
        character.chaScore = (cha?["score"]?.intValue)!
        character.chaBonus = (cha?["bonus"]?.intValue)!
        character.chaSave = (cha?["save"]?.intValue)!
        
        character.skills = characterJson["skills"]
        
        character.currentHitDice = characterJson["current_hit_dice"].intValue
        
        let firstClass: JSON = classes[0]
        character.maxHitDice = firstClass["level"].int!
        character.hitDieType = firstClass["hitDie"].int!
        character.hasExtraHitDie1 = false
        character.extra1CurrentHitDice = 0
        character.extra1MaxHitDice = 0
        character.extra1HitDieType = 0
        character.hasExtraHitDie2 = false
        character.extra2CurrentHitDice = 0
        character.extra2MaxHitDice = 0
        character.extra2HitDieType = 0
        character.hasExtraHitDie3 = false
        character.extra3CurrentHitDice = 0
        character.extra3MaxHitDice = 0
        character.extra3HitDieType = 0
        
        character.currentHP = characterJson["current_hp"].intValue
        character.maxHP = characterJson["max_hp"].intValue
        character.proficiencyBonus = characterJson["proficiency_bonus"].intValue
        character.saveProficiencies = characterJson["save_proficiencies"]
        
        character.initiativeMiscBonus = characterJson["initiative_misc_bonus"].intValue
        character.calcInitiative()
        
        character.equipment = characterJson["equipment"]
        character.calcAC()
        
        character.spellcasting = characterJson["spellcasting"]
        
        let resources = characterJson["resources"]
        character.martialResource = (resources["martial"])
        character.spellcastingResource = (resources["spellcasting"])
        **/
        return character
    }
    
    static func saveCharacterToJson(character: Character, filename: String) {
        var characterJson: JSON = [:]
/**
        // Update the characterJson dict based on properties
        characterJson["name"].string = character.name
        characterJson["classes"] = character.classes
        characterJson["race"] = character.race
        characterJson["background"] = character.background
        characterJson["alignment"].string = character.alignment
        characterJson["experience"].string = character.experience
        
        characterJson["speed_type"].int = character.speedType
        characterJson["walk_speed"].int = character.walkSpeed
        characterJson["walk_speed_misc_bonus"].int = character.walkSpeedMiscBonus
        characterJson["burrow_speed"].int = character.burrowSpeed
        characterJson["burrow_speed_misc_bonus"].int = character.burrowSpeedMiscBonus
        characterJson["climb_speed"].int = character.climbSpeed
        characterJson["climb_speed_misc_bonus"].int = character.climbSpeedMiscBonus
        characterJson["fly_speed"].int = character.flySpeed
        characterJson["fly_speed_misc_bonus"].int = character.flySpeedMiscBonus
        characterJson["swim_speed"].int = character.swimSpeed
        characterJson["swim_speed_misc_bonus"].int = character.swimSpeedMiscBonus
        
        characterJson["weapon_proficiencies"].string = character.weaponProficiencies
        characterJson["armor_proficiencies"].string = character.armorProficienceies
        characterJson["tool_proficiencies"].string = character.toolProficiencies
        characterJson["languages"].string = character.languages
        characterJson["personality_traits"].string = character.personalityTraits
        characterJson["ideals"].string = character.ideals
        characterJson["bonds"].string = character.bonds
        characterJson["flaws"].string = character.flaws
        characterJson["notes"].string = character.notes
        
        var ability_scores = characterJson["ability_scores"].dictionaryValue
        var str = ability_scores["STR"]?.dictionaryValue
        str?["score"]?.int = character.strScore
        str?["bonus"]?.int = character.strBonus
        str?["save"]?.int = character.strSave
        ability_scores["STR"]?.dictionaryObject = str
        
        var dex = ability_scores["DEX"]?.dictionaryValue
        dex?["score"]?.int = character.dexScore
        dex?["bonus"]?.int = character.dexBonus
        dex?["save"]?.int = character.dexSave
        ability_scores["DEX"]?.dictionaryObject = dex
        
        var con = ability_scores["CON"]?.dictionaryValue
        con?["score"]?.int = character.conScore
        con?["bonus"]?.int = character.conBonus
        con?["save"]?.int = character.conSave
        ability_scores["CON"]?.dictionaryObject = con
        
        var int = ability_scores["INT"]?.dictionaryValue
        int?["score"]?.int = character.intScore
        int?["bonus"]?.int = character.intBonus
        int?["save"]?.int = character.intSave
        ability_scores["INT"]?.dictionaryObject = int
        
        var wis = ability_scores["WIS"]?.dictionaryValue
        wis?["score"]?.int = character.wisScore
        wis?["bonus"]?.int = character.wisBonus
        wis?["save"]?.int = character.wisSave
        ability_scores["WIS"]?.dictionaryObject = wis
        
        var cha = ability_scores["CHA"]?.dictionaryValue
        cha?["score"]?.int = character.chaScore
        cha?["bonus"]?.int = character.chaBonus
        cha?["save"]?.int = character.chaSave
        ability_scores["CHA"]?.dictionaryObject = cha
        characterJson["ability_scores"].dictionaryObject = ability_scores
        
        characterJson["skills"] = character.skills
        
        characterJson["current_hit_dice"].int = character.currentHitDice
        characterJson["current_hp"].int = character.currentHP
        characterJson["max_hp"].int = character.maxHP
        characterJson["ac"].int = character.AC
        characterJson["proficiency_bonus"].int = character.proficiencyBonus
        characterJson["initiative_misc_bonus"].int = character.initiativeMiscBonus
        characterJson["save_proficiencies"] = character.saveProficiencies
        
        characterJson["equipment"] = character.equipment
        characterJson["spellcasting"] = character.spellcasting
        
        characterJson["resources"].dictionaryObject = ["martial":character.martialResource, "spellcasting":character.spellcastingResource]
        
 **/
        // Save the character dict as JSON to the file
        let path = Bundle.main.path(forResource: filename, ofType: "json")
        let characterStr = characterJson.description
        let data = characterStr.data(using: String.Encoding.utf8)
        if let file = FileHandle(forWritingAtPath:path!) {
            file.write(data!)
        }

    }
    
}
