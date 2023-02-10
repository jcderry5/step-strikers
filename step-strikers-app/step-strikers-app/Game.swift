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

// This will be called once the observer sees that hasStarted is true
func startGame(){
    // wait for everyone to finish rolling initiative and send info to server
    Firestore.firestore().collection("games").document("zIuUhRjKte6oUcvdrP4D").addSnapshotListener {
        documentSnapshot, error in guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
        }
        
        let data = document.data()
        var dict = [String:Int]()
        dict = data?["initiative"] as! [String:Int]
        print("Current data: \(dict)")
        
        if dict.count >= 3 {
            print("greater than 3! returning")
            setOrder(initiative: dict)
            return
        }
    }
}

func rollInitiative(){
    /*
     Visually show a d20 rolling
     on click, call rollDie(quant: 1, sides: 20) it displays returned number
     send name and initiative order to the server
     */
}

func setOrder(initiative: [String:Int]){
    
    /*
     1. Read order from fb
     2. Sort by initiative
     3. Write order to fb
     4. startObserving
     */
    
//    // everyone roll die
//    // blue team rolls first
//    for character in blueTeam {
//        var initiative = rollDie(quant: 1, sides: 20)
//        print("\(character.name) rolles a \(initiative) in the initiative order")
//        order.append((playerName: character, initiativeOrder: initiative))
//    }
//    order = order.sorted(by: {$0.initiativeOrder > $1.initiativeOrder} -> Bool)
}

func rollDice(){
    
}

func refreshStats(){
    /*
     1. fetch their updated character info
     2. Check order[0] to see if
     3. getGameStats() - invisisble, sleep, dead
        if true:
        if false: restart listener for change in order
     */
}
