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
    }
    
    func castFrostbite(caster: String, target: String) {
//        damageOpponent(target: target, damage: 1)
        decreaseSpellPoints(amtDecrease: 3)
        
        let message = "\(self.characterName) cast frosbite on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castMageHand(caster: String, target: String) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // get info about target's current weapon
                let weaponWithUseCount = document.get("current_weapon") as! String
                
                // update target info on firebase
                Firestore.firestore().collection("players").document(target).updateData([
                    "weapon_inventory": FieldValue.arrayRemove([weaponWithUseCount])])
                Firestore.firestore().collection("players").document(target).setData(["current_weapon": "fists"], merge: true)
                
                // Splitting Weapon + UseCount from a single string
                let weaponUseCountTuple = splitObjAndUseCount(objWithUseCount: weaponWithUseCount)
                let weaponName = weaponUseCountTuple.objectName
                let useCount: Int = weaponUseCountTuple.useCount
                
                // update own info locally -> initialize new weapon, add to self's inventory, equip it
                let newWeapon = rebuildWeapon(weaponName: weaponName, useCount: useCount)
                self.addToInventory(weaponObject: newWeapon)
                self.wield(weaponObject: newWeapon)

            }
        }
        decreaseSpellPoints(amtDecrease: 20)
        
        let message = "\(self.characterName) cast mage hand on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castShield(caster: String, target: String) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentModifier = document.get("defense_modifier") as! Int
                Firestore.firestore().collection("players").document(target).setData(["defense_modifier": currentModifier + 5], merge: true)
            }
        }

        decreaseSpellPoints(amtDecrease: 4)

        let message = "\(self.characterName) cast shield on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castBardicInspiration(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["has_advantage": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 7)
        
        let message = "\(self.characterName) cast bardic inspiration on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castViciousMockery(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["has_disadvantage": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 7)
        
        let message = "\(self.characterName) cast vicious mockery on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castBlindness(caster: String, target: String, game: String) {
        Firestore.firestore().collection("players").document(target).setData(["is_blind": true], merge: true)
        Firestore.firestore().collection("games").document(game).updateData([
            "blind": FieldValue.arrayUnion([target])])
        
        decreaseSpellPoints(amtDecrease: 8)
        
        let message = "\(self.characterName) cast blindness on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castInvisibility(caster: String, target: String, game: String) {
        Firestore.firestore().collection("games").document(game).updateData([
            "invisible": FieldValue.arrayUnion([target])])
     
        decreaseSpellPoints(amtDecrease: 10)
        
        let message = "\(self.characterName) cast invisibility on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func castMotivationalSpeech(caster: String, team: String) {
        let teamRef = Firestore.firestore().collection("teams").document(team)
        teamRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let teammates = document.get("players") as! [String]
                
                for teammate in teammates {
                    Firestore.firestore().collection("players").document(teammate).setData(["has_advantage": true], merge: true)
                }
            }
        }
        
        decreaseSpellPoints(amtDecrease: 15)
        
        let message = "\(self.characterName) cast motivational speech on their team"
        messageLog.addToMessageLog(message: message)
    }
    
    func castAnimateDead(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["health": 1], merge: true)
        
        decreaseSpellPoints(amtDecrease: 17)
        
        let message = "\(self.characterName) cast animate dead on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func heal(caster: String, target: String) {
        let amtToHeal = rollDie(quant: 1, sides: 8)
        
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentHealth = document.get("health") as! Int
                let maxHealth = document.get("max_health") as! Int
                let newHealth = min(maxHealth, currentHealth + amtToHeal)
                
                Firestore.firestore().collection("players").document(target).setData(["health": newHealth], merge: true)
            }
        }
        
        decreaseSpellPoints(amtDecrease: 5)
        
        let message = "\(caster) cast heal on \(target)"
        messageLog.addToMessageLog(message: message)
    }
    
    func sleep(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["is_asleep": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 12)
        
        let message = "\(caster) cast sleep on \(target)"
        messageLog.addToMessageLog(message: message)
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
