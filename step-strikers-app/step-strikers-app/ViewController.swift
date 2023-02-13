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

class ViewController: UIViewController {
    
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
    
    @IBAction func playerOnePressed(_ sender: Any) {
    }
    
    @IBAction func playerTwoPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("preparing for segue")
    if segue.identifier == "PlayerOneSegue", let nextVC = segue.destination as? DamageViewController {
        print("you are player 1")
        nextVC.delegate = self
        nextVC.player = "Player 1"
        nextVC.opponent = "Player 2"
//            rollInitiative(game: "zIuUhRjKte6oUcvdrP4D")
    } else if segue.identifier == "PlayerTwoSegue", let nextVC = segue.destination as? DamageViewController {
        print("you are player 2")
        nextVC.delegate = self
        nextVC.player = "Player 2"
        nextVC.opponent = "Player 1"
//            rollInitiative(game: "zIuUhRjKte6oUcvdrP4D")
    }
}
    
    
//    @IBAction func readFromFireBase(_ sender: Any) {
//        let jalynRef = db.collection("players").document("jazzyjalyn")
//        jalynRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                self.characterName1.text = document.get("character_name") as! String
//                self.healthPoints1.text = "\(document.get("health_points") as! Int)"
//            } else {
//                print("Document does not exist")
//            }
//        }
//
//        let kellyRef = db.collection("players").document("ketchupkelly")
//        kellyRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                self.characterName2.text = document.get("character_name") as! String
//                self.healthPoints2.text = "\(document.get("health_points") as! Int)"
//            } else {
//                print("Document does not exist")
//            }
//        }
//
//        startGame()
//    }
}

