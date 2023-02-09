//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//

<<<<<<< HEAD

import Foundation


class RPGCharacter {
=======

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
>>>>>>> Create protocols (#3)
    var characterName: String
    var userName: String
    
    // Character Stats Variables
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    
    // Inventory Variables
    var weaponsInInventory: [Weapon]
    var currWeapon: Weapon
    var armorInInventory: [Armor]
    var currArmor: Armor
    
    // Rolling modifiers
    var attackModifier = 0
    var defenseModifier = 0
    var magicResistanceModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
<<<<<<< HEAD
        
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
    
    // Universal Functions
    func wield(weaponObject: Weapon){
        if(weaponObject.checkIfProficient(wearer: self)){
            self.currWeapon = weaponObject
        } else {
            print("\(self.characterName) is not proficient with \(weaponObject.name).\n They will use this weapon at a disadvantage")
            self.currWeapon = weaponObject
        }
    }

    func wear(armorObject: Armor){
        if(armorObject.checkIfSuited(potentialWearer: self)){
            self.currArmor = armorObject
        } else {
            print("\(armorObject.name) is not properly suited for \(self.characterName). Their armor class will be at a disadvantage")
        }
    }

    func fight(target: inout RPGCharacter){
        
        let damageDealt = calculateDamage(wielder: self, target: target, damage: self.currWeapon.damage)
        
        decreaseHealth(amtDamage: damageDealt)

        decreaseStamina()
    }

    func decreaseStamina(){
        self.currStamina -= self.currWeapon.staminaCost
        // TODO: Do something when exhausted
    }

    func decreaseHealth(amtDamage: Int){
        self.currHealth -= amtDamage
        // TODO: Do something when dead
    }

    func increaseStamina(amtIncrease: Int){
        self.currStamina += amtIncrease
        if(amtIncrease > self.maxStamina){
            self.currStamina = self.maxStamina
        }
    }

    func increaseHealth(amtIncrease: Int){
        self.currHealth += amtIncrease
        if(amtIncrease > self.maxHealth){
            self.currHealth = self.maxHealth
        }
    }
}


class Caster: RPGCharacter {
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    // Rolling modifier
    var spellModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, spellPoints: Int) {
        self.currSpellPoints = spellPoints
        self.maxSpellPoints = spellPoints
        super.init(characterName: characterName, userName: userName, health: health,
                   stamina: stamina)
    }
    
    func increaseSpellPoints(amtIncrease: Int){
        self.currSpellPoints += amtIncrease
        if(self.currSpellPoints > maxSpellPoints){
            self.currSpellPoints = maxSpellPoints
        }
    }
    
    func decreaseSpellPoints(amtDecrease: Int){
        self.currSpellPoints -= amtDecrease
        
        // TODO: Do something when out of spell points
=======
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
>>>>>>> Create protocols (#3)
    }
}


class Fighter: RPGCharacter {
    
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
    
    override init(characterName: String, userName: String, health: Int,
              stamina: Int){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina)
    }
}

<<<<<<< HEAD

class Wizard: Caster {
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)\nCurrent Spellpoints: \(currSpellPoints)")
    }
    
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints)
    }
    
}

class Bard: Caster {
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)\nCurrent Spellpoints: \(currSpellPoints)")
    }
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints)
    }
}

class Rogue: RPGCharacter {
    
    override init(characterName: String, userName: String, health: Int, stamina: Int) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina)
    }
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
    
}

=======
>>>>>>> Create protocols (#3)
