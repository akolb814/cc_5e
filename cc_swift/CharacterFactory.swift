//
//  CharacterFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/10/17.
//
//

import Foundation
import CoreData

class CharacterFactory {
    
    static func getEmptyCharacter(name: String, context: NSManagedObjectContext) -> Character {
        let character = Character(context: context)
        character.name = name
        character.abilities = getAbilities()
        character.skills = getSkills()
        return character
    }
    
    static func getEmptyAbility(name: String) -> Ability {
        let ability = Ability()
        ability.name = name
        ability.score = 10
        ability.modifier = 0
        ability.save_proficiency = false
        ability.save = 0
        return ability
    }
    
    static func getAbilities() -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(getEmptyAbility(name: abilityType))
        }
        return NSSet(array: abilities)
    }
    
    static func getSkills() -> NSSet {
        var skills: [Skill] = []
        for skillType in Types.SkillsStrings {
            let skill = Skill()
            skill.name = skillType
            for skillAbilityCombo in Types.SkillToAbilityDictionary {
                if skillAbilityCombo.key == skillType {
                    skill.ability = getEmptyAbility(name: skillAbilityCombo.value)
                }
            }
            skill.expertise = false
            skill.proficiency = false
            skills.append(skill)
        }
        return NSSet(array: skills)
    }
}
