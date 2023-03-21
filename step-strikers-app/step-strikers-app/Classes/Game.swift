//
//  Game.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/8/23.
//

import Foundation
import FirebaseFirestore

// This is called when ONE person decides they want to form a team.
func makeTeam(){
    /*
     1. Make a document in firebase of this team
     2. Get the team code (and display it)
     3. Add yourself to the list
     4. Have an observer looking at the players list for more players
     */
}
// This is called when they have entered the teamcode and pressed the button
func joinTeam(){
    /*
     0. Confirm that code exists
     1. Confirm that the game is open for members
     2. Write yourself to the corresponding team document players list
     3. Observer looking for changes and updating the screen with it
     4. When the observer sees that publishedTeam == TRUE, call browseTeams
     --
     */
}

// This is a function only called by non-hosts
func browseTeams(){
    /*
     Visual code for scrolling through lobby
     1. observer for foundMatch
     2. When foundMatch == TRUE, rollIniative
     */
}

// This func will be called when you have all the players for your personal team and you want to make it public so that others can request to fight you
func publishTeam(){
    /*
        1. Destory the observer from looking for new players
     
    for hosts:
     
    for non-hosts:
     
     */
}

// This will be called when a team host selects another team to fight
func requestToFight(){
    /*
     1. Check to see if team is available (for race conflicts)
     2. if available: mark both teams as unavailable IMMEDIATELY and call mergeTeams(send match leader - whoever requested to fight)
     3. if not available: throw error on screen
     */
}

func mergeTeams(){
    /*
     1. Make document
     2. Populate all values into document (populateValues)
     3. Call startGame
     */
}

func populateValues(){
    /*
     set all the values in the document for the game
     this will call setTeams
     */
}

func setTeams(blueTeam: [RPGCharacter], redTeam: [RPGCharacter]) {
    // Read the order from fb, s
}

// resets player stats that don't carry over between games
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
    
    Firestore.firestore().collection("players").document(currTarget.userName).setData([
        "health": currTarget.health,
        "armor": getConstructedName(armor:currTarget.armor),
        "defense_modifier": currTarget.defenseModifier,
        "armor_inventory": getArmorStrings(armors: currTarget.armorInInventory)
    ], merge: true)
    
    Firestore.firestore().collection("players").document(localCharacter.userName).setData([
        "health": localCharacter.currHealth,
        "stamina": localCharacter.currStamina,
        "weapon_inventory": getWeaponStrings(weapons: localCharacter.weaponsInInventory),
        "current_weapon": getConstructedName(weapon:localCharacter.currWeapon),
        "armor_inventory": getArmorStrings(armors: localCharacter.armorInInventory),
        "current_armor": getConstructedName(armor:localCharacter.currArmor),
        "item_inventory": getItemStrings(items: localCharacter.itemsInInventory),
        "attack_modifier": localCharacter.attackModifier,
        "defense_modifier": localCharacter.defenseModifier,
        "magic_resistance_modifier": localCharacter.magicResistanceModifier
    ], merge: true)
    
    Firestore.firestore().collection("last_players").document(game).setData(["last_player": player], merge: true)
}
