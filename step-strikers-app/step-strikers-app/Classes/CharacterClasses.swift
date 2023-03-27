//
//  CharacterClasses.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/25/23.
//

// These are for front-end, do not need to write to firebase

let FighterActions: [(actionName: String, cost: String)] = [
    (actionName: "Fight", cost: "?? STA"),
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
                  stamina: Int, dead: Bool, asleep: Bool, blind: Bool, invisible: Bool, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, dead: dead, asleep: asleep, blind: blind, invisible: invisible,currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    // Second wind will give Fighter 10HP but cost 8 stamina
    func secondWind() {
        self.increaseHealth(amtIncrease: 10)
        self.decreaseStamina(staminaCost: 8)
        
        let message = "\(self.characterName) has gotten a second wind"
        messageLog.addToMessageLog(message: message)
    }
    
    // Action surge will give you double damage on your attack if you pass the check
    func actionSurge(rollValue: Int) {
        let damageDealt: Int
        if (self.didAttackHit(rollValue: rollValue)) {
            damageDealt =  calculateModifiedDamage() * 2
        } else {
            damageDealt = 0
        }
        
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
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, spellPoints: Int, dead: Bool, asleep: Bool, blind: Bool, invisible: Bool, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, dead: dead, asleep: asleep, blind: blind, invisible: invisible, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    func castFrostbite(rollValue: Int) {
        decreaseSpellPoints(amtDecrease: 3)
        
        guard didSpellHit(rollValue: rollValue) else {
            let message = "\(self.characterName) failed in casting Frost Bite on \(currTarget.name)"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        let damage = rollDie(sides: 6, withAdvantage: localCharacter.hasAdvantage, withDisadvantage: localCharacter.hasDisadvantage)
        // Replace advantage and disadvantage back to false
        localCharacter.hasAdvantage = false
        localCharacter.hasDisadvantage = false
        decreaseTargetHealth(amtDamage: damage)
        
        
        let message = "\(self.characterName) cast frosbite on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castShield() {
        currTarget.defenseModifier += 20
        decreaseSpellPoints(amtDecrease: 4)

        let message = "\(self.characterName) cast shield on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    func sleep(rollValue: Int) {
        decreaseSpellPoints(amtDecrease: 12)
        
        guard didSpellHit(rollValue: rollValue) else {
            let message = "\(self.characterName) failed to cast sleep on \(currTarget.name)"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isSleep = true
        
        let message = "\(self.characterName) cast sleep on \(currTarget.name). Their turn is skipped for 1 round."
        messageLog.addToMessageLog(message: message)
    }
    
    func castAnimateDead() {
        decreaseSpellPoints(amtDecrease: 17)
        
        guard currTarget.isDead else {
            let message = "\(self.characterName) tried to cast Animate the Dead on \(currTarget.name) but they are not dead."
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isDead = false
        currTarget.health = 1
        
        let message = "\(self.characterName) cast animate dead on \(currTarget.name). They are now alive with 1HP"
        messageLog.addToMessageLog(message: message)
    }
    
    func heal(amtToHeal: Int) {
        increaseTargetHealth(amtHealed: amtToHeal)
        decreaseSpellPoints(amtDecrease: 5)
        
        let message = "\(self.characterName) healed \(currTarget.name) for \(amtToHeal)HP"
        messageLog.addToMessageLog(message: message)
    }
}


class Bard: Caster {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, spellPoints: Int, dead: Bool, asleep: Bool, blind: Bool, invisible: Bool, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, dead: dead, asleep: asleep, blind: blind, invisible: invisible, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    // TODO: @Jalyn. This is towards teammates. Wait for Alekhya.
    func castBardicInspiration() {
        currTarget.hasAdvantage = true
        decreaseSpellPoints(amtDecrease: 7)
        
        let message = "\(self.characterName) cast bardic inspiration on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    
    func castViciousMockery(rollValue: Int) {
        decreaseSpellPoints(amtDecrease: 7)
        
        guard currTarget.character_class != "Fighter" else {
            let message = "\(self.characterName) tried casting vicious mockery on \(currTarget.name). However, Fighters are too confident for mockery"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        guard didSpellHit(rollValue: rollValue) else {
            let message = "\(self.characterName) failed in casting vicious mockery on \(currTarget.name)"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.hasDisadvantage = true
        
        let message = "\(self.characterName) cast vicious mockery on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    // TODO: @Alekhya
    func castBlindness(rollValue: Int) {
        decreaseSpellPoints(amtDecrease: 8)
        
        guard currTarget.character_class != "Rogue" else {
            let message = "\(self.characterName) tried casting blindness on \(currTarget.name), but Rogues are too stealthy for this trickery."
            messageLog.addToMessageLog(message: message)
            return
        }
        
        guard didSpellHit(rollValue: rollValue) else {
            let message = "\(self.characterName) failed in casting blindness on \(currTarget.name)"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isBlind = true
        
        let message = "\(self.characterName) cast blindness on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    // TODO: @Alekhya
    func castInvisibility() {
        
        currTarget.isInvisible = true
        decreaseSpellPoints(amtDecrease: 10)
        
        let message = "\(self.characterName) cast invisibility on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
    //TODO: @Kelly for this to work, it needs to be written to all four team members in endTurn()
    func castMotivationalSpeech() {
        decreaseSpellPoints(amtDecrease: 15)
        
        let message = "\(self.characterName) cast motivational speech on their team"
        messageLog.addToMessageLog(message: message)
    }
}


class Rogue: RPGCharacter {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, dead: Bool, asleep: Bool, blind: Bool, invisible: Bool, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, dead: dead, asleep: asleep, blind: blind, invisible: invisible, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
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
    case "Fight", "Action Surge", "Frost Bite", "Mage Hand", "Sleep", "Heal", "Vicious Mockery", "Blindness":
        return true
    default:
        return false
    }
}

func actionIsContested() -> Bool {
    let actionSelected = rowSelected?.name
    
    switch actionSelected {
    case "Fight", "Action Surge", "Frost Bite", "Mage Hand", "Sleep", "Vicious Mockery", "Blindness":
        return true
    default:
        return false
    }
}

func actionTargetsTeam() -> Bool {
    let actionSelected = rowSelected?.name
    
    switch actionSelected {
    case "Shield", "Bardic Inspiration", "Invisibility", "Animate the Dead", "Heal":
        return true
    default:
        return false
    }
}

func isAnimateDead() -> Bool {
    let actionSelected = rowSelected?.name
    
    switch actionSelected {
    case "Animate the Dead":
        return true
    default:
        return false
    }
}

// based on the actionName return the description for that action
func actionDescription(actionName: String) -> String {
    switch actionName {
    case "Frostbite":
        return "Damages 1 opponent for 1d6 of damage if save is failed"
    case "Mage Hand":
        return "Take a weapon from someone and give it to yourself"
    case "Shield":
        return "Protect yourself or someone else"
    case "Sleep":
        return "Put 1 opponent to sleep and make them lose a turn"
    case "Animate the Dead":
        return "Bring someone back to life"
    case "Heal":
        return "Heal someone based on dice roll"
    case "Uncanny Dodge":
        return "Add +3 to armor class modifier"
    case "Hone Skill":
        return "+5 attack modifier"
    case "Insight":
        return "Select a target and know their HP"
    case "Allsight":
        return "Know all of your enemies' HP"
    case "Second Wind":
        return "Regain 10 HP"
    case "Action Surge":
        return "Double Damage if you beat the roll"
    case "Sharpen Weapon":
        return "+3 attack modifier"
    case "Bardic Inspiration":
        return "Allows target to roll with advantage"
    case "Vicious Mockery":
        return "Makes target roll with disadvantage"
    case "Blindness":
        return "Cause enemy to go blind and enemy cannot select who to target on their turn"
    case "Invisibility":
        return "No one can see you and you cannot be attacked for 1 turn"
    case "Motivational Speech":
        return "Gives Bardic Inspiration to the entire group"
    default:
        return ""
    }
}
