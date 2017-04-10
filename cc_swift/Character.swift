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
    
    static var Selected: Character! = Character()
    
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
    var image: UIImage = UIImage(named:"default_character_image")!
    
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
