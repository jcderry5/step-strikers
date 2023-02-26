//
//  DamageViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/13/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class DamageViewController: UIViewController {
    var db: Firestore!
    var delegate: UIViewController!
    var nextVC: UIViewController!
    var player = ""
    var opponent = ""
    var game: String!
    
    var playerOneName: String!
    var playerOneHealth: String!
    var playerTwoName: String!
    var playerTwoHealth: String!
    
    @IBOutlet weak var damageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func attackPressed(_ sender: Any) {
        // figure out opponent
        // this will be replaced with tapping a certain opponent
        if player == "Player 1" {
            self.opponent = "Player 2"
        } else {
            self.opponent = "Player 1"
        }
        
        var currentHealth: Int = Int()
        let playerRef = db.collection("players").document(self.opponent)
        playerRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // read opponent's current health
                currentHealth = document.get("health") as! Int
                print("damage done text: \(self.damageField.text ?? "0")")
                let damageDone = Int(self.damageField.text ?? "0") ?? 0
                print("\(damageDone) damage done")
                
                // caluclate new health
                let newHealth = currentHealth - damageDone
                
                // update on firebase
                self.db.collection("players").document(self.opponent).setData([ "health_points": newHealth ], merge: true)
                
                // TODO: @kelly don't hardcode game ID
                endTurn(game: "zIuUhRjKte6oUcvdrP4D")
                self.performSegue(withIdentifier: "AttackToWaitSegue", sender:sender)
            }
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "StatsSegue" {
//            nextVC = segue.destination as? StatsViewController
//            nextVC.delegate = self
//        } else if segue.identifier == "WaitToBattleSegue" {
//            nextVC = segue.destination as? WaitViewController
//            nextVC.delegate = self
//            nextVC.player = self.player
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatsSegue", let nextVC = segue.destination as? StatsViewController {
            nextVC.delegate = self
        } else if segue.identifier == "WaitToBattleSegue", let nextVC = segue.destination as? WaitViewController {
            nextVC.delegate = self
            nextVC.player = self.player
        }
    }
    
    @IBAction func statsPressed(_ sender: Any) {
        let otherVC = nextVC as! TextChanger
        otherVC.changeText()
    }
}
