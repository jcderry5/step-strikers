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
<<<<<<< HEAD
=======
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
>>>>>>> Made all armor and weapons
    
    // Rolling modifiers
    var attackModifier = 0
    var defenseModifier = 0
    var magicResistanceModifier = 0
    
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
<<<<<<< HEAD
        
=======
        
        // Initialize Starter Inventory
>>>>>>> Made all armor and weapons
        self.weaponsInInventory = [fistsWeapon]
        self.currWeapon = fistsWeapon
        self.armorInInventory = [noArmorArmor]
        self.currArmor = noArmorArmor
<<<<<<< HEAD
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
<<<<<<< HEAD
=======
=======
>>>>>>> Made all armor and weapons
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
>>>>>>> Create protocols (#3)
=======
>>>>>>> Changing RPGCharacter and Caster to classes and subclasses instead of protocols
    }
}


class Fighter: RPGCharacter {
    
    
    var description: String {
        return ("Character Name: \(characterName)\nUser Name: \(userName)\nCurrent Health: \(currHealth)\nCurrent Stamina: \(currStamina)")
    }
    
<<<<<<< HEAD
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
    
=======
>>>>>>> Add gitignore file (#6)
}

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Create protocols (#3)
=======
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
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
=======
>>>>>>> Changing RPGCharacter and Caster to classes and subclasses instead of protocols
