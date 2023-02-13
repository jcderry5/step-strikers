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
    
    // Character Stats Variables
    var maxHealth: Int { get set}
    var currHealth: Int { get set}
    var maxStamina: Int { get set}
    var currStamina: Int { get set}
    
    // Inventory Variables
    var weaponsInInventory: [Weapon] { get set }
    var currWeapon: Weapon { get set }
    var armorInInventory: [Armor] {get set}
    var currArmor: Armor {get set}
    
    init(characterName: String, userName: String, health: Int,
            stamina: Int)
}


protocol Caster: RPGCharacter {
    var characterName: String { get set}
    var userName: String { get set}
    var maxHealth: Int { get set}
    var currHealth: Int { get set}
    var maxStamina: Int { get set}
    var currStamina: Int { get set}
    var currSpellPoints: Int { get set}
    var maxSpellPoints: Int { get set}
    var weaponsInInventory: [Weapon] { get set }
    var currWeapon: Weapon { get set }
    
    init(characterName: String, userName: String, health: Int,
                stamina: Int, spellPoints: Int)
}


class Fighter: RPGCharacter {
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
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
}


class Wizard: Caster {
    
    var characterName: String
    var userName: String
    
    // Character Stats Variables
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    // Inventory Variables
    var weaponsInInventory: [Weapon]
    var currWeapon: Weapon
    var armorInInventory: [Armor]
    var currArmor: Armor
    
    
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
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
    
    // DO NOT USE. This is initializer for RPGCharacter. Necessary to run.
    required init(characterName: String, userName: String, health: Int, stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.maxSpellPoints = -1
        self.currSpellPoints = -1
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
    
}


class Bard: Caster {
    var characterName: String
    var userName: String
    
    // Character Stats Variables
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    // Inventory Variables
    var weaponsInInventory: [Weapon]
    var currWeapon: Weapon
    var armorInInventory: [Armor]
    var currArmor: Armor
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)\nCurrent Spellpoints: \(currSpellPoints)")
    }
    
    required init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int) {
        self.characterName = characterName
        self.userName = userName
        
        // Initialize Starter Character Stats
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.maxSpellPoints = spellPoints
        self.currSpellPoints = spellPoints
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
    
    // DO NOT USE. This is initializer for RPGCharacter. Necessary to run.
    required init(characterName: String, userName: String, health: Int, stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.maxSpellPoints = -1
        self.currSpellPoints = -1
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
    }
}


class Rogue: RPGCharacter {
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
    
    required init(characterName: String, userName: String, health: Int, stamina: Int) {
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        
        // Initialize Starter Inventory
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
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

func fight(fighter: RPGCharacter, target: inout RPGCharacter){
    
    let damageDealt = calculateDamage(wielder: fighter, target: target, damage: fighter.currWeapon.damage)
    takeDamage(recepient: &target, amtDamage: damageDealt)
    
    // TODO: Change the stamina of fighter dependent on their currWeapon
}

func takeDamage(recepient: inout RPGCharacter, amtDamage: Int){
    recepient.currHealth -= amtDamage
}
