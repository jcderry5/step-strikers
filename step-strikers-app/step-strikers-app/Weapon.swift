//
//  Weapon.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//
// TODO: Half damage for non-class weapons

import Foundation

func calculateDamage(wielder: RPGCharacter, target: RPGCharacter, damage: Int) -> Int {
    // If you are a proficient wielder (This weapon is assigned to your class, you roll with weapon's damage)
    // Check if your target is wearing suited armor
    var armorClassToBeat = modifyArmorClass(wearer: target)
    if(rollDie(quant: 1, sides: 20) >= armorClassToBeat) {
        // check if wielder is proficient in their weapon
        return modifyDamage(wielder: wielder)
    }
    
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
    
}

struct fists: Weapon {
    let name = "Fists"
    let damage = 2
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
    
}

struct dagger: Weapon {
    let name = "Dagger"
    let damage = 4
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct darts: Weapon {
    let name = "Darts"
    let damage = 5
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Wizard
    }
}

struct crossBow: Weapon {
    let name = "Cross Bow"
    let damage = 8
    
    // Anyone can equip a crossbow
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return true
    }
}

struct rapier: Weapon {
    let name = "Rapier"
    let damage = 8
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue || wearer is Bard
    }
}

struct shortSword: Weapon {
    let name = "Short Sword"
    let damage = 6
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Rogue
    }
}

struct longBow: Weapon {
    let name = "Long Bow"
    let damage = 8
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct handAxe: Weapon {
    let name = "Hand Axe"
    let damage = 6
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct battleAxe: Weapon {
    let name = "Battle Axe"
    let damage = 10
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Fighter
    }
}

struct longSword: Weapon {
    let name = "Long Sword"
    let damage = 8
    
    func checkIfProficient(wearer: RPGCharacter) -> Bool {
        return wearer is Bard
    }
}

// create all weapons
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
