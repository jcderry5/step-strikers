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
        segueWhenTurn(sender: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segueWhenTurn(sender: AnyObject) {
        // TODO: @kelly don't hardcode game
        let docRef = Firestore.firestore().collection("orders").document("zIuUhRjKte6oUcvdrP4D")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    print("change triggered!")
                   
                    let data = document.data()
                    let order = data?["order"] as! [String]
                    
                    print("order[0] is \(order[0]) and I am \(self.player!)")
                    if order[0] == self.player {
                        print("Woohoo it's your turn!")
                        self.performSegue(withIdentifier: "WaitToBattleSegue", sender:sender)
                    }
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaitToBattleSegue", let nextVC = segue.destination as? DamageViewController {
            nextVC.delegate = self
            nextVC.player = self.player
            nextVC.opponent = self.opponent
        }
    }
    
}
