//
//  ViewController.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/6/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var characterName1: UILabel!
    @IBOutlet weak var healthPoints1: UILabel!
    
    @IBOutlet weak var characterName2: UILabel!
    @IBOutlet weak var healthPoints2: UILabel!
    
    //Note for Kelly: These are dummy fighters. You can comment out / delete these for the dummy fighters in firebase
    var player1 = Fighter(characterName: "Nick", userName: "niceNick", health: 30, stamina: 45)
    var player2 = Fighter(characterName: "Jalyn", userName: "jubilantJalyn", health: 30, stamina: 45)
    
    @IBAction func readFromFireBase(_ sender: Any) {
        characterName1.text = player1.characterName
        healthPoints1.text = "\(player1.currHealth)"
        
        characterName2.text = player2.characterName
        healthPoints2.text = "\(player2.currHealth)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

