//
//  Weapon.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//
// TODO: Half damage for non-class weapons

import Foundation

<<<<<<< HEAD
<<<<<<< HEAD
protocol Weapon {
    var name: String {get}
    var damage: Int {get}
    var staminaCost: Int {get}
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool
=======
func calculateDamage(target: RPGCharacter, damage: Int) -> Int {
=======
func calculateDamage(wielder: RPGCharacter, target: RPGCharacter, damage: Int) -> Int {
    // If you are a proficient wielder (This weapon is assigned to your class, you roll with weapon's damage)
    // Check if your target is wearing suited armor
    var armorClassToBeat = modifyArmorClass(wearer: target)
    if(rollDie(quant: 1, sides: 20) >= armorClassToBeat) {
        // check if wielder is proficient in their weapon
        return modifyDamage(wielder: wielder)
    }
    
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
    if (rollDie(quant: 1, sides: 20) >= target.currArmor.armorClass){
        return rollDie(quant: 1, sides: damage)
    } else {
        // This is a non wielder,
        return 0
    }
}

func modifyDamage(wielder: RPGCharacter) -> Int{
    if(wielder.currWeapon.checkIfProficient(wearer: wielder)){
        return wielder.currWeapon.damage
    } else {
        return rollDie(quant: 1, sides: wielder.currWeapon.damage)
    }
}

protocol Weapon {
    var name: String {get}
    var damage: Int {get}
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool
    
>>>>>>> Made all armor and weapons
}

struct fists: Weapon {
    let name = "Fists"
    let damage = 2
<<<<<<< HEAD
    let staminaCost = 1
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
=======
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
    
>>>>>>> Made all armor and weapons
}

struct dagger: Weapon {
    let name = "Dagger"
    let damage = 4
<<<<<<< HEAD
    let staminaCost = 3
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Wizard
    }
}

struct darts: Weapon {
    let name = "Darts"
    let damage = 5
<<<<<<< HEAD
    let staminaCost = 4
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Wizard
    }
}

struct crossBow: Weapon {
    let name = "Cross Bow"
    let damage = 8
<<<<<<< HEAD
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
    // Anyone can equip a crossbow
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return true
    }
}

struct rapier: Weapon {
    let name = "Rapier"
    let damage = 8
<<<<<<< HEAD
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Rogue || wearer is Bard
    }
}

struct shortSword: Weapon {
    let name = "Short Sword"
    let damage = 6
<<<<<<< HEAD
    let staminaCost = 4
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Rogue
    }
}

struct longBow: Weapon {
    let name = "Long Bow"
    let damage = 8
<<<<<<< HEAD
    let staminaCost = 6
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Fighter
    }
}

struct handAxe: Weapon {
    let name = "Hand Axe"
    let damage = 6
<<<<<<< HEAD
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Fighter
    }
}

struct battleAxe: Weapon {
    let name = "Battle Axe"
    let damage = 10
<<<<<<< HEAD
    let staminaCost = 8
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Fighter
    }
}

struct longSword: Weapon {
    let name = "Long Sword"
    let damage = 8
<<<<<<< HEAD
    let staminaCost = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
=======
    
<<<<<<< HEAD
    func checkCanEquip(wearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return wearer is Bard
    }
}

<<<<<<< HEAD
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
=======
// create all weapons
>>>>>>> Made all armor and weapons
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
