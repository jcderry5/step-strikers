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
    var damage: Int {get}
    var staminaCost: Int {get}
    var condition: Int {get set}
    var useCount: Int {get set}
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool
}

struct fists: Weapon {
    let name = "Fists"
    let damage = 2
    let staminaCost = 1
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct dagger: Weapon {
    let name = "Dagger"
    let damage = 4
    let staminaCost = 3
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct darts: Weapon {
    let name = "Darts"
    let damage = 5
    let staminaCost = 4
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct crossBow: Weapon {
    let name = "Cross Bow"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0

    // Anyone can equip a crossbow
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct rapier: Weapon {
    let name = "Rapier"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue || wearer is Bard
    }
}

struct shortSword: Weapon {
    let name = "Short Sword"
    let damage = 6
    let staminaCost = 4
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue
    }
}

struct longBow: Weapon {
    let name = "Long Bow"
    let damage = 8
    let staminaCost = 6
    var condition = 4
    var useCount = 0

    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct handAxe: Weapon {
    let name = "Hand Axe"
    let damage = 6
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct battleAxe: Weapon {
    let name = "Battle Axe"
    let damage = 10
    let staminaCost = 8
    var condition = 4
    var useCount = 0
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct longSword: Weapon {
    let name = "Long Sword"
    let damage = 8
    let staminaCost = 5
    var condition = 4
    var useCount = 0
    
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
    
    // Condition of Fists is forever
    if !(weaponUsed is fists) {
        // checks if conditionBoundary contains the useCount, if so change condition
        if conditionBoundary.contains(where: {$0.boundary == weaponUsed.useCount}) {
            // changingIndex holds the index in conditionBoundary with the new condition of the weapon
            let changingIndex = conditionBoundary.firstIndex(where: {$0.boundary == weaponUsed.useCount})
            
            // new Condition is the new condition of weaponUsed
            let newCondition: String = conditionBoundary[changingIndex!].condition
            
            // Set the condition Int in weaponUsed to new Int associated with the newCondition
            weaponUsed.condition = conditionIntEquivalent[conditionIntEquivalent.firstIndex(where: {$0.condition == newCondition})!].intEquivalent
        }
    }
}







// create all weapon variables
let fistsWeapon = fists()
let daggerWeapon = dagger()
let dartsWeapon = darts()
let crossBowWeapon = crossBow()
let rapierWeapon = rapier()
let shortSwordWeapon = shortSword()
let longBowWeapon = longBow()
let handAxeWeapon = handAxe()
let battleAxeWeapon = battleAxe()
let longSwordWeapon = longSword()
