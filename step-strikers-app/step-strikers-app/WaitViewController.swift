//
//  WaitViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/21/23.
//

import UIKit
import FirebaseFirestore

class WaitViewController: UIViewController {
    
    var delegate: UIViewController!
    var player: String!
    var opponent: String!
    var game: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segueWhenTurn(sender: UIButton) {
        // TODO: @kelly don't hardcode game
        let docRef = Firestore.firestore().collection("games").document("zIuUhRjKte6oUcvdrP4D")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    let data = document.data()
                    let order = data?["order"] as! [String]
                    
                    if order[0] == self.player {
                        print("Woohoo it's your turn!")
                        self.performSegue(withIdentifier: "waitToBattleSegue", sender:sender)
                        return
                    }
                }
            }
        }
        // validate login
//        if validLogin {
//            self.performSegueWithIdentifier("mySegue", sender:sender)
//        }
    }
    
}
