//
//  Item.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/15/23.
//

// TODO: Decide what ends a turn
import FirebaseFirestore

let smallAmountOfRestoration: Int = 5
let moderateAmountOfRestoration: Int = 10
let largeAmountOfRestoration: Int = 15
let smallAmountOfModification: Int = 3
let moderateAmountOfModification: Int = 5
let largeAmountOfModification: Int = 7
let allItems: [String] = ["Potion of Healing", "Elixir of Magic", "Energy Pill", "Antidote", "Awakening", "Potion of Greater Healing", "Elixir of Greater Magic", "Energy Powder", "Resurrection Stone", "Four Leaf Clover", "Leather Armor Pad", "Feather of Vigor", "Scroll of Resistance", "Potion of Superior Healing", "Elixir of Superior Magic", "Energy Root", "Revival Crystal", "Five-Leaf Clover", "Metal Armor Pad", "Vial of Vigor", "Scroll of Greater Resistance", "Potion of Vitality", "Elixir of Sorcery", "Energy Sap", "Miracle of Life", "Seven-leaf Clover", "Heart of Iron"]
let tierOneItems: [String] = ["Potion of Healing", "Elixir of Magic", "Energy Pill", "Antidote", "Awakening"]
let tierTwoItems: [String] = ["Potion of Greater Healing", "Elixir of Greater Magic", "Energy Powder", "Resurrection Stone", "Four Leaf Clover", "Leather Armor Pad", "Feather of Vigor", "Scroll of Resistance"]
let tierThreeItems: [String] = ["Potion of Superior Healing", "Elixir of Superior Magic", "Energy Root", "Revival Crystal", "Five-Leaf Clover", "Metal Armor Pad", "Vial of Vigor", "Scroll of Greater Resistance"]
let tierFourItems: [String] = ["Potion of Vitality", "Elixir of Sorcery", "Energy Sap", "Miracle of Life", "Seven-leaf Clover", "Heart of Iron"]

