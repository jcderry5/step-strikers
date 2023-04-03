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
    
    func castInvisibility() {
        
        currTarget.isInvisible = true
        decreaseSpellPoints(amtDecrease: 10)
        
        let message = "\(self.characterName) cast invisibility on \(currTarget.name)"
        messageLog.addToMessageLog(message: message)
    }
    
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
    
    guard rowSelected != nil else {
        return false
    }

    let actionSelected = rowSelected?.name
    
    print("DEBUG: \(String(describing: actionSelected))")
    
    switch actionSelected {
    case "Fight", "Action Surge", "Insight", "Frost Bite", "Mage Hand", "Shield", "Sleep", "Animate the Dead", "Heal", "Bardic Inspiration", "Vicious Mockery", "Blindness", "Invisibility":
        print("DEBUG: \(String(describing: actionSelected)) returns true")
        return true
    default:
        print("DEBUG: \(String(describing: actionSelected)) returns false")
        return false
    }
}

func actionRequiresRoll() -> Bool {
    guard rowSelected != nil else {
        return false
    }
    
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
    case "Fight":
        return "Attack your target using the weapon you are currently wielding."
    case "Frost Bite":
        return "Cast a spell against your target for up to six points of damage"
    case "Mage Hand":
        return "Take the current weapon from an enemy and wield it"
    case "Shield":
        return "Boost the defense modifier of one of your teammates"
    case "Sleep":
        return "Put an enemy to sleep causing them to skip their next turn"
    case "Animate the Dead":
        return "Revive a dead teammate to 1HP"
    case "Heal":
        return "Heal a teammate for up to 8HP"
    case "Uncanny Dodge":
        return "Take a turn to increase your defense modifier"
    case "Hone Skill":
        return "Take a turn to increase your attack modifier"
    case "Insight":
        return "View the stats for one of your enemies"
    case "Allsight":
        return "View the stats for all of your enemies"
    case "Second Wind":
        return "Take a turn to rest for +10 Health"
    case "Action Surge":
        return "Attack your target using your current weapon with the chance to double the damage you deal"
    case "Sharpen Weapon":
        return "Take a turn to increase your attack modifier"
    case "Bardic Inspiration":
        return "Inspire a teammate giving them advantage on their next roll"
    case "Vicious Mockery":
        return "Mock an enemy giving them disadvantage on their next roll"
    case "Blindness":
        return "Blind an enemy taking away the choice to select their target on their next turn"
    case "Invisibility":
        return "Make a teammate invisible, preventing them from being targeted until after their next turn"
    case "Motivational Speech":
        return "Inspire your entire team, giving your entire team advantage on their next roll"
    default:
        return ""
    }
}

func itemDescription(itemName:String) -> String {
    switch itemName {
    case "Potion of Healing":
        return "Restores a small amount of health"
    case "Elixir of Magic":
        return "Restores a small amount of magic"
    case "Energy Powder":
        return "Restores a small amount of stamina"
    case "Antidote":
        return "Cures blindess"
    case "Awakening":
        return "Wakes up the target"
    case "Potion of Greater Healing":
        return "Restores a moderate amount of health"
    case "Elixir of Great Magic":
        return "Restores a moderate amount of magic"
    case "Energy Pill":
        return "Restores a moderate amount of stamina"
    case "Resurrection Stone":
        return "Revives the target with small healing"
    case "Four-leaf Clover":
        return "+2 to attack roll"
    case "Leather Armor Pad":
        return "Increase defense by a small amount"
    case "Feather of Vigor":
        return "Increase attack by a small amount"
    case "Scroll of Resistance":
        return "Increases magic resistance by a small amount"
    case "Potion of Superior Healing":
        return "Restores a large amount of health"
    case "Elixir of Superior Magic":
        return "Restores a large amount of magic"
    case "Energy Root":
        return "Restores a large amount of stamina"
    case "Revival Crystal":
        return "Revives the target with moderate healing"
    case "Five-leaf Clover":
        return "+4 to attack roll"
    case "Metal Armor Pad":
        return "Increase defense by a moderate amount"
    case "Vial of Vigor":
        return "Increase attack by a moderate amount"
    case "Scroll of Greater Resistance":
        return "Increases magic resistance by a moderate amount"
    case "Potion of Vitality":
        return "Fully restores health"
    case "Elixir of Sorcery":
        return "Fully restores magic"
    case "Energy Sap":
        return "Fully restores stamina"
    case "Miracle of Life":
        return "Revives target with full health"
    case "Seven-leaf Clover":
        return "Attack is guaranteed to hit"
    case "Heart of Iron":
        return "Prevents the uder from taking damage. Lasts 1 turn"
    default:
        return ""
    }
}

func equipDescription(equipName:String) -> String {
    switch equipName {
    case "Fists":
        return "deals 2 damage at the cost of 0 stamina"
    case "Dagger":
        return "deals 4 damage at the cost of 3 stamina"
    case "Darts":
        return "deals 5 damage at the cost of 4 stamina"
    case "Cross-Bow":
        return "deals 8 damage at the cost of 5 stamina"
    case "Rapier":
        return "deals 8 damage at the cost of 5 stamina"
    case "Short Sword":
        return "deals 6 damage at the cost of 4 stamina"
    case "Long Bow":
        return "deals 8 damage at the cost of 6 stamina"
    case "Hand Axe":
        return "deals 6 damage at the cost of 5 stamina"
    case "Battle Axe":
        return "deals 10 damage at the cost of 8 stamina"
    case "Long Sword":
        return "deals 8 damage at the cost of 5 stamina"
    case "Leather":
        return "equips you with 11 AC"
    case "Padded":
        return "equips you with 11 AC"
    case "Studded Leather":
        return "equips you with 12 AC"
    case "Chainmail":
        return "equips you with 16 AC"
    case "Shield":
        return "equips you with 2 AC"
    case "Leather Armor":
        return "equips you with 11 AC"
    case "No Armor":
        return "equips you with 0 AC"
    default:
        return ""
    }
}
