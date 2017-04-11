//
//  Character.swift
//  cc_swift
//
//  Created by Rip Britton on 3/9/17.
//
//

import Foundation
import UIKit

extension Character {
    
    @nonobjc static var Selected : Character!
    
    func getImage() -> UIImage {
        return UIImage(named: "default_character_image")!
    }
    
    var strBonus: Int {
        return Int(getAbility(name: Types.Abilities.STR.rawValue).modifier)
    }
    
    var dexBonus: Int {
        return Int(getAbility(name: Types.Abilities.DEX.rawValue).modifier)
    }
    
    var conBonus: Int {
        return Int(getAbility(name: Types.Abilities.CON.rawValue).modifier)
    }
    
    var intBonus: Int {
        return Int(getAbility(name: Types.Abilities.INT.rawValue).modifier)
    }
    
    var wisBonus: Int {
        return Int(getAbility(name: Types.Abilities.WIS.rawValue).modifier)
    }
    
    var chaBonus: Int {
        return Int(getAbility(name: Types.Abilities.CHA.rawValue).modifier)
    }
    
    var strScore: Int {
        return Int(getAbility(name: Types.Abilities.STR.rawValue).score)
    }
    
    var dexScore: Int {
        return Int(getAbility(name: Types.Abilities.DEX.rawValue).score)
    }
    
    var conScore: Int {
        return Int(getAbility(name: Types.Abilities.CON.rawValue).score)
    }
    
    var intScore: Int {
        return Int(getAbility(name: Types.Abilities.INT.rawValue).score)
    }
    
    var wisScore: Int {
        return Int(getAbility(name: Types.Abilities.WIS.rawValue).score)
    }
    
    var chaScore: Int {
        return Int(getAbility(name: Types.Abilities.CHA.rawValue).score)
    }
    
    var strSave: Int {
        return Int(getAbility(name: Types.Abilities.STR.rawValue).save)
    }
    
    var dexSave: Int {
        return Int(getAbility(name: Types.Abilities.DEX.rawValue).save)
    }
    
    var conSave: Int {
        return Int(getAbility(name: Types.Abilities.CON.rawValue).save)
    }
    
    var intSave: Int {
        return Int(getAbility(name: Types.Abilities.INT.rawValue).save)
    }
    
    var wisSave: Int {
        return Int(getAbility(name: Types.Abilities.WIS.rawValue).save)
    }
    
    var chaSave: Int {
        return Int(getAbility(name: Types.Abilities.CHA.rawValue).save)
    }
    
    var proficiencyBonus: Int {
        return Int(proficiency_bonus)
    }
    
    var primaryClass: Class {
        for object in classes! {
            let classType = object as! Class
            if classType.primary {
                return classType
            }
        }
        return Class()
    }
    
    func updateAbility(name: String, score: Int32, proficient: Bool) {
        let ability = getAbility(name: name)
        ability.score = score
        ability.modifier = (score - 10)/2
        ability.save = (score-10)/2
        ability.save_proficiency = proficient
        if(ability.save_proficiency) {
            ability.save += proficiencyBonus
        }
    }
    
    func updateSkill(name: String, proficient: Bool, expertise: Bool) {
        let skill = getSkill(name: name)
        skill.proficiency = proficient
        skill.expertise = expertise
    }
    
    func getAbility(name: String) -> Ability {
        let index = name.index(name.startIndex, offsetBy: 3)
        for object in (abilities?.allObjects)! {
            let ability = object as! Ability
            if (ability.name == name || ability.name?.uppercased() == name.substring(to: index).uppercased()) {
                return ability
            }
        }
        return Ability()
    }
    
    func getAbility(abilityIn: Types.Abilities) -> Ability {
        for object in (abilities?.allObjects)! {
            let ability = object as! Ability
            if (ability.name == abilityIn.rawValue) {
                return ability
            }
        }
        return Ability()
    }
    
    func getSkill(skillIn: Types.Skills) -> Skill {
        for object in (skills?.allObjects)! {
            let skill = object as! Skill
            if (skill.name == skillIn.rawValue) {
                return skill
            }
        }
        return Skill()
    }
    
    func getSkill(name: String) -> Skill {
        for object in (skills?.allObjects)! {
            let skill = object as! Skill
            if (skill.name == name) {
                return skill
            }
        }
        return Skill()
    }
    /*
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
 */
}
