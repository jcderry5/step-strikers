//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//

import FirebaseFirestore

var messageLog: MessageLog = MessageLog();

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
        if(armorObject.checkIfSuited(potentialWearer: self)){
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

    func decreaseHealth(amtDamage: Int){
        self.currHealth -= amtDamage
        if self.currHealth < 0 {
            self.currHealth = 0
            // TODO: Add functionality for when a person dies
        }
    }

    func increaseStamina(amtIncrease: Int){
        self.currStamina += amtIncrease
        if(self.currStamina > self.maxStamina){
            self.currStamina = self.maxStamina
        }
    }

    func increaseHealth(amtIncrease: Int){
        self.currHealth += amtIncrease
        if(self.currHealth > self.maxHealth){
            self.currHealth = self.maxHealth
        }
    }
    
    // MARK: - Damage Functions
    func fight(target: inout RPGCharacter){
        let damageDealt = calculateDamage(wielderAttackModifier: self.attackModifier, wielderCurrWeapon: self.currWeapon, wielderClass: self.getCharacterClass(), target: &target)
        
        self.damageOpponent(target: target.characterName, damage: damageDealt)
        
        doConsequencesOfFight(target: &target, damageDealt: damageDealt)
        let message = "\(self.characterName) just attacked \(target.characterName) for \(damageDealt) points of damage"
        messageLog.addToMessageLog(message: message)
    }
    
    func doConsequencesOfFight(target: inout RPGCharacter, damageDealt: Int) {
        // reset attack and defense modifier after interaction
        // TODO: @Kelly, change this code to be sent to fb as a write at end of turn
        self.attackModifier = 0
        target.defenseModifier = 0
        
        // adjust the condition of the wielder's weapon and the target's armor
        target.currArmor = adjustArmorCondition(owner: &target, armorUsed: &target.currArmor)
        self.currWeapon = adjustWeaponCondition(ownerWeaponsInventory: &self.weaponsInInventory, currWeaponPointer: &self.currWeapon)
        
        // Adjust stats
        target.decreaseHealth(amtDamage: damageDealt)
        self.decreaseStamina(staminaCost: self.currWeapon.staminaCost)
    }
    
    // This function will calculate the damage that the wielder imposes on their target, given their proficiency in their currWeapon and the target's currArmor suitability.
    // proficient wielder def: The weapon is assigned to their class, they roll with the weapon's damage
    func calculateDamage(wielderAttackModifier: Int, wielderCurrWeapon: Weapon, wielderClass: String, target: inout RPGCharacter) -> Int {
        let damage: Int
        let armorClassToBeat = calculateModifiedArmorClass()
        
        // D20 + wielders attackModifer vs target's armorClass + target's defenseModifier
        if(rollDie(quant: 1, sides: 20) + wielderAttackModifier >= armorClassToBeat + target.defenseModifier) {
            // check if wielder is proficient in their weapon
            damage = calculateModifiedDamage()
        } else {
            damage = 0 // if wielder does not beat the character's AC, they do not inflict damage upon them
        }
        return damage
    }

    // Returns the amount of damage wielder imposes with their weapon taking into account their proficiency in the weapon
    func calculateModifiedDamage() -> Int{
        if(self.currWeapon.checkIfProficient(wielderClass: self.getCharacterClass())){
            return self.currWeapon.damage
        } else {
            return rollDie(quant: 1, sides: self.currWeapon.damage)
        }
    }
    
    // This function will return the modified armor class in case the wearer is ill-suited for their currArmor
    func calculateModifiedArmorClass() -> Int {
        if(self.currArmor.checkIfSuited(potentialWearer: self)){
            return self.currArmor.armorClass
        } else {
            return rollDie(quant: 1, sides: self.currArmor.armorClass)
        }
    }

    func damageOpponent(target: String, damage: Int) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentHealth = document.get("health") as! Int
                let newHealth = max(0, currentHealth - damage)
                
                Firestore.firestore().collection("players").document(target).setData(["health": newHealth], merge: true)
            }
        }
    }
}



    
