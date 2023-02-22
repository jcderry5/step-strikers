//
//  DisplayInitiativeViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/14/23.
//

import UIKit

class DisplayInitiativeViewController: UIViewController {
    var delegate: UIViewController!
    var player: String!
    var opponent: String!
    var initiative: Int!
    let actionSegueIdentifier: String = "ActionSegue"
    let waitSegueIdentifier: String = "WaitSegue"
    
    
    @IBOutlet weak var displayInitiativeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayInitiativeLabel.text = "You rolled a \(initiative ?? -1)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AttackSegue", let nextVC = segue.destination as? DamageViewController {
//            nextVC.delegate = self
//            nextVC.player = player
//            nextVC.opponent = opponent
//        }
        
        
        if player == "Player 1", let nextVC = segue.destination as? DamageViewController {
            nextVC.delegate = self
            nextVC.player = "Player 1"
            nextVC.opponent = "Player 2"
        } else if player == "Player 2", let nextVC = segue.destination as? WaitViewController{
            nextVC.delegate = self
            nextVC.player = "Player 1"
            nextVC.opponent = "Player 2"
        }
    }

    @IBAction func battleButtonPressed(_ sender: Any) {
        if localCharacter.userName == "Player 1" {
            performSegue(withIdentifier: actionSegueIdentifier, sender: self)
        } else if localCharacter.userName == "Player 2" {
            performSegue(withIdentifier: waitSegueIdentifier, sender: self)
        } else {
            print("Whoops, something bad happened. local character's username is \(localCharacter.userName)")
        }
    }
}

