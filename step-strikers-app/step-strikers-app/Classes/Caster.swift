//
//  Caster.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/25/23.
//

import Foundation
import FirebaseFirestore

class Caster: RPGCharacter {
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    // Rolling modifier
    var spellModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item], inventoryQuantities: [String:Int]) {
        self.currSpellPoints = spellPoints
        self.maxSpellPoints = spellPoints
        super.init(characterName: characterName, userName: userName, health: health,
                   stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory, inventoryQuantities: inventoryQuantities)
    }
    
    func increaseSpellPoints(amtIncrease: Int){
        self.currSpellPoints += amtIncrease
        if(self.currSpellPoints > maxSpellPoints){
            self.currSpellPoints = maxSpellPoints
        }
    }
    
    func decreaseSpellPoints(amtDecrease: Int){
        self.currSpellPoints -= amtDecrease
        self.currSpellPoints = self.currSpellPoints < 0 ? 0 : self.currSpellPoints
    }
    
    func castMageHand(rollValue: Int) {
        decreaseSpellPoints(amtDecrease: 20)
        
        guard currTarget.character_class != "Fighter" else {
            let message = "\(self.characterName) tried using Mage Hand to take \(currTarget.armor.name) from \(currTarget.name), but Fighters are too strong to take their weapon!"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        guard currTarget.currWeapon.name != "Fists" else {
            let message = "\(self.characterName) attempted to use Mage Hand to steal \(currTarget.currWeapon.name) from \(currTarget.name). However, dismemberment is not possible."
            messageLog.addToMessageLog(message: message)
            return
        }
        
        guard didSpellHit(rollValue: rollValue) else {
            let message = "\(self.characterName) failed in using Mage Hand to take \(currTarget.armor.name) from \(currTarget.name)"
            messageLog.addToMessageLog(message: message)
            return
        }
        
        // Give the target's currWeapon to localCharacter
        localCharacter.addToInventory(weaponObject: currTarget.currWeapon)
        localCharacter.wield(weaponObject: currTarget.currWeapon)
        
        // Remove the weapon from target's inventory and give them fists instead
        removeWeaponFromInventory(weaponToRemove: currTarget.currWeapon, weaponInventory: &currTarget.weaponInventory)
        // If they have fists in their inventory, equip them, else recreate fists
        if (currTarget.weaponInventory.contains(where: { weapon in weapon.name == "Fists" })) {
            currTarget.currWeapon = currTarget.weaponInventory.first(where: { weapon in weapon.name == "Fists" })!
        } else {
            let newFists = fists()
            currTarget.currWeapon = newFists
            currTarget.weaponInventory.append(newFists)
        }
    }
}

func splitObjAndUseCount(objWithUseCount: String) -> (useCount: Int, objectName: String) {
    // Get useCount
    let useCountAsString = objWithUseCount.prefix(2)
    let useCountInt: Int = Int(useCountAsString)!
    
    // Get the object name
    let object: String = String(objWithUseCount.dropFirst(2))
    return (useCount: useCountInt, objectName: object)
}

func didSpellHit(rollValue: Int) -> Bool{
    return (rollValue + localCharacter.attackModifier > currTarget.modifiedArmorClass + currTarget.magicResistanceModifier)
}
