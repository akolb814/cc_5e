//
//  Character.swift
//  cc_swift
//
//  Created by Andrew Kolb on 1/31/17.
//
//

import UIKit
import SwiftyJSON

class Character {
    var character: JSON = [:]
    var name = ""
    var classes: JSON = []
    var race: JSON = [:]
    var background: JSON = [:]
    var alignment = ""
    var experience = ""
    
    var currentHitDice = 0
    var maxHitDice = 0
    var hitDieType = 0
    var hasExtraHitDie1 = false
    var extra1CurrentHitDice = 0
    var extra1MaxHitDice = 0
    var extra1HitDieType = 0
    var hasExtraHitDie2 = false
    var extra2CurrentHitDice = 0
    var extra2MaxHitDice = 0
    var extra2HitDieType = 0
    var hasExtraHitDie3 = false
    var extra3CurrentHitDice = 0
    var extra3MaxHitDice = 0
    var extra3HitDieType = 0
    
    
    var currentHP = 0
    var maxHP = 0
    
    var AC = 0
    var ACMiscBonus = 0
    var hasAdditionalACMod = false
    var additionalACMod = ""
    
    var proficiencyBonus = 2
    var initiative = 0
    var initiativeMiscBonus = 0
    var passivePerception = 10
    
    var speedType = 0
    var walkSpeed = 0
    var walkSpeedMiscBonus = 0
    var burrowSpeed = 0
    var burrowSpeedMiscBonus = 0
    var climbSpeed = 0
    var climbSpeedMiscBonus = 0
    var flySpeed = 0
    var flySpeedMiscBonus = 0
    var swimSpeed = 0
    var swimSpeedMiscBonus = 0
    
    var saveProficiencies: JSON = []
    var strScore = 0
    var strBonus = 0
    var strSave = 0
    
    var dexScore = 0
    var dexBonus = 0
    var dexSave = 0
    
    var conScore = 0
    var conBonus = 0
    var conSave = 0
    
    var intScore = 0
    var intBonus = 0
    var intSave = 0
    
    var wisScore = 0
    var wisBonus = 0
    var wisSave = 0
    
    var chaScore = 0
    var chaBonus = 0
    var chaSave = 0
    
    var skills: JSON = []
    
    var weaponProficiencies = ""
    var armorProficienceies = ""
    var toolProficiencies = ""
    var languages = ""
    var personalityTraits = ""
    var ideals = ""
    var bonds = ""
    var flaws = ""
    var notes = ""
    
    var equipment: JSON = [:]
    var spellcasting: JSON = [:]
    var martialResource: JSON = [:]
    var spellcastingResource: JSON = [:]
    
