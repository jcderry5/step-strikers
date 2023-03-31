//
//  Game.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/8/23.
//

import Foundation
import FirebaseFirestore


func setTeams(blueTeam: [RPGCharacter], redTeam: [RPGCharacter]) {
    // Read the order from fb, s
}

// resets player stats that don't carry over between games
// TODO: @Kelly call this at some point
func resetPlayerStats(player:String) {
    Firestore.firestore().collection("players").document(player).setData([
        "is_asleep": false,
        "is_blind": false,
        "is_dead": false,
        "has_advantage": false,
        "has_disadvantage": false,
        "attack_modifier": 0,
        "defense_modifier": 0,
        "magic_resistance_modifier": 0
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

// TODO: @Kelly call this at some point?
func refreshStats(character: String, game: String) {
    // read updated character info and game stats
    let playerRef = Firestore.firestore().collection("players").document(character)
    playerRef.getDocument { (document, error) in
        if let document = document, document.exists {
            // use this info to update stats on combat screen
        }
    }
}

func endTurn(game: String, player: String) {
    // if action has an enemy, or an item was used, update currTarget
    if (actionRequiresEnemy() || rowItemSelected != nil){
        Firestore.firestore().collection("players").document(currTarget.userName).setData([
            "health": currTarget.health,
            "is_dead": currTarget.isDead,
            "is_asleep": currTarget.isSleep,
            "is_blind": currTarget.isBlind,
            "is_invisible": currTarget.isInvisible,
            "current_weapon": getConstructedName(weapon: currTarget.currWeapon),
            "current_armor": getConstructedName(armor:currTarget.armor),
            "defense_modifier": currTarget.defenseModifier,
            "weapon_inventory": getWeaponStrings(weapons: currTarget.weaponInventory),
            "armor_inventory": getArmorStrings(armors: currTarget.armorInInventory)
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

