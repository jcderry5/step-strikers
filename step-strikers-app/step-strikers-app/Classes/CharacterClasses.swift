//
//  CharacterClasses.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/25/23.
//

// These are for front-end, do not need to write to firebase

let FighterActions: [(actionName: String, cost: String)] = [
    (actionName: "Fight", cost: "?? STA"), // TODO: Ask Kelly if displaying the cost is feasible
    (actionName: "Second Wind", cost: "08 STA"),
    (actionName: "Action Surge", cost: "10 STA"),
    (actionName: "Sharpen Weapon", cost: "07S TA")
]

let RogueActions: [(actionName: String, cost: String)] = [
    (actionName: "Fight", cost: "?? STA"),
    (actionName: "Uncanny Dodge", cost: "05 STA"),
    (actionName: "Hone Skill", cost: "03 STA"),
    (actionName: "Insight", cost: "06 STA"),
    (actionName: "Allsight", cost: "12 STA")
]

let WizardActions: [(actionName: String, cost: String)] = [
    (actionName: "Fight", cost: "?? STA"),
    (actionName: "Frost Bite", cost: "03 MAG"),
    (actionName: "Mage Hand", cost: "20 MAG"),
    (actionName: "Shield", cost: "04 MAG"),
    (actionName: "Sleep", cost: "12 MAG"),
    (actionName: "Animate the Dead", cost: "17 MAG"),
    (actionName: "Heal", cost: "05 MAG")
]

let BardActions: [(actionName: String, cost: String)] = [
    (actionName: "Fight", cost: "?? STA"),
    (actionName: "Mage Hand", cost: "20 MAG"),
    (actionName: "Bardic Inspiration", cost: "07 MAG"),
    (actionName: "Vicious Mockery", cost: "07 MAG"),
    (actionName: "Blindness", cost: "08 MAG"),
    (actionName: "Invisibility", cost: "10 MAG"),
    (actionName: "Motivational Speech", cost: "12 MAG")
]

class Fighter: RPGCharacter {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    // Second wind will give Fighter 10HP but cost 8 stamina
    func secondWind() {
        self.increaseHealth(amtIncrease: 10)
        self.decreaseStamina(staminaCost: 8)
        
        let message = "\(self.characterName) has gotten a second wind"
        messageLog.addToMessageLog(message: message)
    }
    
    // Action surge will give you double damage on your attack if you pass the check
    func actionSurge(rollValue: Int, rollValueToBeat: Int) {
        let damageDealt = self.calculateDamage(wielderAttackModifier: self.attackModifier, wielderCurrWeapon: self.currWeapon, wielderClass: self.getCharacterClass(), rollValue: rollValue, rollValueToBeat: rollValueToBeat) * 2
        
        self.doConsequencesOfFight(damageDealt: damageDealt)
        self.decreaseStamina(staminaCost: 10)
        
        let message = "\(self.characterName) has action surged to do double damage against \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }

    // Sharpen weapon will add 3 to your attack modifier for a cost of 7 stamina
    func sharpenWeapon() {
        self.attackModifier += 3
        self.decreaseStamina(staminaCost: 7)
        
        let message = "\(self.characterName) is sharpening their weapon"
        messageLog.addToMessageLog(message: message)
    }
}

class Wizard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
}


class Bard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
}


class Rogue: RPGCharacter {
    override init(characterName: String, userName: String, health: Int, stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    // Uncanny dodge will add three to your defense modifier but costs 5 stamina
    func uncannyDodge() {
        self.defenseModifier += 3
        self.decreaseStamina(staminaCost: 5)
        
        let message = "\(self.characterName) is utilizing their uncanny dodge ability"
        messageLog.addToMessageLog(message: message)
    }
    
    // Hone Skill will add 5 to the attack modifier but it cost 3 stamina
    func honeSkill() {
        self.attackModifier += 5
        self.decreaseStamina(staminaCost: 3)
        
        let message = "\(self.characterName) is honing their skill"
        messageLog.addToMessageLog(message: message)
    }
    
    // Insight allows user to know the stats of one player, stamina cost is 6
    func insight() {
        // TODO: @Alekhya add code to display the stats of target
        // TODO: @kelly to add code to get the target's info for alekhya to display
        self.decreaseStamina(staminaCost: 6)
        
        let message = "\(self.characterName) has now gained insight into \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    // Allsight will allow you to know all of your enemies' stats
    func allSight() {
        // TODO: @Alekhya + @Kelly add code to display the stats of all enemies
        self.decreaseStamina(staminaCost: 12)
        
        let message = "\(self.characterName) now knows all the opposing team's stats through All Sight"
        messageLog.addToMessageLog(message: message)
    }
}

func actionRequiresEnemy() -> Bool {
    let actionSelected = rowSelected?.name
    
    switch actionSelected {
    case "Fight", "Action Surge", "Insight", "Frost Bite", "Mage Hand", "Shield", "Sleep", "Animate the Dead", "Heal", "Bardic Inspiration", "Vicious Mockery", "Blindness", "Invisibility":
        return true
    default:
        return false
    }
}

func actionRequiresRoll() -> Bool {
    let actionSelected = rowSelected?.name
    
    switch actionSelected {
    case "Fight", "Action Surge", "Frost Bite":
        return true
    default:
        return false
    }
}
