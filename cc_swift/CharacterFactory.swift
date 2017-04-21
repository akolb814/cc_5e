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
        character.name = json["name"].string
        character.alignment = json["alignment"].string
        character.armor_proficiencies = json["armor_proficiencies"].string
        character.bonds = json["bonds"].string
        character.experience = json["experience"].int32!
        character.flaws = json["flaws"].string
        character.ideals = json["ideals"].string
        character.languages = json["languages"].string
        character.notes = json["notes"].string
        character.personality_traits = json["personality_traits"].string
        character.speed_burrow = json["speed_burrow"].int32!
        character.speed_burrow_misc = json["speed_burrow_misc_bonus"].int32!
        character.speed_climb = json["speed_climb"].int32!
        character.speed_climb_misc = json["speed_climb_misc_bonus"].int32!
        character.speed_fly = json["speed_fly"].int32!
        character.speed_fly_misc = json["speed_fly_misc_bonus"].int32!
        character.speed_swim = json["speed_swim"].int32!
        character.speed_swim_misc = json["speed_swim_misc_bonus"].int32!
        character.speed_walk = json["speed_walk"].int32!
        character.speed_walk_misc = json["speed_walk_misc_bonus"].int32!
        character.speed_type = json["speed_type"].int32!
        character.tool_proficiencies = json["tool_proficiencies"].string
        character.weapon_proficiencies = json["weapon_proficiencies"].string
        character.proficiency_bonus = json["proficiency_bonus"].int32!
        character.abilities = setAbilities(character: character, json: json, context: context)
        character.race = getRace(json: json, context: context)
        
        character.current_hp = json["current_hp"].int32!
        character.current_hit_dice = json["current_hit_dice"].int32!
        
        let classes = character.mutableSetValue(forKey: "classes")
        for (index,classJSON):(String,JSON) in json["classes"] {
            print(index)
            classes.add(ClassFactory.getClass(json: classJSON, context: context))
        }
        
        let resources = character.mutableSetValue(forKey: "resources")
        for (index,resourceJSON):(String,JSON) in json["resources"] {
            resources.add(ResourceFactory.getResource(json: resourceJSON, context: context))
        }
        
        character.skills = getSkills(context: context, character: character)
        character.background = BackgroundFactory.getBackground(json: json, context: context)
        character.spellcasting = SpellcastingFactory.getSpellcasting(character: character, json: json, context: context)
        character.equipment = EquipmentFactory.getEquipment(character: character, json: json, context:context)
        
        character.calcAC()
        character.calcPP()
        character.calcInitiative()
        character.calcMaxHP()
        return character
    }
    
    static func setAbilities(character: Character, json: JSON, context: NSManagedObjectContext) -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(setAbility(name: abilityType, character: character, json: json, context: context))
        }
        return NSSet(array: abilities)
    }
    
    static func setAbility(name: String, character: Character, json: JSON, context: NSManagedObjectContext) -> Ability {
        let ability = Ability(context: context)
        ability.name = name
        ability.score = json["ability_scores"][name]["score"].int32!
        ability.save_proficiency = json["ability_scores"][name]["save_proficiency"].bool!
        ability.modifier = getBonus(ability: ability)
        ability.save = getSave(character: character, ability: ability)
        return ability
    }
    
    static func getBonus(ability: Ability) -> Int32 {
        let bonus = (ability.score/2)-5
        return bonus
    }
    
    static func getSave(character: Character, ability: Ability) -> Int32 {
        var save = ability.modifier
        let isContained = ability.save_proficiency
        
        if isContained {
            save += character.proficiency_bonus
        }
        
        return save
    }
    
    static func getAbility(character: Character, name: String, context: NSManagedObjectContext) -> Ability {
        for ability in character.abilities!.allObjects as! [Ability] {
            if ability.name == name {
                return ability
            }
        }
        return getEmptyAbility(name: "INT", character: character, context: context)
    }
    
    static func getRace(json: JSON, context: NSManagedObjectContext) -> Race {
        let race = Race(context: context)
        race.name = json["race"]["title"].string
        race.features = json["race"]["features"].string
        race.subrace = getSubrace(json: json, context: context)
        return race
    }
    
    static func getSubrace(json: JSON, context: NSManagedObjectContext) -> Subrace {
        let subrace = Subrace(context: context)
        subrace.name = json["race"]["subrace"].string
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
        character.abilities = getEmptyAbilities(character: character, context: context)
        character.skills = getSkills(context: context, character: character)
        character.race = getDefaultRace(context: context)
        
        let classes = character.mutableSetValue(forKey: "classes")
        classes.add(ClassFactory.getDefaultClass(context: context))
        
        character.background = BackgroundFactory.getDefaultBackground(context: context)
        character.spellcasting = SpellcastingFactory.getEmptySpellcasting(character: character, context: context)
        character.equipment = EquipmentFactory.getEmptyEquipment(character: character, context:context)
        
        let resources = character.mutableSetValue(forKey: "resources")
        resources.add(ResourceFactory.getEmptyResource(context: context))
        
        character.calcAC()
        character.calcPP()
        character.calcInitiative()
        return character
    }
    
    static func getEmptyAbilities(character: Character, context: NSManagedObjectContext) -> NSSet {
        var abilities: [Ability] = []
        for abilityType in Types.AbilitiesStrings {
            abilities.append(getEmptyAbility(name: abilityType, character: character, context: context))
        }
        return NSSet(array: abilities)
    }
    
    static func getEmptyAbility(name: String, character: Character, context: NSManagedObjectContext) -> Ability {
        let ability = Ability(context: context)
        ability.name = name
        ability.score = 10
        ability.modifier = getBonus(ability: ability)
        ability.save_proficiency = false
        ability.save = getSave(character: character, ability: ability)
        return ability
    }
    
    static func getDefaultRace(context: NSManagedObjectContext) -> Race {
        let race = Race(context: context)
        race.name = "Human"
        return race
    }
}
