//
//  Weapon.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//

import Foundation

// [0-5) uses = Perfect Condition
// [5-10) uses = Good Condition
// [10-15) uses = Fair Condition
// [15-20) uses = Poor Condition
// On their 20th use, the weapon vanishes

let conditionBoundary = [
    (condition: "Perfect", boundary: 5),
    (condition: "Good", boundary: 10),
    (condition: "Fair", boundary: 15)]

let conditionIntEquivalent = [
    (condition: "Perfect", intEquivalent: 4),
    (condition: "Good", intEquivalent: 3),
    (condition: "Fair", intEquivalent: 2),
    (condition: "Poor", intEquivalent: 1)]

let maxWeaponUses = 20

let allWeapons: [String] = ["Fists","Dagger","Darts","Cross Bow","Rapier","Short Sword","Long Bow","Hand Axe","Battle Axe","Long Sword"]

protocol Weapon {
    var name: String {get}
    var damage: Int {get}
    var staminaCost: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    init()
    init(useCount: Int)
    func checkIfProficient(wielderClass: String) -> Bool
}

func getWeaponStrings(weapons:[Weapon]) -> [String] {
    var weaponStrings = [String]()
    for weapon in weapons {
        weaponStrings.append(getConstructedName(weapon: weapon))
    }
    
    return weaponStrings
}

func getConstructedName(weapon:Weapon) -> String {
    var constructedName = ""
    if(weapon.useCount < 10){
        constructedName += "0\(weapon.useCount)"
    } else {
        constructedName += "\(weapon.useCount)"
    }
    constructedName += weapon.name
    
    return constructedName
}

// MARK: - Initialization Helper Functions
func getConditionFromUseCount(useCount: Int) -> Int {
    if(useCount >= 0 && useCount < 5) {
        return 4
    } else if (useCount >= 5 && useCount < 10) {
        return 3
    } else if (useCount >= 10 && useCount < 15) {
        return 2
    } else if (useCount >= 15 && useCount < 20) {
        return 1
    } else {
        return -1
    }
}

func rebuildWeapon(weaponName: String, useCount: Int) -> Weapon {
    switch weaponName {
    case "Fists":
        return Fists(useCount: useCount)
    case "Dagger":
        return Dagger(useCount: useCount)
    case "Darts":
        return Darts(useCount: useCount)
    case "Cross Bow":
        return CrossBow(useCount: useCount)
    case "Rapier":
        return Rapier(useCount: useCount)
    case "Short Sword":
        return ShortSword(useCount: useCount)
    case "Long Bow":
        return LongBow(useCount: useCount)
    case "Hand Axe":
        return HandAxe(useCount: useCount)
    case "Battle Axe":
        return BattleAxe(useCount: useCount)
    case "Long Sword":
        return LongSword(useCount: useCount)
    default:
        return Fists()
    }
}

func rebuildWeaponInventory(weaponInventory: [String]) -> [Weapon] {
    var weaponInventoryToStore: [Weapon] = []
    // Rebuild all weapons and add them to inventory
    for weapon in weaponInventory {
        // Splitting Weapon + UseCount from a single string
        let weaponUseCountTuple = splitObjAndUseCount(objWithUseCount: weapon)
        let weaponName = weaponUseCountTuple.objectName
        let weaponUseCount: Int = weaponUseCountTuple.useCount
        
        // Store rebuilt weapon in inventory
        let weaponToStore: Weapon = rebuildWeapon(weaponName: weaponName, useCount: weaponUseCount)
        weaponInventoryToStore += [weaponToStore]
    }
    return weaponInventoryToStore
}

func rebuildWeaponToStore(currWeapon: String) -> Weapon {
    // Splitting currWeapon + UseCount from a single string
    let currWeaponUseCountTuple = splitObjAndUseCount(objWithUseCount: currWeapon)
    let currWeaponName = currWeaponUseCountTuple.objectName
    let currWeaponUseCount: Int = currWeaponUseCountTuple.useCount
    
    // Store rebuilt currWeapon in inventory
    return rebuildWeapon(weaponName: currWeaponName, useCount: currWeaponUseCount)
}
// MARK: - Weapon structs
struct Fists: Weapon {
    let name = "Fists"
    let damage = 2
    let staminaCost = 0
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    func checkIfProficient(wielderClass: String) -> Bool {
        return true
    }
}

