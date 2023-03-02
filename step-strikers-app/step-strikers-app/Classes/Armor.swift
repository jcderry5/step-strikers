//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//


protocol Armor {
    var name: String { get}
    var armorClass: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    init()
    init(useCount: Int)
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool
}

func rebuildArmor(armorName: String, useCount: Int) -> Armor{
    switch armorName {
    case "Leather":
        return leather(useCount: useCount)
    case "Padding":
        return padding(useCount: useCount)
    case "Studded Leather":
        return studdedLeather(useCount: useCount)
    case "Chain Mail":
        return chainMail(useCount: useCount)
    case "Shield":
        return shield(useCount: useCount)
    case "No Armor":
        return noArmor(useCount: useCount)
    default:
        return noArmor()
    }
}

struct leather: Armor {
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
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct padding: Armor {
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
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
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
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
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
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
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
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct noArmor: Armor {
    var name = "No Armor"
    var armorClass = 0
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }

    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool {
        return true
    }
}

func adjustArmorCondition(owner: inout RPGCharacter, armorUsed: inout Armor) -> Armor{
    armorUsed.useCount += 1
    let useCounter: Int = armorUsed.useCount
    // Condition of Fists is forever
        // checks if conditionBoundary contains the useCount, if so change condition
    if !(armorUsed is noArmor) {
        if conditionBoundary.contains(where: {$0.boundary == useCounter}) {
            // changingIndex holds the index in conditionBoundary with their previous condition of the weapon
            let targetIndex = conditionBoundary.firstIndex(where: {$0.boundary == useCounter})
            
            // new Condition is the new condition of weaponUsed
            let oldCondition: String = conditionBoundary[(targetIndex)!].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            armorUsed.condition = (conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == oldCondition})!].intEquivalent) - 1
            
        } else if (useCounter >= 20){
            // Take action when weapon is deteriorated
            return destroyArmor(owner: &owner, armorToDestroy: armorUsed)
        }
    }
    return armorUsed
}

// destroys all armor in inventory that have this name and leaves you with no armor
func destroyArmor(owner: inout RPGCharacter, armorToDestroy: Armor) -> Armor{
    owner.armorInInventory.removeAll { armor in
        armor.name == armorToDestroy.name && armor.useCount == 20
    }
    
    // if they already have 'no armor' in their armor inventory, wear it
    // if not, make them a new noArmor and put it in inventory
    if let noArmorIndexToEquip: Int = owner.armorInInventory.firstIndex(where: { armor in
        armor.name == "No Armor"
    }) {
        return owner.armorInInventory[noArmorIndexToEquip]
        
    } else {
        let newNoArmor: Armor = noArmor()
        owner.armorInInventory += [newNoArmor]
        return newNoArmor
    }
}