func rebuildItem(itemName: String, owner: RPGCharacter) -> Item {
    switch itemName {
        case "Potion of Healing":
            return PotionOfHealing(owner: owner)
        case "Elixir of Magic":
            return ElixirOfMagic(owner: owner)
        case "Energy Pill":
            return EnergyPill(owner: owner)
        case "Antidote":
            return Antidote(owner: owner)
        case "Awakening":
            return Awakening(owner: owner)
        case "Potion of Greater Healing":
            return PotionOfGreaterHealing(owner: owner)
        case "Elixir of Greater Magic":
            return ElixirOfGreaterMagic(owner: owner)
        case "Energy Powder":
            return EnergyPowder(owner: owner)
        case "Resurrection Stone":
            return ResurrectionStone(owner: owner)
        case "Four Leaf Clover":
            return FourLeafClover(owner: owner)
        case "Leather Armor Pad":
            return LeatherArmorPad(owner: owner)
        case "Feather of Vigor":
            return FeatherOfVigor(owner: owner)
        case "Scroll of Resistance":
            return ScrollOfResistance(owner: owner)
        case "Potion of Superior Healing":
            return PotionOfSuperiorHealing(owner: owner)
        case "Elixir of Superior Magic":
            return ElixirOfSuperiorMagic(owner: owner)
        case "Energy Root":
            return EnergyRoot(owner: owner)
        case "Revival Crystal":
            return RevivalCrystal(owner: owner)
        case "Five-Leaf Clover":
            return FiveLeafClover(owner: owner)
        case "Metal Armor Pad":
            return MetalArmorPad(owner: owner)
        case "Vial of Vigor":
            return VialOfVigor(owner: owner)
        case "Scroll of Greater Resistance":
            return ScrollOfGreaterResistance(owner: owner)
        case "Potion of Vitality":
            return PotionOfVitality(owner: owner)
        case "Elixir of Sorcery":
            return ElixirOfSorcery(owner: owner)
        case "Energy Sap":
            return EnergySap(owner: owner)
        case "Miracle of Life":
            return MiracleOfLife(owner: owner)
        case "Seven-leaf Clover":
            return SevenLeafClover(owner: owner)
        case "Heart of Iron":
            return HeartOfIron(owner: owner)
        default:
            return PotionOfHealing(owner: owner)
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
    messageLog.addToMessageLog(message: message)
}

func randomWinnerItemDrop(newOwner: RPGCharacter) -> [String] {
    
    // 1. New Weapon
    var tempString: String = allWeapons[Int.random(in: 0..<allWeapons.count-1)]
    var newWeapon: Weapon = rebuildWeapon(weaponName: tempString, useCount: 0)
    while !newWeapon.checkIfProficient(wielderClass: newOwner.getCharacterClass()) {
        tempString = allWeapons[Int.random(in: 0..<allWeapons.count-1)]
        newWeapon = rebuildWeapon(weaponName: tempString, useCount: 0)
    }
    newOwner.addToInventory(weaponObject: newWeapon)
    
    // 2. New Armor
    tempString = allArmor[Int.random(in: 0..<allArmor.count-1)]
    var newArmor: Armor = rebuildArmor(armorName: tempString, useCount: 0)
    // Only non-Wizards have suited Armor, Wizards will get whatever
    if !(newOwner is Wizard) {
        while !newArmor.checkIfSuited(wearerCharacterType: newOwner.getCharacterClass()) {
            tempString = allArmor[Int.random(in: 0..<allArmor.count-1)]
            newArmor = rebuildArmor(armorName: tempString, useCount: 0)
        }
    }
    newOwner.addToInventory(armorObject: newArmor)
    
    // 3. New Item
    tempString = allItems[Int.random(in: 0..<allItems.count)]
    let newItem: Item = rebuildItem(itemName: tempString, owner: newOwner)
    newOwner.addToInventory(itemObject: newItem)
    
    // write your cool new items to firebase
    Firestore.firestore().collection("players").document(newOwner.userName).updateData([
        "weapon_inventory": FieldValue.arrayUnion([getConstructedName(weapon: newWeapon)]),
        "armor_inventory": FieldValue.arrayUnion([getConstructedName(armor: newArmor)]),
        "item_inventory": FieldValue.arrayUnion([newItem.name])])
    
    return [newWeapon.name, newArmor.name, newItem.name]
}

func milestoneItemDrop() -> String {
    // Calculate the item tier
    let tier = localCharacter.currMilestone / 3000
    
    // Randomly select a new item
    var tempString: String!
    switch tier {
    case 1:
        tempString = tierOneItems[Int.random(in: 0..<tierOneItems.count)]
    case 2:
        tempString = tierTwoItems[Int.random(in: 0..<tierTwoItems.count)]
    case 3:
        tempString = tierThreeItems[Int.random(in: 0..<tierThreeItems.count)]
    case 4:
        tempString = tierFourItems[Int.random(in: 0..<tierFourItems.count)]
    default:
        return ""
    }

    // Create the new item and add it to the user's inventory
    let newItem = rebuildItem(itemName: tempString, owner: localCharacter)
    localCharacter.addToInventory(itemObject: newItem)
    localCharacter.inventoryQuantities[tempString] = (localCharacter.inventoryQuantities[tempString] ?? 0)+1
    
    // Add the item to Firebase
    Firestore.firestore().collection("players").document(localCharacter.userName).updateData(["item_inventory": FieldValue.arrayUnion([newItem.name])])
    
    return tempString
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
struct PotionOfHealing: Item {
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
struct ElixirOfMagic: Item {
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
struct EnergyPill: Item {
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
struct Antidote: Item {
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
struct Awakening: Item {
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
struct PotionOfGreaterHealing: Item {
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
struct ElixirOfGreaterMagic: Item {
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
struct EnergyPowder: Item {
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
struct ResurrectionStone: Item {
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
struct FourLeafClover: Item {
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
struct LeatherArmorPad: Item {
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
struct FeatherOfVigor: Item {
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
struct ScrollOfResistance: Item {
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
struct PotionOfSuperiorHealing: Item {
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
struct ElixirOfSuperiorMagic: Item {
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
struct EnergyRoot: Item {
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
struct RevivalCrystal: Item {
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
struct FiveLeafClover: Item {
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
struct MetalArmorPad: Item {
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
struct VialOfVigor: Item {
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
struct ScrollOfGreaterResistance: Item {
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
struct PotionOfVitality: Item {
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
struct ElixirOfSorcery: Item {
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
struct EnergySap: Item {
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
struct MiracleOfLife: Item {
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
struct SevenLeafClover: Item {
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
struct HeartOfIron: Item {
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
