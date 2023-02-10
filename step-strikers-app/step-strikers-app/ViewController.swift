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

    @IBOutlet weak var characterName1: UILabel!
    @IBOutlet weak var healthPoints1: UILabel!
    
    @IBOutlet weak var characterName2: UILabel!
    @IBOutlet weak var healthPoints2: UILabel!
    
    @IBAction func readFromFireBase(_ sender: Any) {
        let jalynRef = db.collection("players").document("jazzyjalyn")
        jalynRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.characterName1.text = document.get("character_name") as! String
                self.healthPoints1.text = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }
        
        let kellyRef = db.collection("players").document("ketchupkelly")
        kellyRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.characterName2.text = document.get("character_name") as! String
                self.healthPoints2.text = "\(document.get("health_points") as! Int)"
            } else {
                print("Document does not exist")
            }
        }
        
        startGame()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }


}

