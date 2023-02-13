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
    var nextVC: StatsViewController!
    var player = ""
    var opponent = ""
    
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
        // read opponent's current health
        print("attack pressed")
        var currentHealth: Int = Int()
        let playerRef = db.collection("players").document(opponent)
        playerRef.getDocument { (document, error) in
            if let document = document, document.exists {
                currentHealth = document.get("health_points") as! Int
                print("current health: \(currentHealth)")
            }
        }
        
        sleep(10)
        
        let damageDone = Int(damageField.text ?? "0") ?? 0
        print("damage done: \(damageDone)")
        
        // caluclate new health
        let newHealth = currentHealth - damageDone
        print("\(currentHealth) - \(damageDone) = \(newHealth)")
        
        // update on firebase
        db.collection("players").document(opponent).setData([ "health_points": newHealth ], merge: true)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatsSegue" {
            nextVC = segue.destination as? StatsViewController
            nextVC.delegate = self
        }
    }
    
    @IBAction func statsPressed(_ sender: Any) {
        let otherVC = nextVC as! TextChanger
        otherVC.changeText()
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            // set variables
//        if segue.identifier == "StatsSegue", let nextVC = segue.destination as? StatsViewController {
//            nextVC.delegate = self
//            nextVC.playerOneName.text = self.playerOneName
//            nextVC.playerOneHealth.text = self.playerOneHealth
//            nextVC.playerTwoName.text = self.playerTwoName
//            nextVC.playerTwoHealth.text = self.playerTwoHealth
//        }
//    }
}
