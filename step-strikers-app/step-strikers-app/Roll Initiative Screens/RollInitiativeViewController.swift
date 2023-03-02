//
//  RollInitiativeViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/1/23.
//

import UIKit
import SpriteKit

class RollInitiativeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       assignBackground()
//        let dice = rollDice()
//        self.view.addSubview(dice)
        rollD20()
    }
    
    func createDiceButton() -> UIButton {
        let imageName = "d20"
        let image = UIImage(named: imageName)
        let diceButton = UIButton(frame: CGRect(x: 75, y: 150, width: 250, height: 250))
        let imageView = UIImageView(frame:CGRect(x: 75, y: 150, width: 250, height: 250))
        diceButton.setImage(image, for: UIControl.State.normal)
        diceButton.backgroundColor = UIColor.clear
        diceButton.setTitle("", for: UIControl.State.normal)
        return diceButton
    }
    
    func displayRoll(number:Int) {
        let label = UILabel(frame: CGRect(x: 90, y: 500, width: 250, height: 100))
        label.backgroundColor = UIColor.clear
        label.text = "You rolled a \(number)!"
        label.textColor = UIColor.black
        label.font = UIFont(name: "munro", size: 40)
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor) 
        self.view.addSubview(label)
        
    }
    
    func rollD20() {
        let d20  = SKSpriteNode(imageNamed: "d20")
//        image.position = CGPoint(x:100, y: 200)
        let skView = SKView(frame: CGRect(x: 75, y: 300, width: 250, height: 250))
        let skScene = SKScene(size: skView.bounds.size)
        d20.size.width = 250
        d20.size.height = 250
        d20.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skScene.backgroundColor = UIColor.clear
        skScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        skScene.scaleMode = .aspectFit
        skScene.addChild(d20)
        skView.presentScene(skScene)
        skView.backgroundColor = UIColor.clear
        self.view.addSubview(skView)
        let rotate = SKAction.rotate(byAngle: Double.pi*2, duration: 3)
        let wait = SKAction.wait(forDuration: 1/2)
        let sequence =  SKAction.sequence([rotate,wait])
        d20.run(sequence, completion: {
            skView.removeFromSuperview()
            let staticDice = self.createDiceButton()
            staticDice.backgroundColor = UIColor.clear
            staticDice.addTarget(self, action:#selector(self.rollDicePressed(_:)), for: .touchUpInside)
            self.view.addSubview(staticDice)
            // TODO: insert actual number of roll to hit here
            self.displayRoll(number: 5)
        })
    }
    
    @objc func rollDicePressed(_ sender:UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RollResultsViewController") as! RollResultsViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }

}
