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
        if segue.identifier == "PlayerOneSegue", let nextVC = segue.destination as? InitiativeViewController {
            nextVC.delegate = self
            nextVC.player = "Player 1"
            nextVC.opponent = "Player 2"
        } else if segue.identifier == "PlayerTwoSegue", let nextVC = segue.destination as? InitiativeViewController {
            nextVC.delegate = self
            nextVC.player = "Player 2"
            nextVC.opponent = "Player 1"
        }
    }
}

