//
//  Item.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/15/23.
//

// TODO: Decide what ends a turn

let smallAmountOfRestoration: Int = 5
let moderateAmountOfRestoration: Int = 10
let largeAmountOfRestoration: Int = 15
let smallAmountOfModification: Int = 3
let moderateAmountOfModification: Int = 5
let largeAmountOfModification: Int = 7

func rebuildItem(itemName: String, owner: RPGCharacter) -> Item {
    switch itemName {
        case "Potion of Healing":
            return potionOfHealing(owner: owner)
        case "Elixir of Magic":
            return elixirOfMagic(owner: owner)
        case "Energy Pill":
            return energyPill(owner: owner)
        case "Antidote":
            return antidote(owner: owner)
        case "Awakening":
                return awakening(owner: owner)
        case "Potion of Greater Healing":
            return potionOfGreaterHealing(owner: owner)
        case "Elixir of Greater Magic":
            return elixirOfGreaterMagic(owner: owner)
        case "Energy Powder":
            return energyPowder(owner: owner)
        case "Resurrection Stone":
            return resurrectionStone(owner: owner)
        case "Four Leaf Clover":
                return fourLeafClover(owner: owner)
        case "Leather Armor Pad":
            return leatherArmorPad(owner: owner)
        case "Feather of Vigor":
            return featherOfVigor(owner: owner)
        case "Scroll of Resistance":
            return scrollOfResistance(owner: owner)
        case "Potion of Superior Healing":
            return potionOfSuperiorHealing(owner: owner)
        case "Elixir of Superior Magic":
            return elixirOfSuperiorMagic(owner: owner)
        case "Energy Root":
            return energyRoot(owner: owner)
        case "Revival Crystal":
            return revivalCrystal(owner: owner)
        case "Five-Leaf Clover":
            return fiveLeafClover(owner: owner)
        case "Metal Armor Pad":
            return metalArmorPad(owner: owner)
        case "Vial of Vigor":
            return vialOfVigor(owner: owner)
        case "Scroll of Greater Resistance":
            return scrollOfGreaterResistance(owner: owner)
        case "Potion of Vitality":
            return potionOfVitality(owner: owner)
        case "Elixir of Sorcery":
            return elixirOfSorcery(owner: owner)
        case "Energy Sap":
            return energySap(owner: owner)
        case "Miracle of Life":
            return miracleOfLife(owner: owner)
        case "Seven-leaf Clover":
            return sevenLeafClover(owner: owner)
        case "Heart of Iron":
            return heartOfIron(owner: owner)
        default:
            return potionOfHealing(owner: owner)
    }
}

func returnItemFromInventory(requestedItemName: String, itemInventory: [Item]) -> Item{
    guard itemInventory.contains(where: {item in item.name == requestedItemName}) else {
        print ("ERROR: You are looking for an item that's not in this inventory. Returning first item")
        return itemInventory[0]
    }
    return itemInventory.first(where: {item in item.name == requestedItemName})!
}

func getItemStrings (items:[Item]) -> [String] {
    var itemStrings = [String]()
    
    for item in items {
        itemStrings.append(item.name)
    }
    
    return itemStrings
}

func postItemUseActions(itemUsed: Item, message: String) {
    _ = itemUsed.owner.removeFromInventory(itemObject: itemUsed)
}

protocol Item {
    var name: String { get }
    var owner: RPGCharacter { get set }
    var tier: Int { get set }
    
    init(owner: RPGCharacter)
    func useOnSelf()
    func useOnTarget()
}

