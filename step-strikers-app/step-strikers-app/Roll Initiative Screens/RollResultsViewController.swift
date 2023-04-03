//
//  RollResultsViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/1/23.
//

import UIKit
import FirebaseFirestore

class RollResultsViewController: UIViewController {
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()

        assignBackground()
        let d20 = createDiceButton()
        d20.backgroundColor = UIColor.clear
        d20.addTarget(self, action:#selector(self.rollDicePressed(_:)), for: .touchUpInside)
        self.view.addSubview(d20)
        renderEnemies(enemyTeam: "4bDfA6dWfv8fRSdebjWI")
        displayIntiative()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playBackgroundAudio(fileName: battleMusicFile)
    }
    
    func createDiceButton() -> UIButton {
        var pressToContinueLabel = UILabel(frame: CGRect(x: 75, y: 100, width: 250, height: 100))
        pressToContinueLabel.text = "Tap dice to continue"
        pressToContinueLabel.font = UIFont(name: "munro", size: 30)
        pressToContinueLabel.textAlignment = .center
        self.view.addSubview(pressToContinueLabel)
        let imageName = "d20"
        let image = UIImage(named: imageName)
        let diceButton = UIButton(frame: CGRect(x: 75, y: 150, width: 250, height: 250))
        let imageView = UIImageView(frame:CGRect(x: 75, y: 150, width: 250, height: 250))
        diceButton.setImage(image, for: UIControl.State.normal)
        diceButton.backgroundColor = UIColor.clear
        diceButton.setTitle("", for: UIControl.State.normal)
        return diceButton
    }
    
    func displayIntiative() {
        let docRef = Firestore.firestore().collection("games").document(game)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.listener = docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if document.get("combat_start") as! Bool {
                        // display order
                        let order = document.get("initial_order") as! [String]
                        let attributes = [NSAttributedString.Key.font: UIFont(name: "munro", size: 35)!]
                        let mutableString = NSMutableAttributedString(string: "Turn Order:\n ", attributes: attributes)
                        for i in 0..<order.count {
                            let anotherString = NSMutableAttributedString(string: "\(i+1). \(order[i])\n ", attributes: attributes)
                            mutableString.append(anotherString)
                        }
                        
                        let label = UILabel(frame: CGRect(x: 110, y: 375, width: 250, height: 500))
                        label.backgroundColor = UIColor.clear
                        label.attributedText = mutableString
                        label.numberOfLines = 0
                        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                        self.view.addSubview(label)
                    }
                }
            }
        }
    }
        
        
        

    
    @objc func rollDicePressed(_ sender:UIButton) {
        playSoundEffect(fileName: menuSelectEffect)
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let docRef = Firestore.firestore().collection("orders").document(game)
        docRef.getDocument {(document, error) in
            if let document = document, document.exists {
                let order = document.get("order") as! [String]

                if localCharacter.userName == order[0] {
                    let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController
                    self.modalPresentationStyle = .fullScreen
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc,animated: false)
                } else if localCharacter.userName != order[0] {
                    let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                    self.modalPresentationStyle = .fullScreen
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc,animated: false)
                } else {
                    print("Whoops, something bad happened.")
                }
            }
        }
        
    }

}
