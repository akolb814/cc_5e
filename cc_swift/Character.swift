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
    
    func getAbility(name: String) -> Ability {
        for object in (abilities?.allObjects)! {
            let ability = object as! Ability
            if (ability.name == name) {
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
}
