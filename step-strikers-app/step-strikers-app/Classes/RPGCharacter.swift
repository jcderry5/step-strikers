//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//

import FirebaseFirestore

var messageLog: MessageLog = MessageLog();

let maxHealthPerClass = [
    (characterClass: "Fighter", maxHealth: 45),
    (characterClass: "Rogue", maxHealth: 40),
    (characterClass: "Bard", maxHealth: 30),
    (characterClass: "Wizard", maxHealth: 35)
]

let maxStaminaPerClass = [
    (characterClass: "Fighter", maxStamina: 50),
    (characterClass: "Rogue", maxStamina: 55),
    (characterClass: "Bard", maxStamina: 35),
    (characterClass: "Wizard", maxStamina: 30)
]

let maxSpellPointsPerClass = [
    (characterClass: "Bard", maxSpellPoints: 30),
    (characterClass: "Wizard", maxSpellPoints: 40),
    (characterClass: "Fighter", maxSpellPoints: 0),
    (characterClass: "Rogue", maxSpellPoints: 0)
]

class RPGCharacter {
    var characterName: String
    var userName: String
    
    // Character Stats Variables
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    
    // Dead, Asleep, Blind, Invisible
    var isDead: Bool
    var isAsleep: Bool
    var isBlind: Bool
    var isInvisible: Bool
    
    // Inventory Variables
    var weaponsInInventory: [Weapon]
    var currWeapon: Weapon
    var armorInInventory: [Armor]
    var currArmor: Armor
    var itemsInInventory: [Item]
    var inventoryQuantities: [String:Int]
    
    // Rolling modifiers
    var attackModifier = 0
    var defenseModifier = 0
    var magicResistanceModifier = 0
    var hasAdvantage: Bool = false
    var hasDisadvantage: Bool = false
    
