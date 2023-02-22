//
//  ViewController.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/6/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

var localCharacter: RPGCharacter = Rogue(characterName: "Alekhya the Sneaky One", userName: "sneakyAleky", health: 45, stamina: 30)

class ViewController: UIViewController {
    
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
        localCharacter = Rogue(characterName: "Alekhya the Sneaky One", userName: "sneakyAleky", health: 45, stamina: 30)
    }
    
    @IBAction func playerOnePressed(_ sender: Any) {
    }
    
    @IBAction func playerTwoPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerOneSegue", let nextVC = segue.destination as? InitiativeViewController {
            nextVC.delegate = self
            nextVC.player = "Player 1"
            nextVC.opponent = "Player 2"
            localCharacter = Fighter(characterName: "Roywyn", userName: "Player 1", health: 30, stamina: 30)
        } else if segue.identifier == "PlayerTwoSegue", let nextVC = segue.destination as? InitiativeViewController {
            nextVC.delegate = self
            nextVC.player = "Player 2"
            nextVC.opponent = "Player 1"
            localCharacter = Fighter(characterName: "Althea", userName: "Player 2", health: 30, stamina: 30)
        } else {
            localCharacter = Fighter(characterName: "Saint Nicholas", userName: "niceNick", health: 45, stamina: 30)
        }
    }
}

