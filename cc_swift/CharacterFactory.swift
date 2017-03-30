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
        character.abilities = getAbilities(context: context)
        character.skills = getSkills(context: context, character: character)
        character.race = getDefaultRace(context: context)
        let classes = character.mutableSetValue(forKey: "classes")
        classes.add(ClassFactory.getDefaultClass(context: context))
        character.background = BackgroundFactory.getDefaultBackground(context: context)
        character.spellcasting = SpellcastingFactory.getEmptySpellcasting(context: context)
        return character
    }
    
    static func getEmptyAbility(name: String, context: NSManagedObjectContext) -> Ability {
        let ability = Ability(context: context)
        ability.name = name
        ability.score = 10
        ability.modifier = 0
        ability.save_proficiency = false
        ability.save = 0
        return ability
    }
    
    static func getAbilities(context: NSManagedObjectContext) -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(getEmptyAbility(name: abilityType, context: context))
        }
        return NSSet(array: abilities)
    }
    
    static func getSkills(context: NSManagedObjectContext, character: Character) -> NSSet {
        var skills: [Skill] = []
        for skillType in Types.SkillsStrings {
            let skill = Skill(context: context)
            skill.name = skillType
            for skillAbilityCombo in Types.SkillToAbilityDictionary {
                if skillAbilityCombo.key == skillType {
                    skill.ability = character.getAbility(name: skillAbilityCombo.value)
                }
            }
            skill.expertise = false
            skill.proficiency = false
            skills.append(skill)
        }
        return NSSet(array: skills)
    }
    
    static func getDefaultRace(context: NSManagedObjectContext) -> Race {
        var race = Race(context: context)
        race.name = "Human"
        return race
    }
    
}
