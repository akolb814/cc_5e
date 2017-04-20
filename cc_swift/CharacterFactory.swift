//
//  CharacterFactory.swift
//  cc_swift
//
//  Created by Rip Britton on 3/10/17.
//
//

import Foundation
import CoreData
import SwiftyJSON

class CharacterFactory {
    
    static func getCharacter(json: JSON, context: NSManagedObjectContext) -> Character {
        let character = Character(context: context)
        character.name = ""
        character.alignment = ""
        character.armor_proficiencies = ""
        character.bonds = ""
        character.experience = 0
        character.flaws = ""
        character.ideals = ""
        character.languages = ""
        character.notes = ""
        character.personality_traits = ""
        character.speed_burrow = 0
        character.speed_burrow_misc = 0
        character.speed_climb = 0
        character.speed_climb_misc = 0
        character.speed_fly = 0
        character.speed_fly_misc = 0
        character.speed_swim = 0
        character.speed_swim_misc = 0
        character.speed_walk = 0
        character.speed_walk_misc = 0
        character.speed_type = 0
        character.tool_proficiencies = ""
        character.weapon_proficiencies = ""
        character.proficiency_bonus = 2
        character.abilities = getAbilities(json: json, context: context)
        character.race = getRace(json: json, context: context)
        
        let classes = character.mutableSetValue(forKey: "classes")
        for (index,classJSON):(String,JSON) in json["classes"] {
            print(index)
            classes.add(ClassFactory.getClass(json: classJSON, context: context))
        }
        
        let resources = character.mutableSetValue(forKey: "resources")
        for resourceJSON in json["resources"] {
            resources.add(ResourceFactory.getResource(json: json, context: context))
        }
        
        character.skills = getSkills(context: context, character: character)
        character.background = BackgroundFactory.getBackground(json: json, context: context)
        character.spellcasting = SpellcastingFactory.getSpellcasting(json: json, context: context)
        character.equipment = EquipmentFactory.getEquipment(json: json, context:context)
        
        character.calcAC()
        character.calcPP()
        character.calcInitiative()
        return character
    }
    
    static func getAbilities(json: JSON, context: NSManagedObjectContext) -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(getAbility(name: abilityType, json: json, context: context))
        }
        return NSSet(array: abilities)
    }
    
    static func getAbility(name: String, json: JSON, context: NSManagedObjectContext) -> Ability {
        let ability = Ability(context: context)
        ability.name = name
        ability.score = json[name]["score"].int32!
        ability.save_proficiency = json[name]["save_proficiency"].bool!
        ability.modifier = getBonus(ability: ability)
        ability.save = getSave(ability: ability)
        return ability
    }
    
    static func getBonus(ability: Ability) -> Int32 {
        let bonus = (ability.score/2)-5
        return bonus
    }
    
    static func getSave(ability: Ability) -> Int32 {
        var save = ability.modifier
        let isContained = ability.save_proficiency
        
        if isContained {
            save += Character.Selected.proficiency_bonus
        }
        
        return save
    }
    
    static func getRace(json: JSON, context: NSManagedObjectContext) -> Race {
        let race = Race(context: context)
        race.name = json["race"]["name"].string
        race.features = json["race"]["features"].string
        race.subrace = getSubrace(json: json, context: context)
        return race
    }
    
    static func getSubrace(json: JSON, context: NSManagedObjectContext) -> Subrace {
        let subrace = Subrace(context: context)
        subrace.name = json["race"]["subrace"]["name"].string
        return subrace
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
    
    static func getEmptyCharacter(name: String, context: NSManagedObjectContext) -> Character {
        let character = Character(context: context)
        character.name = name
        character.alignment = ""
        character.armor_proficiencies = ""
        character.bonds = ""
        character.experience = 0
        character.flaws = ""
        character.ideals = ""
        character.languages = ""
        character.notes = ""
        character.personality_traits = ""
        character.speed_burrow = 0
        character.speed_burrow_misc = 0
        character.speed_climb = 0
        character.speed_climb_misc = 0
        character.speed_fly = 0
        character.speed_fly_misc = 0
        character.speed_swim = 0
        character.speed_swim_misc = 0
        character.speed_walk = 0
        character.speed_walk_misc = 0
        character.speed_type = 0
        character.tool_proficiencies = ""
        character.weapon_proficiencies = ""
        character.proficiency_bonus = 2
        character.abilities = getEmptyAbilities(context: context)
        character.skills = getSkills(context: context, character: character)
        character.race = getDefaultRace(context: context)
        
        let classes = character.mutableSetValue(forKey: "classes")
        classes.add(ClassFactory.getDefaultClass(context: context))
        
        character.background = BackgroundFactory.getDefaultBackground(context: context)
        character.spellcasting = SpellcastingFactory.getEmptySpellcasting(context: context)
        character.equipment = EquipmentFactory.getEmptyEquipment(context:context)
        
        let resources = character.mutableSetValue(forKey: "resources")
        resources.add(ResourceFactory.getEmptyResource(context: context))
        
        character.calcAC()
        character.calcPP()
        character.calcInitiative()
        return character
    }
    
    static func getEmptyAbilities(context: NSManagedObjectContext) -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(getEmptyAbility(name: abilityType, context: context))
        }
        return NSSet(array: abilities)
    }
    
    static func getEmptyAbility(name: String, context: NSManagedObjectContext) -> Ability {
        let ability = Ability(context: context)
        ability.name = name
        ability.score = 10
        ability.modifier = getBonus(ability: ability)
        ability.save_proficiency = false
        ability.save = getSave(ability: ability)
        return ability
    }
    
    static func getDefaultRace(context: NSManagedObjectContext) -> Race {
        let race = Race(context: context)
        race.name = "Human"
        return race
    }
}
