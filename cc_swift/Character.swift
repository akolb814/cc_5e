//
//  Character.swift
//  cc_swift
//
//  Created by Rip Britton on 3/9/17.
//
//

import Foundation
import UIKit
import CoreData

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
    
    func calcInitiative() {
        var initiative = self.proficiency_bonus + self.dexBonus + self.initiative_misc
        if self.alert_feat == true {
            initiative = initiative + 5
        }
        if self.initiative_half_proficiency == true {
            if self.initiative_round_up == true {
                initiative = initiative + (self.proficiency_bonus/2)
            }
            else {
                initiative = initiative + (self.proficiency_bonus/2)
            }
        }
    }
    
    func calcPP() {
        let perceptionSkill = self.getSkill(skillIn: Types.Skills.Perception)
        let attribute = perceptionSkill.ability?.name
        var skillValue: Int32 = 0
        switch attribute! {
        case "STR":
            skillValue += self.strBonus
        case "DEX":
            skillValue += self.dexBonus
        case "CON":
            skillValue += self.conBonus
        case "INT":
            skillValue += self.intBonus
        case "WIS":
            skillValue += self.wisBonus
        case "CHA":
            skillValue += self.chaBonus
        default: break
        }
        
        let isProficient = perceptionSkill.proficiency
        if isProficient {
            skillValue += self.proficiency_bonus
        }
        self.passive_perception = 10+skillValue
    }
    
    func calcAC() {
        var armorClass: Int32 = 0
        var armorEquipped = false
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Armor")
        do {
            let fetchedArmor = try moc.fetch(fetchRequest) as! [Armor]
            
            for armor: Armor in fetchedArmor {
                if armor.equipped == true {
                    armorClass = armorClass + armor.value
                    
                    if armor.max_dex != 0 {
                        if self.dexBonus <= Int(armor.max_dex) {
                            armorClass = armorClass + self.dexBonus
                        }
                        else {
                            armorClass = armorClass + armor.max_dex
                        }
                    }
                    else {
                        if armor.ability_mod?.name != "" {
                            armorClass = armorClass + self.dexBonus
                        }
                    }
                    armorClass = armorClass + armor.magic_bonus
                    armorClass = armorClass + armor.misc_bonus
                    if armor.shield == false {
                        armorEquipped = true
                    }
                }
            }
            if armorEquipped == false {
                armorClass = 10 + self.dexBonus
            }
            
            armorClass = armorClass + self.ac_misc
            
            if self.additional_ac_mod == nil {
               self.additional_ac_mod = "" 
            }
            
            switch self.additional_ac_mod! {
            case "STR":
                armorClass += self.strBonus
            case "DEX":
                armorClass += self.dexBonus
            case "CON":
                armorClass += self.conBonus
            case "INT":
                armorClass += self.intBonus
            case "WIS":
                armorClass += self.wisBonus
            case "CHA":
                armorClass += self.chaBonus
            default: break
            }
            
            self.ac = armorClass
        } catch {
            fatalError("Failed to fetch armor: \(error)")
        }
    }
}
