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

protocol Item {
    var name: String { get }
    var owner: RPGCharacter { get set }
    var tier: Int { get set }
    
    init(owner: RPGCharacter)
    func use()
    func use(target: RPGCharacter)
}

// restores a small amount of health
struct potionOfHealing: Item {
    let name = "Potion of Healing"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    func use(){
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseHealth(amtIncrease: smallAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        if(target is Caster){
            (target as! Caster).increaseSpellPoints(amtIncrease: smallAmountOfRestoration)
        } else {
            print("\(target.characterName) cannot take \(self.name) because they are not a Caster")
        }
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseStamina(amtIncrease: smallAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
    }
}

// cures any ailments
struct antidote: Item {
    let name = "Antidote"
    var owner: RPGCharacter
    var tier = 1
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    // TODO: Define ailment
    func use() {
        // If they are in the blind list, fix that
        use(target: self.owner)
    }
    
    // TODO: Define ailment
    func use(target: RPGCharacter) {
        // dependent on blind list
        removeItemFromInventory(itemToRemove: self)
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
    
    // TODO: Race conflict? Ask team because it would make sense that they take this while it is not their turn
    func use() {
        // Remove them from the sleep list
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        // remove them from sleep list
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseHealth(amtIncrease: moderateAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        if(target is Caster) {
            (target as! Caster).increaseSpellPoints(amtIncrease: moderateAmountOfRestoration)
        } else {
            print("\(target.characterName) cannot take \(self.name) because they are not a Caster")
        }
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseStamina(amtIncrease: moderateAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
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
    
    // Using the resurrectionStone without a target assumes that they are using it on themselves
    func use() {
        // TODO: Remove them from the dead list
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter){
        // TODO: Remove target from the dead list
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.attackModifier += 2
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.defenseModifier += smallAmountOfModification
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.attackModifier += smallAmountOfModification
        removeItemFromInventory(itemToRemove: self)
    }
}

// increases magic resistance by a small amount
// TODO: Add the implementation of this on Spell file?
struct scrollOfResistance: Item {
    var name = "Scroll of Resistance"
    var owner: RPGCharacter
    var tier = 2
    
    init(owner: RPGCharacter) {
        self.owner = owner
    }
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.magicResistanceModifier += smallAmountOfModification
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseHealth(amtIncrease: largeAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        if(target is Caster){
            (target as! Caster).increaseSpellPoints(amtIncrease: largeAmountOfRestoration)
        } else {
            print("\(target.characterName) cannot take \(self.name) because they are not a Caster")
        }
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.increaseStamina(amtIncrease: largeAmountOfRestoration)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        // TODO: Finish when done with death and revival functionality
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        // finish when done w death
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        owner.attackModifier += 5
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.defenseModifier += moderateAmountOfModification
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.attackModifier += moderateAmountOfModification
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.magicResistanceModifier += moderateAmountOfModification
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        var difference = target.maxHealth - target.currHealth
        target.increaseHealth(amtIncrease: difference)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        if(target is Caster){
            var tempTarget = target as! Caster
            var difference = tempTarget.maxSpellPoints - tempTarget.currSpellPoints
            tempTarget.increaseSpellPoints(amtIncrease: difference)
        } else {
            print("\(target.characterName) cannot take \(self.name) because they are not a Caster")
        }
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        let difference = target.maxStamina - target.currStamina
        target.increaseStamina(amtIncrease: difference)
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        // TODO: Fix when death functionality is working
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        // TODO: Fix when deathe functionality is working
        removeItemFromInventory(itemToRemove: self)
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.attackModifier = 20
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
    
    func use() {
        use(target: self.owner)
    }
    
    func use(target: RPGCharacter) {
        target.defenseModifier = 20
        removeItemFromInventory(itemToRemove: self)
    }
}


func removeItemFromInventory(itemToRemove: Item){
    let owner = itemToRemove.owner
    if let indexOfItemToRemove: Int = owner.itemsInInventory.firstIndex(where: {item in item.name == itemToRemove.name}) {
        owner.itemsInInventory.remove(at: indexOfItemToRemove)
    }
}