// restores a small amount of health
struct potionOfHealing: Item {
    let name = "Potion of Healing"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    func useOnSelf(){
        localCharacter.increaseHealth(amtIncrease: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(smallAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetHealth(amtHealed: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(currTarget.name) \(self.name) to heal for \(smallAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a small amount of magic
struct elixirOfMagic: Item {
    let name = "Elixir of Magic"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    func useOnSelf() {
        guard localCharacter is Caster else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        (localCharacter as! Caster).increaseSpellPoints(amtIncrease: smallAmountOfRestoration)
        postItemUseActions(itemUsed: self, message: "\(localCharacter.characterName) consumed \(self.name) for \(smallAmountOfRestoration)MAG")
    }
    
    func useOnTarget() {
        guard currTarget.character_class == "Bard" || currTarget.character_class == "Wizard" else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        increaseTargetSpellPoints(amtIncrease: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) to consume for \(smallAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a small amount of stamina
struct energyPill: Item {
    var name = "Energy Pill"
    var owner: RPGCharacter
    var tier: Int = 1
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.increaseStamina(amtIncrease: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(smallAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetStamina(amtIncrease: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) for \(smallAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// cures blindness
struct antidote: Item {
    let name = "Antidote"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        guard localCharacter.isBlind else {
            let message = "\(localCharacter.characterName) cannot use \(self.name) because they are not blind"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        localCharacter.isBlind = false
        let message = "\(localCharacter.characterName) used \(self.name) to cure their blindness"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        guard currTarget.isBlind else {
            let message = "\(currTarget.name) cannot use \(self.name) because they are not blind"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isBlind = false
        let message = "\(localCharacter.characterName) used \(self.name) on \(currTarget.name) to cure their blindness"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// wakes up the target
struct awakening: Item {
    let name = "Awakening"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        // Impossible reach. They won't get the chance!
        print("ERROR: \(localCharacter.characterName) is asleep but used a potion on themself.")
    }
    
    func useOnTarget() {
        currTarget.isSleep = false
        let message = "\(localCharacter.characterName) just used \(self.name) on \(currTarget.name) to awaken them from sleep"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a moderate amount of health
struct potionOfGreaterHealing: Item {
    let name = "Potion of Greater Healing"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.increaseHealth(amtIncrease: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(moderateAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetHealth(amtHealed: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(currTarget.name) to \(self.name) to heal for \(moderateAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a moderate amount of magic
struct elixirOfGreaterMagic: Item {
    let name = "Elixir of Greater Magic"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        guard localCharacter is Caster else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        (localCharacter as! Caster).increaseSpellPoints(amtIncrease: moderateAmountOfRestoration)
        postItemUseActions(itemUsed: self, message: "\(localCharacter.characterName) consumed \(self.name) for \(moderateAmountOfRestoration)MAG")
    }
    
    func useOnTarget() {
        guard currTarget.character_class == "Bard" || currTarget.character_class == "Wizard" else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        increaseTargetSpellPoints(amtIncrease: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) to consume for \(moderateAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a moderate amount of stamina
struct energyPowder: Item {
    var name = "Energy Powder"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.increaseStamina(amtIncrease: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(moderateAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetStamina(amtIncrease: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) for \(moderateAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// revives the target with small healing
struct resurrectionStone: Item {
    let name = "Resurrection Stone"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        // Impossible reach. They won't get the chance!
        print("ERROR: \(localCharacter.characterName) is dead but used a potion on themself.")
    }
    
    func useOnTarget(){
        guard currTarget.isDead else {
            let message = "\(localCharacter.characterName) cannot use \(self.name) on \(currTarget.name) because they are not dead"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isDead = false
        increaseTargetHealth(amtHealed: smallAmountOfRestoration)
        let message = "\(localCharacter.characterName) just revived \(currTarget.name) with \(smallAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// +2 to attack roll
struct fourLeafClover: Item {
    let name = "Four Leaf Clover"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.attackModifier += 2
        let message = "\(localCharacter.characterName) just consumed a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.attackModifier += 2
        let message = "\(currTarget.name) just consumed a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases defense by a small amount
struct leatherArmorPad: Item {
    let name = "Leather Armor Pad"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.defenseModifier += smallAmountOfModification
        let message = "\(localCharacter.characterName) just added a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.defenseModifier += smallAmountOfModification
        let message = "\(currTarget.name) just added a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases attack by a small amount
struct featherOfVigor: Item {
    let name = "Feather of Vigor"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.attackModifier += smallAmountOfModification
        let message = "\(localCharacter.characterName) just used a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.attackModifier += smallAmountOfModification
        let message = "\(currTarget.name) just used a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases magic resistance by a small amount
struct scrollOfResistance: Item {
    var name = "Scroll of Resistance"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.magicResistanceModifier += smallAmountOfModification
        let message = "\(localCharacter.characterName) just used a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.magicResistanceModifier += smallAmountOfModification
        let message = "\(currTarget.name) just used a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a large amount of health
struct potionOfSuperiorHealing: Item {
    var name = "Potion of Superior Healing"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.increaseHealth(amtIncrease: largeAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(largeAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetHealth(amtHealed: largeAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(currTarget.name) to \(self.name) to heal for \(largeAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restores a large amount of magic
struct elixirOfSuperiorMagic: Item {
    var name = "Elixir of Superior Magic"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        guard localCharacter is Caster else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        (localCharacter as! Caster).increaseSpellPoints(amtIncrease: largeAmountOfRestoration)
        postItemUseActions(itemUsed: self, message: "\(localCharacter.characterName) consumed \(self.name) for \(largeAmountOfRestoration)MAG")
    }
    
    func useOnTarget() {
        guard currTarget.character_class == "Bard" || currTarget.character_class == "Wizard" else {
            let message = "\(currTarget.name) cannot take \(self.name) because they are not a Caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        increaseTargetSpellPoints(amtIncrease: largeAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) to consume for \(largeAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// restore a large amount of stamina
struct energyRoot: Item {
    var name = "Energy Root"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.increaseStamina(amtIncrease: largeAmountOfRestoration)
        let message = "\(localCharacter.characterName) consumed \(self.name) for \(largeAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        increaseTargetStamina(amtIncrease: largeAmountOfRestoration)
        let message = "\(localCharacter.characterName) gave \(self.name) to \(currTarget.name) for \(largeAmountOfRestoration)STA"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// revives the target with moderate healing
struct revivalCrystal: Item {
    var name = "Revival Crystal"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        // Impossible reach. They won't get the chance!
        print("ERROR: \(localCharacter.characterName) is dead but used a potion on themself.")
    }
    
    func useOnTarget(){
        guard currTarget.isDead else {
            let message = "\(localCharacter.characterName) cannot use \(self.name) on \(currTarget.name) because they are not dead"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isDead = false
        increaseTargetHealth(amtHealed: moderateAmountOfRestoration)
        let message = "\(localCharacter.characterName) just revived \(currTarget.name) with \(moderateAmountOfRestoration)HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// +4 to attack roll
struct fiveLeafClover: Item {
    var name = "Five-Leaf Clover"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.attackModifier += 4
        let message = "\(localCharacter.characterName) just consumed a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.attackModifier += 4
        let message = "\(currTarget.name) just consumed a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases defense by a moderate amount
struct metalArmorPad: Item {
    var name = "Metal Armor Pad"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.defenseModifier += moderateAmountOfModification
        let message = "\(localCharacter.characterName) just added a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.defenseModifier += moderateAmountOfModification
        let message = "\(currTarget.name) just added a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases attack by a moderate amount
struct vialOfVigor: Item {
    var name = "Vial of Vigor"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.attackModifier += moderateAmountOfModification
        let message = "\(localCharacter.characterName) just used a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.attackModifier += moderateAmountOfModification
        let message = "\(currTarget.name) just used a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// increases magic resistance by a moderate amount
struct scrollOfGreaterResistance: Item {
    var name = "Scroll of Greater Resistance"
    var owner: RPGCharacter
    var tier = 3
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.magicResistanceModifier += moderateAmountOfModification
        let message = "\(localCharacter.characterName) just used a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.magicResistanceModifier += moderateAmountOfModification
        let message = "\(currTarget.name) just used a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// Fully Restores Health
struct potionOfVitality: Item {
    var name = "Potion of Vitality"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        let difference = getMaxHealth(characterClass: String(localCharacter.getCharacterClass())) - localCharacter.currHealth
        localCharacter.increaseHealth(amtIncrease: difference)
        let message = "\(localCharacter.characterName) just drank \(self.name) to restore full health!"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        let differece = getMaxHealth(characterClass: currTarget.character_class) - currTarget.health
        increaseTargetHealth(amtHealed: differece)
        let message = "\(currTarget.name) just drank \(self.name) from \(localCharacter.characterName) to restore full health"
        postItemUseActions(itemUsed: self, message: message)
    }
}


// Fully Restores Spell Points
struct elixirOfSorcery: Item {
    var name = "Elixir of Sorcery"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        guard localCharacter is Caster else {
            let message = "\(localCharacter.characterName) cannot drink \(self.name) because they are not a caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        let difference = getMaxSpellPoints(characterClass: String(localCharacter.getCharacterClass())) - (localCharacter as! Caster).currSpellPoints
        (localCharacter as! Caster).increaseSpellPoints(amtIncrease: difference)
        let message = "\(localCharacter.characterName) just drank \(self.name) to restore full spell points!"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        guard currTarget.character_class == "Bard" || currTarget.character_class == "Wizard" else {
            let message = "\(currTarget.name) cannot drink \(self.name) because they are not a caster"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        let difference = getMaxSpellPoints(characterClass: currTarget.character_class) - currTarget.spellPoints
        increaseTargetSpellPoints(amtIncrease: difference)
        let message = "\(currTarget.name) just drank \(self.name) from \(localCharacter.characterName) to restore full spell points"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// Fully restores stamina
struct energySap: Item {
    var name = "Energy Sap"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        let difference = getMaxStamina(characterClass: String(localCharacter.getCharacterClass())) - localCharacter.currStamina
        localCharacter.increaseStamina(amtIncrease: difference)
        let message = "\(localCharacter.characterName) just drank \(self.name) to restore full stamina!"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        let differece = getMaxStamina(characterClass: currTarget.character_class) - currTarget.currStamina
        increaseTargetStamina(amtIncrease: differece)
        let message = "\(currTarget.name) just drank \(self.name) from \(localCharacter.characterName) to restore full stamina!"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// Fully Revives Target with Full Health
struct miracleOfLife: Item {
    var name = "Miracle of Life"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        // Impossible reach. They won't get the chance!
        print("ERROR: \(localCharacter.characterName) is dead but used a potion on themself.")
    }
    
    func useOnTarget(){
        guard currTarget.isDead else {
            let message = "\(localCharacter.characterName) cannot use \(self.name) on \(currTarget.name) because they are not dead"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        currTarget.isDead = false
        increaseTargetHealth(amtHealed: getMaxHealth(characterClass: currTarget.character_class))
        let message = "\(localCharacter.characterName) just revived \(currTarget.name) to MAX HP"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// Attack is guaranteed to hit
struct sevenLeafClover: Item {
    var name = "Seven-leaf Clover"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.attackModifier += 20
        let message = "\(localCharacter.characterName) just consumed a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.attackModifier += 20
        let message = "\(currTarget.name) just consumed a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}

// prevents the user from taking damage. Lasts 1 turn
struct heartOfIron: Item {
    var name = "Heart of Iron"
    var owner: RPGCharacter
    var tier = 4
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func useOnSelf() {
        localCharacter.defenseModifier += 20
        let message = "\(localCharacter.characterName) just added a \(self.name)"
        postItemUseActions(itemUsed: self, message: message)
    }
    
    func useOnTarget() {
        currTarget.defenseModifier += 20
        let message = "\(currTarget.name) just added a \(self.name) from \(localCharacter.characterName)"
        postItemUseActions(itemUsed: self, message: message)
    }
}
