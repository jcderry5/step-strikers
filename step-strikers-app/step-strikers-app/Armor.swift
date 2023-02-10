//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//


protocol Armor {
    var name: String { get}
    var armorClass: Int {get}
    
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool
}


struct leather: Armor {
    let name = "Leather"
    let armorClass = 11
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard || potentialWearer is Fighter
    }
}

struct padding: Armor {
    let name = "Padding"
    let armorClass = 11
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
    let name = "Studded Leather"
    let armorClass = 12
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
    let name = "Chain Mail"
    let armorClass = 16
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name = "Shield"
    var armorClass = 2
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct noArmor: Armor {
    var name = "No Armor"
    var armorClass = 0
    
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool {
        return true
    }
}

// create all armor variables
let leatherArmor = leather()
let paddingArmor = padding()
let studdedLeatherArmor = studdedLeather()
let chainMailArmor = chainMail()
let shieldArmor = shield()
let noArmorArmor = noArmor()

