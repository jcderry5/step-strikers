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

// This will be called once the observer sees that hasStarted is true
// TODO: check if you're the host!
func startGame(player: String, game: String){
    var isLeader = Bool()
    var doneListening = false
    let docRef = Firestore.firestore().collection("games").document(game)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            isLeader = (document.get("game_leader") as! String == player)

            if isLeader {
                // wait for everyone to finish rolling initiative and send info to server
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    let data = document.data()
                    var dict = [String:Int]()
                    dict = data?["initiative"] as! [String:Int]
                    
                    if dict.count == data?["num_players"] as! Int && !doneListening {
                        print("finished listening, calling setOrder()")
                        doneListening = true
                        setOrder(initiative: dict, game: game)
                        return
                    }
                }
            }
        }
    }
}
func rollInitiative(player:String, game: String) -> Int{
    /*
     Visually show a d20 rolling
     on click, call rollDie(quant: 1, sides: 20) it displays returned number
     send name and initiative order to the server
     */
    
    let initiative = rollDie(quant: 1, sides: 20)
    
    // send initiative to firebase
    let data: [String:Int] = [player:initiative]
    Firestore.firestore().collection("games").document(game).updateData([
        "initiative": FieldValue.arrayUnion([data])])
    
    return initiative
}

func setOrder(initiative: [String:Int], game: String){
    // sort initiative
    let sorted = initiative.sorted { (first, second) -> Bool in
        return first.value > second.value
    }
    
    // get ordered usernames into an array
    var order : Array<String> = Array()
    for elem in sorted {
        order.append(elem.key)
    }
    
    // write array to database and signal that game is ready to start
    Firestore.firestore().collection("games").document(game).setData(["combat_start": true], merge: true)
    Firestore.firestore().collection("orders").document(game).setData(["order": order], merge: true)
    print("Initial order written")
}

func rollDie(quant: Int, sides: Int) -> Int {
    var sum = 0
    for _ in 1...quant {
        sum += Int.random(in: 1...sides)
    }
    
    return sum
}

func rollDieDisadvantage(sides: Int) -> Int {
    let firstRoll = rollDie(quant: 1, sides: sides)
    let secondRoll = rollDie(quant: 1, sides: sides)
    return (firstRoll <= secondRoll) ? firstRoll : secondRoll
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
    Firestore.firestore().collection("last_players").document(game).setData(["last_player": player], merge: true)
}
