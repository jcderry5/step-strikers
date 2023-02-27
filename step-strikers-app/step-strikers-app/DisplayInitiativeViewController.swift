//
//  DisplayInitiativeViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/14/23.
//

import UIKit
import FirebaseFirestore

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
        if segue.identifier == "InitiativeToWaitSegue", let nextVC = segue.identifier as? WaitViewController {
            nextVC.delegate = self
            nextVC.player = self.player
        }
    }

    @IBAction func battleButtonPressed(_ sender: Any) {
        let docRef = Firestore.firestore().collection("games").document("zIuUhRjKte6oUcvdrP4D")
        docRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let order = document.get("order") as! [String]

                if self.player == order[0] {
                    performSegue(withIdentifier: actionSegueIdentifier, sender: self)
                } else if self.player != order[0] {
                    performSegue(withIdentifier: waitSegueIdentifier, sender: self)
                } else {
                    print("Whoops, something bad happened. local character's username is \(localCharacter.userName)")
                }
            }
        }
    }
}