    var alertFeat = false
    var halfProfOnInitiative = false
    var roundUpOnInitiative = false
    
    
    func loadCharacter(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
//                    print("jsonData:\(jsonObj)")
                    character = jsonObj
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        name = character["name"].stringValue
        classes = character["classes"]
        race = character["race"]
        background = character["background"]
        alignment = character["alignment"].stringValue
        experience = character["experience"].stringValue
        
        speedType = character["speed_type"].intValue
        walkSpeed = character["walk_speed"].intValue
        walkSpeedMiscBonus = character["walk_speed_misc_bonus"].intValue
        burrowSpeed = character["burrow_speed"].intValue
        burrowSpeedMiscBonus = character["burrow_speed_misc_bonus"].intValue
        climbSpeed = character["climb_speed"].intValue
        climbSpeedMiscBonus = character["climb_speed_misc_bonus"].intValue
        flySpeed = character["fly_speed"].intValue
        flySpeedMiscBonus = character["fly_speed_misc_bonus"].intValue
        swimSpeed = character["swim_speed"].intValue
        swimSpeedMiscBonus = character["swim_speed_misc_bonus"].intValue
        
        weaponProficiencies = character["weapon_proficiencies"].stringValue
        armorProficienceies = character["armor_proficiencies"].stringValue
        toolProficiencies = character["tool_proficiencies"].stringValue
        languages = character["languages"].stringValue
        personalityTraits = character["personality_traits"].stringValue
        ideals = character["ideals"].stringValue
        bonds = character["bonds"].stringValue
        flaws = character["flaws"].stringValue
        notes = character["notes"].stringValue
        
        let ability_scores = character["ability_scores"].dictionaryValue
        let str = ability_scores["STR"]?.dictionaryValue
        strScore = (str?["score"]?.intValue)!
        strBonus = (str?["bonus"]?.intValue)!
        strSave = (str?["save"]?.intValue)!
        
        let dex = ability_scores["DEX"]?.dictionaryValue
        dexScore = (dex?["score"]?.intValue)!
        dexBonus = (dex?["bonus"]?.intValue)!
        dexSave = (dex?["save"]?.intValue)!
        
        let con = ability_scores["CON"]?.dictionaryValue
        conScore = (con?["score"]?.intValue)!
        conBonus = (con?["bonus"]?.intValue)!
        conSave = (con?["save"]?.intValue)!
        
        let int = ability_scores["INT"]?.dictionaryValue
        intScore = (int?["score"]?.intValue)!
        intBonus = (int?["bonus"]?.intValue)!
        intSave = (int?["save"]?.intValue)!
        
        let wis = ability_scores["WIS"]?.dictionaryValue
        wisScore = (wis?["score"]?.intValue)!
        wisBonus = (wis?["bonus"]?.intValue)!
        wisSave = (wis?["save"]?.intValue)!
        
        let cha = ability_scores["CHA"]?.dictionaryValue
        chaScore = (cha?["score"]?.intValue)!
        chaBonus = (cha?["bonus"]?.intValue)!
        chaSave = (cha?["save"]?.intValue)!
        
        skills = character["skills"]
        
        let firstClass: JSON = classes[0]
        
        currentHitDice = character["current_hit_dice"].intValue
        maxHitDice = firstClass["level"].int!
        hitDieType = firstClass["hitDie"].int!
        hasExtraHitDie1 = false
        extra1CurrentHitDice = 0
        extra1MaxHitDice = 0
        extra1HitDieType = 0
        hasExtraHitDie2 = false
        extra2CurrentHitDice = 0
        extra2MaxHitDice = 0
        extra2HitDieType = 0
        hasExtraHitDie3 = false
        extra3CurrentHitDice = 0
        extra3MaxHitDice = 0
        extra3HitDieType = 0
        
        currentHP = character["current_hp"].intValue
        maxHP = character["max_hp"].intValue
        proficiencyBonus = character["proficiency_bonus"].intValue
        initiativeMiscBonus = character["initiative_misc_bonus"].intValue
        self.calcInitiative()
        saveProficiencies = character["save_proficiencies"]
        
        equipment = character["equipment"]
        self.calcAC()
        spellcasting = character["spellcasting"]
        
        let resources = character["resources"]
        martialResource = (resources["martial"])
        spellcastingResource = (resources["spellcasting"])
    }
    
    func saveCharacter(filename: String) {
        // Update the character dict based on properties
        character["name"].string = name
        character["classes"] = classes
        character["race"] = race
        character["background"] = background
        character["alignment"].string = alignment
        character["experience"].string = experience
        
        character["speed_type"].int = speedType
        character["walk_speed"].int = walkSpeed
        character["walk_speed_misc_bonus"].int = walkSpeedMiscBonus
        character["burrow_speed"].int = burrowSpeed
        character["burrow_speed_misc_bonus"].int = burrowSpeedMiscBonus
        character["climb_speed"].int = climbSpeed
        character["climb_speed_misc_bonus"].int = climbSpeedMiscBonus
        character["fly_speed"].int = flySpeed
        character["fly_speed_misc_bonus"].int = flySpeedMiscBonus
        character["swim_speed"].int = swimSpeed
        character["swim_speed_misc_bonus"].int = swimSpeedMiscBonus
        
        character["weapon_proficiencies"].string = weaponProficiencies
        character["armor_proficiencies"].string = armorProficienceies
        character["tool_proficiencies"].string = toolProficiencies
        character["languages"].string = languages
        character["personality_traits"].string = personalityTraits
        character["ideals"].string = ideals
        character["bonds"].string = bonds
        character["flaws"].string = flaws
        character["notes"].string = notes
        
        var ability_scores = character["ability_scores"].dictionaryValue
        var str = ability_scores["STR"]?.dictionaryValue
        str?["score"]?.int = strScore
        str?["bonus"]?.int = strBonus
        str?["save"]?.int = strSave
        ability_scores["STR"]?.dictionaryObject = str
        
        var dex = ability_scores["DEX"]?.dictionaryValue
        dex?["score"]?.int = dexScore
        dex?["bonus"]?.int = dexBonus
        dex?["save"]?.int = dexSave
        ability_scores["DEX"]?.dictionaryObject = dex
        
        var con = ability_scores["CON"]?.dictionaryValue
        con?["score"]?.int = conScore
        con?["bonus"]?.int = conBonus
        con?["save"]?.int = conSave
        ability_scores["CON"]?.dictionaryObject = con
        
        var int = ability_scores["INT"]?.dictionaryValue
        int?["score"]?.int = intScore
        int?["bonus"]?.int = intBonus
        int?["save"]?.int = intSave
        ability_scores["INT"]?.dictionaryObject = int
        
        var wis = ability_scores["WIS"]?.dictionaryValue
        wis?["score"]?.int = wisScore
        wis?["bonus"]?.int = wisBonus
        wis?["save"]?.int = wisSave
        ability_scores["WIS"]?.dictionaryObject = wis
        
        var cha = ability_scores["CHA"]?.dictionaryValue
        cha?["score"]?.int = chaScore
        cha?["bonus"]?.int = chaBonus
        cha?["save"]?.int = chaSave
        ability_scores["CHA"]?.dictionaryObject = cha
        character["ability_scores"].dictionaryObject = ability_scores
        
        character["skills"] = skills
        
        character["current_hit_dice"].int = currentHitDice
        character["current_hp"].int = currentHP
        character["max_hp"].int = maxHP
        character["ac"].int = AC
        character["proficiency_bonus"].int = proficiencyBonus
        character["initiative_misc_bonus"].int = initiativeMiscBonus
        character["save_proficiencies"] = saveProficiencies
        
        character["equipment"] = equipment
        character["spellcasting"] = spellcasting
        
        character["resources"].dictionaryObject = ["martial":martialResource, "spellcasting":spellcastingResource]
        
        // Save the character dict as JSON to the file
        let path = Bundle.main.path(forResource: filename, ofType: "json")
        let characterStr = character.description
        let data = characterStr.data(using: String.Encoding.utf8)
        if let file = FileHandle(forWritingAtPath:path!) {
            file.write(data!)
        }
    }
    
