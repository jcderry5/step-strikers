//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//


protocol Armor {
    var name: String { get set}
    var armorClass: Int {get set}
    
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool
}


struct leather: Armor {
    var name: String
    var armorClass: Int
    
    init(){
        name = "Leather"
        armorClass = 11
    }
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard || potentialWearer is Fighter
    }
}

struct padding: Armor {
    var name: String
    var armorClass: Int
    
    init() {
        name = "Padding"
        armorClass = 11
    }
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
    var name: String
    var armorClass: Int
    
    init() {
        name = "Studded Leather"
        armorClass = 12
    }
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
    var name: String
    var armorClass: Int
    
    init() {
        name = "Chain Mail"
        armorClass = 16
    }
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name: String
    var armorClass: Int
    
    init() {
        name = "Shield"
        armorClass = 2
    }
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}
