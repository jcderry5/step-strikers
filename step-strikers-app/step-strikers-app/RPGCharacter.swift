//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//


import Foundation


class RPGCharacter {
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
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
}


class Caster: RPGCharacter {
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    override init(characterName: String, userName: String, health: Int,
         stamina: Int, spellPoints: Int) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina)
        self.currSpellPoints = spellPoints
        self.maxSpellPoints = spellPoints
        
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

// Universal Functions

func wield(weaponObject: Weapon, wielder: inout RPGCharacter){
    if(weaponObject.checkIfProficient(wearer: wielder)){
        wielder.currWeapon = weaponObject
    } else {
        print("\(wielder.characterName) is not proficient with \(weaponObject.name).\n They will use this weapon at a disadvantage")
        wielder.currWeapon = weaponObject
    }
}

func wear(armorObject: Armor, wearer: inout RPGCharacter){
    if(armorObject.checkIfSuited(potentialWearer: wearer)){
        wearer.currArmor = armorObject
    } else {
        print("\(armorObject.name) is not properly suited for \(wearer.characterName). Their armor class will be at a disadvantage")
    }
}

func fight(fighter: inout RPGCharacter, target: inout RPGCharacter){
    
    let damageDealt = calculateDamage(wielder: fighter, target: target, damage: fighter.currWeapon.damage)
    
    takeDamage(recepient: &target, amtDamage: damageDealt)

    modifyStamina(player: &fighter)
}

func modifyStamina(player: inout RPGCharacter){
    player.currStamina -= player.currWeapon.staminaCost
}

func takeDamage(recepient: inout RPGCharacter, amtDamage: Int){
    recepient.currHealth -= amtDamage
}
