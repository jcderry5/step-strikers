//
//  BattleResultsLossViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/5/23.
//

import UIKit

class BattleResultsLossViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        assignBackground()

        // Do any additional setup after loading the view.
        // victory Title
        _ = createLabel(x: 50, y: 50, w: 300, h: 200, font: "iso8", size: 55, text: "YOU LOST", align: .center)
        
        // draw victory
        let skull = UIImage(named: "Skull")
        let skullView = UIImageView(frame: CGRect(x: 0, y: 150, width: 380, height: 500))
        skullView.image = skull
        self.view.addSubview(skullView)
        
        // draw skeletons
        for (index, _) in enemiesList.enumerated() {
            var x = 10
            let drawEnemy = CharacterSprites(name: "Skeleton")
            if index == 0 {
                x = 10
            } else if index == 1 {
                x = 100
            } else if index == 2 {
                x = 200
            } else if index == 3 {
                x = 290
            }
            _ = drawEnemy.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isDead: true)
        }
        
        let bigButton = UIImage(named: "Big choice Button")
        let continueButton = createButton(x: 100, y: 725, w: 200, h: 75, text: "CONTINUE", fontSize: 30, normalImage: bigButton!, highlightedImage: bigButton!)
        continueButton.setTitleColor(.brown, for: .normal)
        continueButton.addTarget(self, action:#selector(continuePressed), for:.touchUpInside)
        
    }
    
    @objc func continuePressed(_ sender:UIButton!) {
        // route back to stats menu
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }

}
