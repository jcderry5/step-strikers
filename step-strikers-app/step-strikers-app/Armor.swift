//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> Add base code of armor and rpgcharacter
protocol Armor {
    var name: String { get}
    var armorClass: Int {get}
    
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool
=======

protocol Armor {
    var name: String { get}
    var armorClass: Int {get}
    
<<<<<<< HEAD
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool
>>>>>>> Added all armors
=======
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
}

// This function will return the modified armor class in case the wearer is ill-suited for their currArmor
func modifyArmorClass(wearer: RPGCharacter) -> Int {
    if(wearer.currArmor.checkIfSuited(potentialWearer: wearer)){
        return wearer.currArmor.armorClass
    } else {
        return rollDie(quant: 1, sides: wearer.currArmor.armorClass)
    }
}

struct leather: Armor {
<<<<<<< HEAD
<<<<<<< HEAD
    let name = "Leather"
    let armorClass = 11
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
<<<<<<< HEAD
        return potentialWearer is Rogue || potentialWearer is Bard || potentialWearer is Fighter
    }
}

struct padding: Armor {
    let name = "Padding"
    let armorClass = 11
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
    let name = "Studded Leather"
    let armorClass = 12
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
    let name = "Chain Mail"
    let armorClass = 16
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
=======
    var name: String
    var armorClass: Int
    
    init(){
        name = "Leather"
        armorClass = 11
    }
=======
    let name = "Leather"
    let armorClass = 11
>>>>>>> Made all armor and weapons
    
    // Only Rogues and Bards can wear this armor
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
=======
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return potentialWearer is Rogue || potentialWearer is Bard || potentialWearer is Fighter
    }
}

struct padding: Armor {
    let name = "Padding"
    let armorClass = 11
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct studdedLeather: Armor {
    let name = "Studded Leather"
    let armorClass = 12
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Rogue || potentialWearer is Bard
    }
}

struct chainMail: Armor {
    let name = "Chain Mail"
    let armorClass = 16
    
    // Only Rogues and Bards can wear this armor
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name = "Shield"
    var armorClass = 2
    
    // Only Rogues and Bards can wear this armor
<<<<<<< HEAD
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool{
>>>>>>> Added all armors
        return potentialWearer is Fighter
    }
}

struct shield: Armor {
    var name = "Shield"
    var armorClass = 2
    
    // Only Rogues and Bards can wear this armor
=======
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool{
        return potentialWearer is Fighter
    }
}

struct noArmor: Armor {
    var name = "No Armor"
    var armorClass = 0
    
<<<<<<< HEAD
<<<<<<< HEAD
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool {
=======
    func checkCanEquip(potentialWearer: RPGCharacter) -> Bool {
>>>>>>> Made all armor and weapons
=======
    func checkIfSuited(potentialWearer: RPGCharacter) -> Bool {
>>>>>>> Adding ill-suited armor and non-proficient weapon wielding functionality
        return true
    }
}

<<<<<<< HEAD
// This function will return the modified armor class in case the wearer is ill-suited for their currArmor
func modifyArmorClass(wearer: RPGCharacter) -> Int {
    if(wearer.currArmor.checkIfSuited(potentialWearer: wearer)){
        return wearer.currArmor.armorClass
    } else {
        return rollDie(quant: 1, sides: wearer.currArmor.armorClass)
    }
}
<<<<<<< HEAD

=======
>>>>>>> Made all armor and weapons
// create all armor variables
let leatherArmor = leather()
let paddingArmor = padding()
let studdedLeatherArmor = studdedLeather()
let chainMailArmor = chainMail()
let shieldArmor = shield()
let noArmorArmor = noArmor()

<<<<<<< HEAD
=======
import Foundation
>>>>>>> Created Armor.swift
=======
>>>>>>> Add base code of armor and rpgcharacter
=======
>>>>>>> Made all armor and weapons