    // Settings Variables
    var darkMode = false
    var blood = true
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, dead: Bool, asleep: Bool, blind: Bool, invisible: Bool, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]){
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        self.isDead = dead
        self.isAsleep = asleep
        self.isBlind = blind
        self.isInvisible = invisible
        
        // Initialize Starter Inventory
        self.weaponsInInventory = weaponsInInventory
        self.currWeapon = currWeapon
        self.armorInInventory = armorInInventory
        self.currArmor = currArmor
        self.itemsInInventory = itemsInInventory
        self.inventoryQuantities = inventoryQuantities
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
    
    func printLocalCharacterDetailsToConsole(){
        print("Character Name: \(localCharacter.characterName)")
        print("Character Name: \(localCharacter.userName)")
        
        // Character Stats Variables
        print("Curr Health: \(localCharacter.currHealth)")
        print("Curr Stamina: \(localCharacter.currStamina)")
        
        // Inventory Variables
        print("Weapon Inventory Count: \(localCharacter.weaponsInInventory.count)")
        print("Curr Weapon: \(localCharacter.currWeapon.name)")
        print("Armor Inventory Count: \(localCharacter.armorInInventory.count)")
        print("CurrArmor: \(localCharacter.currArmor.name)")
        print("Item Inventory Count: \(localCharacter.itemsInInventory.count)")
        
        // Rolling modifiers
        print("Attack Modifier: \(localCharacter.attackModifier)")
        print("Defense Modifer: \(localCharacter.defenseModifier)")
        print("Magic Resistance Modifier: \(localCharacter.magicResistanceModifier)")
    }
    
    // Universal Functions
    
    // MARK: - Weapon Functions
    func wield(weaponObject: Weapon){
        if (self.checkInventory(weaponName: weaponObject.name)) {
            if(weaponObject.checkIfProficient(wielderClass: self.getCharacterClass())){
                self.currWeapon = weaponObject
            } else {
                print("\(self.characterName) is not proficient with \(weaponObject.name).\n They will use this weapon at a disadvantage")
                self.currWeapon = weaponObject
            }
        } else {
            print ("You cannot wield this weapon. It is not in your inventory")
            return
        }
        let message = "\(self.characterName) is now wielding \(weaponObject.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    // Add weapon to inventory
    func addToInventory(weaponObject: Weapon) {
        self.weaponsInInventory += [weaponObject]
    }
    
    // Returns true is self contains a weapon with that name
    func checkInventory(weaponName: String) -> Bool{
        return self.weaponsInInventory.contains(where: { weapon in weapon.name == weaponName })
    }
    
    // Returns true is self contains a weapon with that name and useCount
    func checkInventory(weaponObject: Weapon) -> Bool{
        return self.weaponsInInventory.contains(where: { weapon in weapon.name == weaponObject.name && weapon.useCount == weaponObject.useCount })
    }
    
    // Returns true if weaponObject was in inventory
    func removeFromInventory(weaponObject: Weapon) -> Bool {
        if checkInventory(weaponObject: weaponObject) {
            self.weaponsInInventory.removeAll { weapon in
                weapon.name == weaponObject.name && weapon.useCount == weaponObject.useCount }
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Armor Functions
    func wear(armorObject: Armor){
        if(armorObject.checkIfSuited(wearerCharacterType: self.getCharacterClass())){
            self.currArmor = armorObject
        } else {
            print("\(armorObject.name) is not properly suited for \(self.characterName). Their armor class will be at a disadvantage")
            self.currArmor = armorObject
        }
        let message = "\(self.characterName) is now wearing \(armorObject.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    // Add Armor to inventory
    func addToInventory(armorObject: Armor) {
        self.armorInInventory += [armorObject]
    }
    
    // Returns true is self contains a weapon with that name
    func checkInventory(armorName: String) -> Bool{
        return self.armorInInventory.contains(where: { armor in armor.name == armorName })
    }
    
    // Returns true is self contains a weapon with that name and useCount
    func checkInventory(armorObject: Armor) -> Bool{
        return self.armorInInventory.contains(where: { armor in armor.name == armorObject.name && armor.useCount == armorObject.useCount })
    }
    
    // Returns true if weaponObject was in inventory
    func removeFromInventory(armorObject: Armor) -> Bool {
        if checkInventory(armorObject: armorObject) {
            self.armorInInventory.removeAll { armor in
                armor.name == armorObject.name && armor.useCount == armorObject.useCount }
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Item Functions
    // Add item to inventory
    func addToInventory(itemObject: Item) {
        if(itemObject.owner.characterName == self.characterName) {
            self.itemsInInventory += [itemObject]
        } else {
            print("Cannot add \(itemObject.name) to the inventory of \(self.characterName). It is owned by \(itemObject.owner)")
        }
    }
    
    // Returns true is self contains a item with that name
    func checkInventory(itemName: String) -> Bool{
        return self.itemsInInventory.contains(where: { item in item.name == itemName })
    }
    
    // Returns true is self contains a item with that name
    func checkInventory(itemObject: Item) -> Bool{
        return self.itemsInInventory.contains(where: { item in item.name == itemObject.name })
    }
    
    // Returns true if weaponObject was in inventory
    func removeFromInventory(itemObject: Item) -> Bool {
        if checkInventory(itemObject: itemObject), let indexToRemove: Int = self.itemsInInventory.firstIndex(where: {item in item.name == itemObject.name}) {
            self.itemsInInventory.remove(at: indexToRemove)
            return true
        } else {
            return false
        }
    }

    // MARK: - Stat Modification Functions
    
    func decreaseStamina(staminaCost: Int){
        self.currStamina -= staminaCost
        
        // TODO: Do something when exhausted
        if self.currStamina < 0 {
            self.currStamina = 0
        }
    }
    
    func increaseStamina(amtIncrease: Int){
        self.currStamina += amtIncrease
        
        self.currStamina = min(self.currStamina, self.maxStamina)
    }

    func decreaseHealth(amtDamage: Int){
        self.currHealth -= amtDamage
        if self.currHealth < 0 {
            self.currHealth = 0
            print("Warning!!! You just decreased the current player past zero. How did that happen???")
        }
    }
    
    func increaseHealth(amtIncrease: Int){
        self.currHealth += amtIncrease
        if(self.currHealth > self.maxHealth){
            self.currHealth = self.maxHealth
        }
    }
    
    // MARK: - Damage Functions
    func fight(rollValue: Int){
        let damageDealt: Int
        if (self.didAttackHit(rollValue: rollValue)) {
            damageDealt =  calculateModifiedDamage()
        } else {
            damageDealt = 0
        }
        
        doConsequencesOfFight(damageDealt: damageDealt)
        
        let message = "\(self.characterName) just attacked \(currTarget.name) for \(damageDealt) points of damage"
        messageLog.addToMessageLog(message: message)
    }
    
    func didAttackHit(rollValue: Int) -> Bool {
        return rollValue + attackModifier >= currTarget.modifiedArmorClass + currTarget.defenseModifier
    }
    
    func doConsequencesOfFight(damageDealt: Int) {
        // reset attack and defense modifier after interaction
        self.attackModifier = 0
        currTarget.defenseModifier = 0
        
        // adjust the condition of the wielder's weapon and the target's armor
        currTarget.armor = adjustArmorCondition(armorUsed: &currTarget.armor)
        self.currWeapon = adjustWeaponCondition(ownerWeaponsInventory: &self.weaponsInInventory, currWeaponPointer: &self.currWeapon)
        
        // Adjust stats
        decreaseTargetHealth(amtDamage: damageDealt)
        self.decreaseStamina(staminaCost: self.currWeapon.staminaCost)
    }

    // Returns the amount of damage wielder imposes with their weapon taking into account their proficiency in the weapon
    func calculateModifiedDamage() -> Int{
        if(self.currWeapon.checkIfProficient(wielderClass: self.getCharacterClass())){
            return self.currWeapon.damage
        } else {
            let returnValue = rollDie(sides: self.currWeapon.damage, withAdvantage: localCharacter.hasAdvantage, withDisadvantage: localCharacter.hasDisadvantage)
            // Replace advantage and disadvantage back to false
            localCharacter.hasAdvantage = false
            localCharacter.hasDisadvantage = false
            return returnValue
        }
    }
}

func increaseTargetHealth(amtHealed: Int) {
    currTarget.health += amtHealed
    let maxHealth = getMaxHealth(characterClass: currTarget.character_class)
    currTarget.health = min(maxHealth, currTarget.health)
}

func decreaseTargetHealth(amtDamage: Int){
    currTarget.health -= amtDamage
    print("DEBUG: \(currTarget.userName)'s health is was \(currTarget.health + amtDamage) and is now \(currTarget.health)")
    if currTarget.health < 0 {
        currTarget.health = 0
        currTarget.isDead = true
        let message = "\(localCharacter.characterName) has just killed \(currTarget.name)!"
        messageLog.addToMessageLog(message: message)
    }
}

func increaseTargetSpellPoints(amtIncrease: Int){
    guard currTarget.character_class == "Caster" else {
        print("ERROR: Trying to increase spell points of non-caster")
        return
    }
    
    currTarget.spellPoints += amtIncrease
    currTarget.spellPoints = min(currTarget.spellPoints, getMaxSpellPoints(characterClass: currTarget.character_class))
}

func increaseTargetStamina(amtIncrease: Int) {
    currTarget.currStamina += amtIncrease
    currTarget.currStamina = min(currTarget.currStamina, getMaxStamina(characterClass: currTarget.character_class))
}

func getMaxHealth(characterClass: String) -> Int {
    switch characterClass {
    case maxHealthPerClass[0].characterClass:
        return maxHealthPerClass[0].maxHealth
    case maxHealthPerClass[1].characterClass:
        return maxHealthPerClass[1].maxHealth
    case maxHealthPerClass[2].characterClass:
        return maxHealthPerClass[2].maxHealth
    case maxHealthPerClass[3].characterClass:
        return maxHealthPerClass[3].maxHealth
    default:
        print("Asking for the max health of a class that doesn't exist")
        return 30
    }
}

func getMaxStamina(characterClass: String) -> Int {
    switch characterClass {
    case maxStaminaPerClass[0].characterClass:
        return maxStaminaPerClass[0].maxStamina
    case maxStaminaPerClass[1].characterClass:
        return maxStaminaPerClass[1].maxStamina
    case maxStaminaPerClass[2].characterClass:
        return maxStaminaPerClass[2].maxStamina
    case maxStaminaPerClass[3].characterClass:
        return maxStaminaPerClass[3].maxStamina
    default:
        print("Asking for the max stamina of a class that doesn't exist")
        return 30
    }
}

func getMaxSpellPoints(characterClass: String) -> Int {
    switch characterClass {
    case maxSpellPointsPerClass[0].characterClass:
        return maxSpellPointsPerClass[0].maxSpellPoints
    case maxSpellPointsPerClass[1].characterClass:
        return maxSpellPointsPerClass[2].maxSpellPoints
    default:
        print("Asking for the max health of a class that doesn't exist")
        return 30
    }
}
