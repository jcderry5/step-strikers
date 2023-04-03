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
        let victory = createLabel(x: 50, y: 50, w: 300, h: 200, font: "iso8", size: 55, text: "YOU LOST", align: .center)
        
        // draw victory
        let skull = UIImage(named: "Skull")
        let skullView = UIImageView(frame: CGRect(x: 0, y: 150, width: 380, height: 500))
        skullView.image = skull
        self.view.addSubview(skullView)
        
        // draw sprites
        // player 1
        // TODO: add EnemiesList[index].character_class when previous vc's are functional
        // adding now will break everything
        let player1 = CharacterSprites(name: "Skeleton")
        let player1Image = player1.drawCharacter(view: self.view, x: 10, y: 550, width: 100, height:100, isInvisible: false, isDead: true)
        
        // player 2
        let player2 = CharacterSprites(name:  "Skeleton")
        let player2Image = player2.drawCharacter(view: self.view, x: 100, y: 550, width: 100, height: 100, isInvisible: false, isDead: true)
        
        // player 3
        let player3 = CharacterSprites(name:  "Skeleton")
        let player3Image =  player3.drawCharacter(view: self.view, x: 200, y: 550, width: 100, height: 100, isInvisible: false, isDead: true)
        
        // player  4
        let player4 = CharacterSprites(name:  "Skeleton")
        let player4Image = player4.drawCharacter(view: self.view, x: 290, y: 550, width: 100, height: 100, isInvisible: false, isDead: true)
        
        let bigButton = UIImage(named: "Big choice Button")
        let continueButton = createButton(x: 100, y: 725, w: 200, h: 75, text: "CONTINUE", fontSize: 30, normalImage: bigButton!, highlightedImage: bigButton!)
        continueButton.setTitleColor(.brown, for: .normal)
        continueButton.addTarget(self, action:#selector(continuePressed), for:.touchUpInside)
        
    }
    
    @objc func continuePressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        // route back to stats menu
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }

}
