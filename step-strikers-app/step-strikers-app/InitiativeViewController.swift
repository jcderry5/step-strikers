//
//  InitiativeViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/14/23.
//

import UIKit
import FirebaseFirestore

class InitiativeViewController: UIViewController {
    
    var delegate: UIViewController!
    var player: String!
    var opponent: String!
    var initiative = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func rollButtonPressed(_ sender: Any) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplaySegue", let nextVC = segue.destination as? DisplayInitiativeViewController {
            startGame(player: player, game: "zIuUhRjKte6oUcvdrP4D")
            self.initiative = rollInitiative(player: player, game:
                            "zIuUhRjKte6oUcvdrP4D")
            
            nextVC.delegate = self
            nextVC.player = player
            nextVC.opponent = opponent
            nextVC.initiative = initiative
        }
    }
}
