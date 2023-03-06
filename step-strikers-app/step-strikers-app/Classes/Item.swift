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

func getStringArray (items:[Item]) -> [String] {
    var itemStrings = [String]()
    
    for item in items {
        itemStrings.append(item.name)
    }
    
    return itemStrings
}

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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        let difference = target.maxHealth - target.currHealth
        target.increaseHealth(amtIncrease: difference)
        _ = self.owner.removeFromInventory(itemObject: self)
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
            let tempTarget = target as! Caster
            let difference = tempTarget.maxSpellPoints - tempTarget.currSpellPoints
            tempTarget.increaseSpellPoints(amtIncrease: difference)
        } else {
            print("\(target.characterName) cannot take \(self.name) because they are not a Caster")
        }
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
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
        _ = self.owner.removeFromInventory(itemObject: self)
    }
}
