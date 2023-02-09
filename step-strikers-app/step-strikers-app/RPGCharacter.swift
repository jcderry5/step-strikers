//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//


import Foundation


protocol RPGCharacter: CustomStringConvertible {
    var characterName: String { get set}
    var userName: String { get set}
    var maxHealth: Int { get set}
    var currHealth: Int { get set}
    var maxStamina: Int { get set}
    var currStamina: Int { get set}
    
    init(characterName: String, userName: String, health: Int,
            stamina: Int)
}


protocol Caster {
    var characterName: String { get set}
    var userName: String { get set}
    var maxHealth: Int { get set}
    var currHealth: Int { get set}
    var maxStamina: Int { get set}
    var currStamina: Int { get set}
    var currSpellPoints: Int { get set}
    var maxSpellPoints: Int { get set}
    
    init(characterName: String, userName: String, health: Int,
                stamina: Int, spellPoints: Int)
}


class Fighter: RPGCharacter {
    var characterName: String
    
    var userName: String
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
    
    required init(characterName: String, userName: String, health: Int,
              stamina: Int){
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
    }
}


class Wizard: Caster {
    
    var characterName: String
    var userName: String
    
    var maxHealth: Int
    var currHealth: Int
    
    var maxStamina: Int
    var currStamina: Int
    
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)\nCurrent Spellpoints: \(currSpellPoints)")
    }
    
    required init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.maxSpellPoints = spellPoints
        self.currSpellPoints = spellPoints
    }
    
}


class Bard: Caster {
    var characterName: String
    var userName: String
    
    var maxHealth: Int
    var currHealth: Int
    
    var maxStamina: Int
    var currStamina: Int
    
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)\nCurrent Spellpoints: \(currSpellPoints)")
    }
    
    required init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.maxSpellPoints = spellPoints
        self.currSpellPoints = spellPoints
    }
}


class Rogue: RPGCharacter {
    var characterName: String
    var userName: String
    
    var maxHealth: Int
    var currHealth: Int
    
    var maxStamina: Int
    var currStamina: Int
    
    required init(characterName: String, userName: String, health: Int, stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
    }
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
    
}

