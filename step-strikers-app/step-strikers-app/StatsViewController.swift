//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Kelly Sun on 2/13/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TextChanger {
    func changeText()
}

class StatsViewController: UIViewController, TextChanger {
    var delegate: UIViewController!
    var db: Firestore!
    
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerOneHealth: UILabel!
    
    
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerTwoHealth: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    
    func changeText() {
        // get everything from firebase
        let player1Ref = db.collection("players").document("Player 1")
        player1Ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.playerOneName.text = document.get("character_name") as? String
                self.playerOneHealth.text = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }

        let player2Ref = db.collection("players").document("Player 2")
        player2Ref.getDocument { (document, error) in
            if let document = document, document.exists {
                self.playerTwoName.text = document.get("character_name") as? String
                self.playerTwoHealth.text = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