    func getBonus(score: Int) -> Int {
        let bonus = (score/2)-5
        return bonus
    }
    
    func getSave(bonus: Int, attribute: JSON) -> Int {
        var save = bonus
        let isContained = saveProficiencies.arrayValue.contains(attribute)
        
        if isContained {
            save += proficiencyBonus
        }
        return save
    }
    
    func getHpMaximum() {
        let firstClass = classes[0]
        let hitDie: Int = firstClass["hitDie"].int!
        let level: Int = firstClass["level"].int!
        maxHP = 0
        
        var i = 1
        while i < level+1 {
            if i == 1 {
                maxHP = hitDie + conBonus
            }
            else {
                maxHP += (hitDie/2) + 1 + conBonus
            }
            i += 1
        }
    }
    
    func calcInitiative() {
        initiative = proficiencyBonus + dexBonus + initiativeMiscBonus
        if alertFeat == true {
            initiative = initiative + 5
        }
        if halfProfOnInitiative == true {
            if roundUpOnInitiative == true {
                initiative = initiative + (proficiencyBonus/2)
            }
            else {
                initiative = initiative + (proficiencyBonus/2)
            }
        }
    }
    
    func calcPP() {
        var perceptionSkill = [:] as JSON
        for case let skill in skills.array! {
            let skillName = skill["skill"].string!
            if skillName == "Perception" {
                perceptionSkill = skill
            }
        }
        
        let attribute = perceptionSkill["attribute"].string!
        var skillValue = 0
        switch attribute {
        case "STR":
            skillValue += strBonus
        case "DEX":
            skillValue += dexBonus
        case "CON":
            skillValue += conBonus
        case "INT":
            skillValue += intBonus
        case "WIS":
            skillValue += wisBonus
        case "CHA":
            skillValue += chaBonus
        default: break
        }
        
        let isProficient = perceptionSkill["proficient"].bool!
        if isProficient {
            skillValue += proficiencyBonus
        }
        passivePerception = 10+skillValue
    }
    
    func calcAC() {
        var armorClass = 0
        var armorEquipped = false
        let allArmor = equipment["armor"]
        for armor in allArmor.array! {
            if armor["equipped"] == true {
                armorClass = armorClass + armor["value"].int!
                
                if armor["max_dex"].int != 0 {
                    if dexBonus <= armor["max_dex"].int! {
                        armorClass = armorClass + dexBonus
                    }
                    else {
                        armorClass = armorClass + armor["max_dex"].int!
                    }
                }
                else {
                    if armor["mod"] != "" {
                        armorClass = armorClass + dexBonus
                    }
                }
                armorClass = armorClass + armor["magic_bonus"].int!
                armorClass = armorClass + armor["misc_bonus"].int!
                if armor["shield"] == false {
                    armorEquipped = true
                }
            }
        }
        
        if armorEquipped == false {
            armorClass = armorClass + 10 + dexBonus
        }
        
        armorClass = armorClass + ACMiscBonus
        
        if hasAdditionalACMod == true {
            switch additionalACMod {
            case "STR":
                armorClass += strBonus
            case "DEX":
                armorClass += dexBonus
            case "CON":
                armorClass += conBonus
            case "INT":
                armorClass += intBonus
            case "WIS":
                armorClass += wisBonus
            case "CHA":
                armorClass += chaBonus
            default: break
            }
        }
        
        AC = armorClass
    }
}
