//
//  Game.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/8/23.
//

import Foundation
import FirebaseFirestore
import UIKit

// resets player stats that don't carry over between games
func resetPlayerStats() {
    Firestore.firestore().collection("players").document(localCharacter.userName).setData([
        "is_asleep": false,
        "is_blind": false,
        "is_dead": false,
        "is_invisible": false,
        "has_advantage": false,
        "has_disadvantage": false,
        "attack_modifier": 0,
        "defense_modifier": 0,
        "magic_resistance_modifier": 0,
        "health": getMaxHealth(characterClass: localCharacter.getCharacterClass()),
        "stamina": getMaxStamina(characterClass: localCharacter.getCharacterClass()),
        "spell_points": getMaxSpellPoints(characterClass: localCharacter.getCharacterClass())
    ], merge: true)
}

func rollInitiative(player:String, game: String) -> Int{
    let initiative = rollDie(sides: 20)
        
    // send initiative to firebase
    Firestore.firestore().collection("games").document(game).updateData(["initiative.\(player)": initiative])
    return initiative
}

func rollDie(sides: Int, withAdvantage: Bool? = false, withDisadvantage: Bool? = false) -> Int {
    
    let firstValue = Int.random(in: 1...sides)
    let secondValue = Int.random(in: 1...sides)
    
    if (withAdvantage!) {
        return (firstValue >= secondValue) ? firstValue : secondValue
    } else if (withDisadvantage!) {
        return (firstValue <= secondValue) ? firstValue : secondValue
    } else {
        return firstValue
    }
}

func refreshStats() {
    // read updated character info and game stats
    let docRef = Firestore.firestore().collection("players").document(localCharacter.userName)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            // use this info to update stats on combat screen
            docRef.addSnapshotListener {
                documentSnapshot, error in guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                let data = document.data()
                
                localCharacter.currHealth = data!["health"] as! Int
                if localCharacter.currHealth <= 0 {
                    localCharacter.isDead = true
                }
                localCharacter.isAsleep = data!["is_asleep"] as! Bool
                localCharacter.isBlind = data!["is_blind"] as! Bool
                localCharacter.isInvisible = data!["is_invisible"] as! Bool
                localCharacter.hasAdvantage = data!["has_advantage"] as! Bool
                localCharacter.hasDisadvantage = data!["has_disadvantage"] as! Bool
                localCharacter.weaponsInInventory = rebuildWeaponInventory(weaponInventory: data!["weapon_inventory"] as! [String])
                localCharacter.currWeapon = rebuildWeaponToStore(currWeapon: data!["current_weapon"] as! String)
                localCharacter.armorInInventory = rebuildArmorInventory(armorInventory: data!["armor_inventory"] as! [String])
                localCharacter.currArmor = rebuildArmorToStore(armorToStore: data!["current_armor"] as! String)
                localCharacter.defenseModifier = data!["defense_modifier"] as! Int
                localCharacter.magicResistanceModifier = data!["magic_resistance_modifier"] as! Int
            }
        }
    }
}

func endTurn(game: String, player: String) {
    if checkAllEnemiesDead() {
        Firestore.firestore().collection("games").document(game).setData([
            "game_over": true,
            "game_winner": team
        ], merge: true)
    }
    
    // if action has an enemy, or an item was used, update currTarget
    if (actionRequiresEnemy() || rowItemSelected != nil){
        Firestore.firestore().collection("players").document(currTarget.userName).setData([
            "health": currTarget.health,
            "stamina": currTarget.currStamina,
            "spell_points": currTarget.spellPoints ?? 0,
            "is_dead": currTarget.isDead,
            "is_asleep": currTarget.isSleep,
            "is_blind": currTarget.isBlind,
            "is_invisible": currTarget.isInvisible,
            "current_weapon": getConstructedName(weapon: currTarget.currWeapon),
            "current_armor": getConstructedName(armor:currTarget.armor),
            "weapon_inventory": getWeaponStrings(weapons: currTarget.weaponInventory),
            "armor_inventory": getArmorStrings(armors: currTarget.armorInInventory),
            "attack_modifier": currTarget.attackModifier,
            "defense_modifier": currTarget.defenseModifier,
            "magic_resistance_modifier": currTarget.magicResistanceModifier,
            "has_advantage": currTarget.hasAdvantage,
            "has_disadvantage": currTarget.hasDisadvantage
        ], merge: true)
    }
    
    // If an action was taken this turn and that action was Motivational Speech
    if (rowSelected != nil) && rowSelected?.name == "Motivational Speech" {
        // Set advantage true for all teammates
        let teamRef = Firestore.firestore().collection("teams").document(team)
        var players:[String] = [String]()
        teamRef.getDocument { (document, error) in
            if let document = document, document.exists {
                players = document.get("players") as! [String]
                for player in players {
                    Firestore.firestore().collection("players").document(player).setData(["has_advantage": true], merge: true)
                }
            }
        }
    }
    
    // update self either way
    Firestore.firestore().collection("players").document(localCharacter.userName).setData([
        "health": localCharacter.currHealth,
        "stamina": localCharacter.currStamina,
        "spell_points": getCurrSpellPoints(characterClass: localCharacter.getCharacterClass()),
        "is_dead": localCharacter.isDead,
        "is_asleep": false,
        "is_blind": false,
        "is_invisible": localCharacter.isInvisible,
        "has_advantage": localCharacter.hasAdvantage,
        "has_disadvantage": localCharacter.hasDisadvantage,
        "weapon_inventory": getWeaponStrings(weapons: localCharacter.weaponsInInventory),
        "current_weapon": getConstructedName(weapon:localCharacter.currWeapon),
        "armor_inventory": getArmorStrings(armors: localCharacter.armorInInventory),
        "current_armor": getConstructedName(armor:localCharacter.currArmor),
        "item_inventory": getItemStrings(items: localCharacter.itemsInInventory),
        "attack_modifier": localCharacter.attackModifier,
        "defense_modifier": localCharacter.defenseModifier,
        "magic_resistance_modifier": localCharacter.magicResistanceModifier
    ], merge: true)
    
     // reset whatever row or item they just used.
    rowSelected = nil
    rowItemSelected = nil

    Firestore.firestore().collection("last_players").document(game).setData(["last_player": localCharacter.userName], merge: true)
}

