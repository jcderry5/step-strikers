//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//

let allArmor: [String] = ["Leather","Padding","Studded Leather","Chain Mail","Shield","No Armor"]

protocol Armor {
    var name: String { get}
    var armorClass: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    init()
    init(useCount: Int)
    func checkIfSuited(wearerCharacterType: String) -> Bool
}

func getArmorStrings(armors:[Armor]) -> [String] {
    var armorStrings = [String]()
    for armor in armors {
        armorStrings.append(getConstructedName(armor: armor))
    }
    
    return armorStrings
}

func getConstructedName(armor: Armor) -> String {
    var constructedName = ""
    if(armor.useCount < 10){
        constructedName += "0\(armor.useCount)"
    } else {
        constructedName += "\(armor.useCount)"
    }
    constructedName += armor.name
    
    return constructedName
}

func rebuildArmor(armorName: String, useCount: Int) -> Armor{
    switch armorName {
    case "Leather":
        return Leather(useCount: useCount)
    case "Padding":
        return Padding(useCount: useCount)
    case "Studded Leather":
        return StuddedLeather(useCount: useCount)
    case "Chain Mail":
        return ChainMail(useCount: useCount)
    case "Shield":
        return Shield(useCount: useCount)
    case "No Armor":
        return NoArmor(useCount: useCount)
    default:
        return NoArmor()
    }
}

func rebuildArmorInventory(armorInventory: [String]) -> [Armor] {
    var armorInventoryToStore: [Armor] = []
    for armor in armorInventory {
        // Splitting Armor + UseCount from a single string
        let armorUseCountTuple = splitObjAndUseCount(objWithUseCount: armor)
        let armorName = armorUseCountTuple.objectName
        let armorUseCount: Int = armorUseCountTuple.useCount
        
        // Store rebuilt weapon in inventory
        let armorToStore: Armor = rebuildArmor(armorName: armorName, useCount: armorUseCount)
        armorInventoryToStore += [armorToStore]
    }
    return armorInventoryToStore
}

func rebuildArmorToStore(armorToStore: String) -> Armor {
    // Splitting currArmor + UseCount from a single string
    let currArmorUseCountTuple = splitObjAndUseCount(objWithUseCount: armorToStore)
    let currArmorName = currArmorUseCountTuple.objectName
    let currArmorUseCount: Int = currArmorUseCountTuple.useCount
    
    // Store rebuilt currWeapon in inventory
    let currArmorToStore: Armor = rebuildArmor(armorName: currArmorName, useCount: currArmorUseCount)
    return currArmorToStore
}

struct Leather: Armor {
    let name = "Leather"
    let armorClass = 11
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(wearerCharacterType: String) -> Bool{
        return wearerCharacterType == "Rogue" || wearerCharacterType == "Bard"
    }
}

struct Padding: Armor {
    let name = "Padding"
    let armorClass = 11
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(wearerCharacterType: String) -> Bool{
        return wearerCharacterType == "Rogue" || wearerCharacterType == "Bard"
    }
}

struct StuddedLeather: Armor {
    let name = "Studded Leather"
    let armorClass = 12
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(wearerCharacterType: String) -> Bool{
        return wearerCharacterType == "Rogue" || wearerCharacterType == "Bard"
    }
}

struct ChainMail: Armor {
    let name = "Chain Mail"
    let armorClass = 16
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Fighters can wear this armor
    func checkIfSuited(wearerCharacterType: String) -> Bool{
        return wearerCharacterType == "Fighter"
    }
}

struct Shield: Armor {
    var name = "Shield"
    var armorClass = 2
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Fighters can wear this armor
    func checkIfSuited(wearerCharacterType: String) -> Bool{
        return wearerCharacterType == "Fighter"
    }
}

struct NoArmor: Armor {
    var name = "No Armor"
    var armorClass = 0
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }

    func checkIfSuited(wearerCharacterType: String) -> Bool {
        return true
    }
}

// This function will return the modified armor class in case the wearer is ill-suited for their currArmor
func calculateModifiedArmorClass() -> Int {
    if(currTarget.armor.checkIfSuited(wearerCharacterType: currTarget.character_class)){
        return currTarget.armor.armorClass
    } else {
        let returnValue = rollDie(sides: currTarget.armor.armorClass, withAdvantage: currTarget.hasAdvantage, withDisadvantage: currTarget.hasDisadvantage)
        // Replace advantage and disadvantage back to false
        currTarget.hasAdvantage = false
        currTarget.hasDisadvantage = false
        return returnValue
    }
}

func adjustArmorCondition(armorUsed: inout Armor) -> Armor{
    armorUsed.useCount += 1
    let useCounter: Int = armorUsed.useCount
    
    // Condition of No Armor is forever
    guard !(armorUsed is NoArmor) else {
        if armorUsed.useCount > 95 {
            localCharacter.armorInInventory.removeAll { armor in
                armor.name == armorUsed.name && armorUsed.useCount > 95
            }
            let newArmor: Armor = NoArmor(useCount: 0)
            localCharacter.addToInventory(armorObject: newArmor)
            return newArmor
        }
        return armorUsed
    }
    
    // checks if conditionBoundary contains the useCount, if so change condition
    if conditionBoundary.contains(where: {$0.boundary == useCounter}) {
        // changingIndex holds the index in conditionBoundary with their previous condition of the weapon
        let targetIndex = conditionBoundary.firstIndex(where: {$0.boundary == useCounter})
        
        // new Condition is the new condition of weaponUsed
        let oldCondition: String = conditionBoundary[(targetIndex)!].condition
        
        // Set the condition Int in weaponUsed to new Int associated with the newCondition
        armorUsed.condition = (conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == oldCondition})!].intEquivalent) - 1
        
    } else if (useCounter >= 20){
        // Take action when weapon is deteriorated
        return destroyArmor(armorToDestroy: armorUsed)
    }
    return armorUsed
}

// destroys all armor in inventory that have this name and leaves you with no armor
func destroyArmor(armorToDestroy: Armor) -> Armor{
    currTarget.armorInInventory.removeAll { armor in
        armor.name == armorToDestroy.name && armor.useCount == 20
    }
    
    // if they already have 'no armor' in their armor inventory, wear it
    // if not, make them a new noArmor and put it in inventory
    if let noArmorIndexToEquip: Int = currTarget.armorInInventory.firstIndex(where: { armor in
        armor.name == "No Armor"
    }) {
        return currTarget.armorInInventory[noArmorIndexToEquip]
        
    } else {
        let newNoArmor: Armor = NoArmor()
        currTarget.armorInInventory += [newNoArmor]
        return newNoArmor
    }
}
