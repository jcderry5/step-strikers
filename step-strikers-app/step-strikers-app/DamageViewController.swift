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
        var currentHealth: Int = Int()
        let playerRef = db.collection("players").document(opponent)
        playerRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // read opponent's current health
                currentHealth = document.get("health_points") as! Int
                let damageDone = Int(self.damageField.text ?? "0") ?? 0
                
                // caluclate new health
                let newHealth = currentHealth - damageDone
                
                // update on firebase
                self.db.collection("players").document(self.opponent).setData([ "health_points": newHealth ], merge: true)
            }
        }
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
}
