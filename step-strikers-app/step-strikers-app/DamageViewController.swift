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
    var player: String!
    var opponent: String!
    
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
        let damageDone = Int(damageField.text ?? "none") ?? 0
        // read opponent's current health
        var currentHealth: Int = Int()
        let playerRef = Firestore.firestore().collection("players").document(opponent)
        playerRef.getDocument { (document, error) in
            if let document = document, document.exists {
                currentHealth = document.get("health") as! Int
            }
        }
        
        // caluclate new health
        let newHealth = currentHealth - damageDone
        
        // update on firebase
        Firestore.firestore().collection("players").document(opponent).setData([ "health": newHealth ], merge: true)
        
    }

    @IBAction func statsPressed(_ sender: Any) {
        // get everything from firebase
        let player1Ref = db.collection("players").document("Player 1")
        player1Ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.playerOneName = document.get("character_name") as! String
                self.playerOneHealth = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }
        
        let player2Ref = db.collection("players").document("Player 2")
        player2Ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.playerTwoName = document.get("character_name") as! String
                self.playerTwoHealth = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatsSegue", let nextVC = segue.destination as? StatsViewController {
            nextVC.delegate = self
            nextVC.playerOneName.text = self.playerOneName
            nextVC.playerOneHealth.text = self.playerOneHealth
            nextVC.playerTwoName.text = self.playerTwoName
            nextVC.playerTwoHealth.text = self.playerTwoHealth
        }
    }
}
