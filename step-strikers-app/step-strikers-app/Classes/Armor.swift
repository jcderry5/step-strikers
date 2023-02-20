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
    
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool
}

struct leather: Armor {
    let name = "Leather"
    let armorClass = 11
    var condition = 4
    var useCount = 0
    
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
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name = "Shield"
    var armorClass = 2
    var condition = 4
    var useCount = 0
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct noArmor: Armor {
    var name = "No Armor"
    var armorClass = 0
    var condition = 4
    var useCount = 0

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
    
    if !(armorUsed is noArmor) {
        armorUsed.useCount += 1
        // checks if conditionBoundary contains the useCount, if so change condition
        if conditionBoundary.contains(where: {$0.boundary == armorUsed.useCount}) {
            // changingIndex holds the index in conditionBoundary with the new condition of the weapon
            let changingIndex = conditionBoundary.firstIndex(where: {$0.boundary == armorUsed.useCount})
            
            // new Condition is the new condition of weaponUsed
            let newCondition: String = conditionBoundary[changingIndex!].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            armorUsed.condition = conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == newCondition})!].intEquivalent
        }
    }
    
}

// create all armor variables
let leatherArmor = leather()
let paddingArmor = padding()
let studdedLeatherArmor = studdedLeather()
let chainMailArmor = chainMail()
let shieldArmor = shield()
let noArmorArmor = noArmor()
