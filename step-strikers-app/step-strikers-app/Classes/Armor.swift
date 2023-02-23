//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//


protocol Armor {
    var name: String { get}
    var owner: RPGCharacter {get set}
    var armorClass: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    init(owner: RPGCharacter)
    init(owner:RPGCharacter, useCount: Int, condition: Int)
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool
}

struct leather: Armor {
    let name = "Leather"
    var owner: RPGCharacter
    let armorClass = 11
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct padding: Armor {
    let name = "Padding"
    var owner: RPGCharacter
    let armorClass = 11
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
    let name = "Studded Leather"
    var owner: RPGCharacter
    let armorClass = 12
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
    let name = "Chain Mail"
    var owner: RPGCharacter
    let armorClass = 16
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }
    
    // Only Fighters can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name = "Shield"
    var owner: RPGCharacter
    var armorClass = 2
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }
    
    // Only Fighters can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct noArmor: Armor {
    var name = "No Armor"
    var owner: RPGCharacter
    var armorClass = 0
    var condition = 4
    var useCount = 0
    
    init(owner: RPGCharacter){
        self.owner = owner
    }
    
    init(owner: RPGCharacter, useCount: Int, condition: Int) {
        self.owner = owner
        self.useCount = useCount
        self.condition = condition
    }

    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool {
        return true
    }
}

// This function will return the modified armor class in case the wearer is ill-suited for their currArmor
func calculateModifiedArmorClass(wearer: RPGCharacter) -> Int {
    if(wearer.currArmor.checkIfSuited(potentialWearer: wearer)){
        return wearer.currArmor.armorClass
    } else {
        return rollDie(quant: 1, sides: wearer.currArmor.armorClass)
    }
}

func adjustCondition(armorUsed: inout Armor){
    armorUsed.useCount += 1
    let useCounter: Int = armorUsed.useCount
    // Condition of Fists is forever
        // checks if conditionBoundary contains the useCount, if so change condition
    if !(armorUsed is noArmor) {
        if conditionBoundary.contains(where: {$0.boundary == useCounter}) {
            // changingIndex holds the index in conditionBoundary with their previous condition of the weapon
            let changingIndex = conditionBoundary.firstIndex(where: {$0.boundary == useCounter})
            
            // new Condition is the new condition of weaponUsed
            let newCondition: String = conditionBoundary[(changingIndex)!].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            armorUsed.condition = conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == newCondition})!].intEquivalent
        } else if (useCounter >= 20){
            // Take action when weapon is deteriorated
            destroyArmor(armorToDestroy: armorUsed)
        }
    }
}

//
func destroyArmor(armorToDestroy: Armor){
    let owner = armorToDestroy.owner
    owner.armorInInventory.removeAll { armor in
        armor.name == armorToDestroy.name && armor.useCount == 20
    }
    
    // if they already have 'no armor' in their armor inventory, wear it
    // if not, make them a new noArmor and put it in inventory
    if let noArmorIndexToEquip: Int = owner.armorInInventory.firstIndex(where: { armor in
        armor.name == "No Armor"
    }) {
        owner.currArmor = owner.armorInInventory[noArmorIndexToEquip]
    } else {
        let newNoArmor: Armor = noArmor(owner: owner)
        owner.currArmor = newNoArmor
        owner.armorInInventory += [newNoArmor]
    }
}
