//
//  Weapon.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//

import Foundation

let conditionBoundary = [
    (condition: "Perfect", boundary: 5),
    (condition: "Good", boundary: 10),
    (condition: "Fair", boundary: 15)]

let conditionIntEquivalent = [
    (condition: "Perfect", intEquivalent: 4),
    (condition: "Good", intEquivalent: 3),
    (condition: "Fair", intEquivalent: 2)]
let maxWeaponUses = 20

protocol Weapon {
    var name: String {get}
    var owner: RPGCharacter {get set}
    var damage: Int {get}
    var staminaCost: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    init(owner: RPGCharacter)
    init(owner:RPGCharacter, useCount: Int, condition: Int)
    func checkIfProficient(wearer: RPGCharacter) -> Bool
}

struct fists: Weapon {
    let name = "Fists"
    var owner: RPGCharacter
    let damage = 2
    let staminaCost = 1
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct dagger: Weapon {
    let name = "Dagger"
    var owner: RPGCharacter
    let damage = 4
    let staminaCost = 3
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct darts: Weapon {
    let name = "Darts"
    var owner: RPGCharacter
    let damage = 5
    let staminaCost = 4
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct crossBow: Weapon {
    let name = "Cross Bow"
    var owner: RPGCharacter
    let damage = 8
    let staminaCost = 5
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
    
    // Anyone can equip a crossbow
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct rapier: Weapon {
    let name = "Rapier"
    var owner: RPGCharacter
    let damage = 8
    let staminaCost = 5
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue || wearer is Bard
    }
}

struct shortSword: Weapon {
    let name = "Short Sword"
    var owner: RPGCharacter
    let damage = 6
    let staminaCost = 4
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue
    }
}

struct longBow: Weapon {
    let name = "Long Bow"
    var owner: RPGCharacter
    let damage = 8
    let staminaCost = 6
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

    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct handAxe: Weapon {
    let name = "Hand Axe"
    var owner: RPGCharacter
    let damage = 6
    let staminaCost = 5
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct battleAxe: Weapon {
    let name = "Battle Axe"
    var owner: RPGCharacter
    let damage = 10
    let staminaCost = 8
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct longSword: Weapon {
    let name = "Long Sword"
    var owner: RPGCharacter
    let damage = 8
    let staminaCost = 5
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
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Bard
    }
}

// This function will calculate the damage that the wielder imposes on their target, given their proficiency in their currWeapon and the target's currArmor suitability.
// proficient wielder def: The weapon is assigned to their class, they roll with the weapon's damage
func calculateDamage(wielder: RPGCharacter, target: RPGCharacter, damage: Int) -> Int {
    let damage: Int
    var armorClassToBeat = calculateModifiedArmorClass(wearer: target)
    
    // D20 + wielders attackModifer vs target's armorClass + target's defenseModifier
    if(rollDie(quant: 1, sides: 20) + wielder.attackModifier >= armorClassToBeat + target.defenseModifier) {
        // check if wielder is proficient in their weapon
        damage = calculateModifiedDamage(wielder: wielder)
    } else {
        damage = 0 // if wielder does not beat the character's AC, they do not inflict damage upon them
    }
    // reset attack and defense modifier after interaction
    wielder.attackModifier = 0
    target.defenseModifier = 0
    
    // adjust the condition of the wielder's weapon and the target's armor
    adjustCondition(armorUsed: &target.currArmor)
    adjustCondition(weaponUsed: &wielder.currWeapon)
    
    return damage
}

// Returns the amount of damage wielder imposes with their weapon taking into account their proficiency in the weapon
func calculateModifiedDamage(wielder: RPGCharacter) -> Int{
    if(wielder.currWeapon.checkIfProficient(wearer: wielder)){
        return wielder.currWeapon.damage
    } else {
        return rollDie(quant: 1, sides: wielder.currWeapon.damage)
    }
}

func adjustCondition(weaponUsed: inout Weapon){
    weaponUsed.useCount += 1
    let useCounter: Int = weaponUsed.useCount
    // Condition of Fists is forever
        // checks if conditionBoundary contains the useCount, if so change condition
    if !(weaponUsed is fists) {
        if conditionBoundary.contains(where: {$0.boundary == useCounter}) {
            // changingIndex holds the index in conditionBoundary with their previous condition of the weapon
            let changingIndex = conditionBoundary.firstIndex(where: {$0.boundary == useCounter})
            
            // new Condition is the new condition of weaponUsed
            let newCondition: String = conditionBoundary[(changingIndex)!].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            weaponUsed.condition = conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == newCondition})!].intEquivalent
        } else if (useCounter >= 20){
            // Take action when weapon is deteriorated
            destroyWeapon(weaponToDestroy: weaponUsed)
        }
    }
}

// destroys all weapons in inventory that have this name and disarms you
func destroyWeapon(weaponToDestroy: Weapon){
    let owner = weaponToDestroy.owner
    owner.weaponsInInventory.removeAll { weapon in
        weapon.name == weaponToDestroy.name && weapon.useCount == 20
    }
    
    // if they already have fists in their weapons inventory, equip it
    // if not, make them a new fists and put it in inventory
    if let fistIndexToEquip: Int = owner.weaponsInInventory.firstIndex(where: { weapon in
        weapon.name == "Fists"
    }) {
        owner.currWeapon = owner.weaponsInInventory[fistIndexToEquip]
    } else {
        let newFists: Weapon = fists(owner: owner)
        owner.currWeapon = newFists
        owner.weaponsInInventory += [newFists]
    }
}
