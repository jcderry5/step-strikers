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
    
    
    @IBOutlet weak var displayInitiativeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayInitiativeLabel.text = "You rolled a \(initiative ?? -1)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AttackSegue", let nextVC = segue.destination as? DamageViewController {
            nextVC.delegate = self
            nextVC.player = player
            nextVC.opponent = opponent
        }
    }

}
