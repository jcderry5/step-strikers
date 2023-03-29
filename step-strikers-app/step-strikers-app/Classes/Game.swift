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

    /*
     1. fetch their updated character info
     2. Check order[0] to see if you're next up
     3. getGameStats() - invisisble, sleep, dead
        if true:
        if false: restart listener for change in order
     */

func endTurn(game: String, player: String) {
    
    // TODO: @Kelly, within the if-block goes all the edits to currTarget in firebase, in the else statement meant the currPlayer only changed themself
    if (actionRequiresEnemy()){
        
    } else {
        
    }
    
    // TODO: @Kelly for Motivational Speech to work, can you check the global rowSelected and if it's "Motivational Speech" push hasAdvantage to true for all teammates within endGame
    if rowSelected?.name == "Motivational Speech" {
        // Write true for all teammates
    }
    
    Firestore.firestore().collection("players").document(currTarget.userName).setData([
        "health": currTarget.health,
        "is_dead": currTarget.isDead,
        "is_asleep": currTarget.isSleep,
        "is_blind": currTarget.isBlind,
        "is_invisible": currTarget.isInvisible,
        "armor": getConstructedName(armor:currTarget.armor),
        "defense_modifier": currTarget.defenseModifier,
        "armor_inventory": getArmorStrings(armors: currTarget.armorInInventory)
    ], merge: true)
    
    Firestore.firestore().collection("players").document(localCharacter.userName).setData([
        "health": localCharacter.currHealth,
        "stamina": localCharacter.currStamina,
        "is_dead": localCharacter.isDead,
        "is_asleep": localCharacter.isAsleep,
        "is_blind": localCharacter.isBlind,
        "is_invisible": localCharacter.isInvisible,
        "weapon_inventory": getWeaponStrings(weapons: localCharacter.weaponsInInventory),
        "current_weapon": getConstructedName(weapon:localCharacter.currWeapon),
        "armor_inventory": getArmorStrings(armors: localCharacter.armorInInventory),
        "current_armor": getConstructedName(armor:localCharacter.currArmor),
        "item_inventory": getItemStrings(items: localCharacter.itemsInInventory),
        "attack_modifier": localCharacter.attackModifier,
        "defense_modifier": localCharacter.defenseModifier,
        "magic_resistance_modifier": localCharacter.magicResistanceModifier
    ], merge: true)
    
    Firestore.firestore().collection("last_players").document(game).setData(["last_player": localCharacter.userName], merge: true)
}