struct Dagger: Weapon {
    let name = "Dagger"
    let damage = 4
    let staminaCost = 3
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Wizards can wield daggers
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Wizard"
    }
}

struct Darts: Weapon {
    let name = "Darts"
    let damage = 5
    let staminaCost = 4
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Wizards can wield darts
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Wizard"
    }
}

struct CrossBow: Weapon {
    let name = "Cross Bow"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Anyone can equip a crossbow
    func checkIfProficient(wielderClass: String) -> Bool {
        return true
    }
}

struct Rapier: Weapon {
    let name = "Rapier"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Rogues and Bards are proficient
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Rogue" || wielderClass == "Bard"
    }
}

struct ShortSword: Weapon {
    let name = "Short Sword"
    let damage = 6
    let staminaCost = 4
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Rogues can wield short sword
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Rogue"
    }
}

struct LongBow: Weapon {
    let name = "Long Bow"
    let damage = 8
    let staminaCost = 6
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }

    // Only Fighters can wield long bow
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Fighter"
    }
}

struct HandAxe: Weapon {
    let name = "Hand Axe"
    let damage = 6
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only Fighters can wield hand axe
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Fighter"
    }
}

struct BattleAxe: Weapon {
    let name = "Battle Axe"
    let damage = 10
    let staminaCost = 8
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only fighters can wield battle axe
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Fighter"
    }
}

struct LongSword: Weapon {
    let name = "Long Sword"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    init() {}
    
    init(useCount: Int) {
        self.useCount = useCount
        self.condition = getConditionFromUseCount(useCount: useCount)
    }
    
    // Only bards can wield long sword
    func checkIfProficient(wielderClass: String) -> Bool {
        return wielderClass == "Bard"
    }
}

// MARK: - Condition functions
func adjustWeaponCondition(ownerWeaponsInventory: inout [Weapon], currWeaponPointer: UnsafePointer<Weapon>) -> Weapon {
    
    var currWeapon = currWeaponPointer.pointee
    currWeapon.useCount += 1
    
    let useCounter: Int = currWeapon.useCount
    
    // Condition of Fists is forever
        // checks if conditionBoundary contains the useCount, if so change condition
    if !(currWeapon is Fists) {
        if conditionBoundary.contains(where: {$0.boundary == useCounter}) {
            // changingIndex holds the index in conditionBoundary with their previous condition of the weapon
            let targetIndex = (conditionBoundary.firstIndex(where: {$0.boundary == useCounter}) ?? 0)
            
            // new Condition is the new condition of weaponUsed
            let oldCondition: String = conditionBoundary[(targetIndex)].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            currWeapon.condition = (conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == oldCondition})!].intEquivalent) - 1
        } else if (useCounter >= 20){
            // Take action when weapon is deteriorated and return your fists
            return destroyWeapon(ownerWeaponsInventory: &ownerWeaponsInventory, weaponToDestroy: currWeapon)
        }
    }
    return currWeapon
}

// destroys all weapons in inventory that have this name and disarms you
func destroyWeapon(ownerWeaponsInventory: inout [Weapon], weaponToDestroy: Weapon) -> Weapon {
    ownerWeaponsInventory.removeAll { weapon in
        weapon.name == weaponToDestroy.name && weapon.useCount == 20
    }
    
    // if they already have fists in their weapons inventory, equip it
    // if not, make them a new fists and put it in inventory
    if let fistIndexToEquip: Int = ownerWeaponsInventory.firstIndex(where: { weapon in
        weapon.name == "Fists"
    }) {
        return ownerWeaponsInventory[fistIndexToEquip]
    } else {
        let newFists: Weapon = Fists()
        ownerWeaponsInventory += [newFists]
        return newFists
    }
}

// Remove the first instance of weaponToRemove that has the same name and useCount
func removeWeaponFromInventory(weaponToRemove: Weapon, weaponInventory: inout [Weapon]) {
    if weaponInventory.contains(where: { weapon in weapon.name == weaponToRemove.name && weapon.useCount == weaponToRemove.useCount }) {
        let indexToRemove: Int = weaponInventory.firstIndex(where: {
            weapon in weapon.name == weaponToRemove.name && weapon.useCount == weaponToRemove.useCount
        })!
        weaponInventory.remove(at: indexToRemove)
    }
}
