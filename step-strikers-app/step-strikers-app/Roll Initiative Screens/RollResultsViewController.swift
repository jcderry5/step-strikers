//
//  RollResultsViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/1/23.
//

import UIKit

class RollResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        assignBackground()
        let d20 = createDiceButton()
        d20.backgroundColor = UIColor.clear
        d20.addTarget(self, action:#selector(self.rollDicePressed(_:)), for: .touchUpInside)
        self.view.addSubview(d20)
        displayIntiative()
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
    
    func displayIntiative() {
        let mutableString = NSMutableAttributedString(string: "Turn Order:\n 1. Host\n 2. Player 1\n 3. Enemy 2\n 4. Player 3\n 5. Player2\n 6. Enemy 1\n 7. Enemy 3\n 8. Enemy 4\n", attributes: [NSAttributedString.Key.font: UIFont(name: "munro", size: 35)!])
        // 1. Host length 7
        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 13, length: 7))
        print(mutableString.length)
        
        let label = UILabel(frame: CGRect(x: 110, y: 375, width: 250, height: 500))
        label.backgroundColor = UIColor.clear
        label.attributedText = mutableString
//        label.text = "Turn Order:\n 1. Host\n 2. Player 1\n 3. Enemy 2\n 4. Player 3\n 5. Player2\n 6. Enemy 1\n 7. Enemy 3\n 8. Enemy 4\n"
//        label.textAlignment = NSTextAlignment.center
//        label.textColor = UIColor.black
//        label.font = UIFont(name: "munro", size: 35)
        label.numberOfLines = 0
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.view.addSubview(label)
        
    }
    
    @objc func rollDicePressed(_ sender:UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }

}
