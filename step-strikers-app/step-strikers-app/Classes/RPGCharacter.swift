//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//

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
    var itemsInInventory: [Item]
    
    // Rolling modifiers
    var attackModifier = 0
    var defenseModifier = 0
    var magicResistanceModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]){
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        
        // Initialize Starter Inventory
        self.weaponsInInventory = weaponsInInventory
        self.currWeapon = currWeapon
        self.armorInInventory = armorInInventory
        self.currArmor = currArmor
        self.itemsInInventory = itemsInInventory
        print(self is Fighter)
    }
    
    // Returns a string of the class of the current character
    func getCharacterClass() -> String {
        switch self {
        case is Fighter:
            return "Fighter"
        case is Wizard:
            return "Wizard"
        case is Bard:
            return "Bard"
        case is Rogue:
            return "Rogue"
        default:
            return "Does not have a class?"
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
        if self.currStamina < 0 {
            self.currStamina = 0
        }
    }

    func decreaseHealth(amtDamage: Int){
        self.currHealth -= amtDamage
        if self.currHealth < 0 {
            self.currHealth = 0
            // TODO: Add functionality for when a person dies
        }
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
         stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        self.currSpellPoints = spellPoints
        self.maxSpellPoints = spellPoints
        super.init(characterName: characterName, userName: userName, health: health,
                   stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
    
    func increaseSpellPoints(amtIncrease: Int){
        self.currSpellPoints += amtIncrease
        if(self.currSpellPoints > maxSpellPoints){
            self.currSpellPoints = maxSpellPoints
        }
    }
    
    func decreaseSpellPoints(amtDecrease: Int){
        self.currSpellPoints -= amtDecrease
    }
}
    
class Fighter: RPGCharacter {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}

class Wizard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}


class Bard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}


class Rogue: RPGCharacter {
    override init(characterName: String, userName: String, health: Int, stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}
