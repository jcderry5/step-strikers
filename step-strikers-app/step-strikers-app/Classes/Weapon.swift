//
//  Weapon.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//
// TODO: Half damage for non-class weapons

import Foundation

protocol Weapon {
    var name: String {get}
    var damage: Int {get}
    var staminaCost: Int {get}
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool
}

struct fists: Weapon {
    let name = "Fists"
    let damage = 2
    let staminaCost = 1
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct dagger: Weapon {
    let name = "Dagger"
    let damage = 4
    let staminaCost = 3
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct darts: Weapon {
    let name = "Darts"
    let damage = 5
    let staminaCost = 4
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct crossBow: Weapon {
    let name = "Cross Bow"
    let damage = 8
    let staminaCost = 5

    // Anyone can equip a crossbow
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct rapier: Weapon {
    let name = "Rapier"
    let damage = 8
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue || wearer is Bard
    }
}

struct shortSword: Weapon {
    let name = "Short Sword"
    let damage = 6
    let staminaCost = 4
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue
    }
}

struct longBow: Weapon {
    let name = "Long Bow"
    let damage = 8
    let staminaCost = 6

    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct handAxe: Weapon {
    let name = "Hand Axe"
    let damage = 6
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct battleAxe: Weapon {
    let name = "Battle Axe"
    let damage = 10
    let staminaCost = 8
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct longSword: Weapon {
    let name = "Long Sword"
    let damage = 8
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Bard
    }
}

// This function will calculate the damage that the wielder imposes on their target, given their proficiency in their currWeapon and the target's currArmor suitability.
// proficient wielder def: The weapon is assigned to their class, they roll with the weapon's damage
func calculateDamage(wielder: RPGCharacter, target: RPGCharacter, damage: Int) -> Int {
    // If they are a proficient wielder
    // Check if your target is wearing suited armor
    var armorClassToBeat = modifyArmorClass(wearer: target)
    // TODO: Check with team if modifiers are persitant
    if(rollDie(quant: 1, sides: 20) + wielder.attackModifier >= armorClassToBeat + target.defenseModifier) {
        // check if wielder is proficient in their weapon
        return modifyDamage(wielder: wielder)
    } else {
        return 0 // if wielder does not beat the character's AC, they do not inflict damage upon themc
    }
}

// Returns the amount of damage wielder imposes with their weapon taking into account their proficiency in the weapon
func modifyDamage(wielder: RPGCharacter) -> Int{
    if(wielder.currWeapon.checkIfProficient(wearer: wielder)){
        return wielder.currWeapon.damage
    } else {
        return rollDie(quant: 1, sides: wielder.currWeapon.damage)
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
