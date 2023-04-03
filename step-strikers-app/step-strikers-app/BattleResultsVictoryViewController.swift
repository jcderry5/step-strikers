//
//  BattleResultsVictoryViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/5/23.
//

import UIKit

// TODO: route here when battle is over from battle idle screen
class BattleResultsVictoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()

        // Do any additional setup after loading the view.
        // victory Title
        let victory = createLabel(x: 50, y: 50, w: 300, h: 200, font: "iso8", size: 55, text: "VICTORY", align: .center)
        
        // draw victory
        let trophy = UIImage(named: "Trophy")
        let trophyView = UIImageView(frame: CGRect(x: 100, y: 250, width: 200, height: 200))
        trophyView.image = trophy
        self.view.addSubview(trophyView)
        
        // draw sprites
        // enemy 1
        // TODO: add enemeiesList[index].character_class when previous vc's are functional
        // adding now will break everything
        let enemy1 = CharacterSprites(name: "Bard")
        let enemy1Image = enemy1.drawCharacter(view: self.view, x: 10, y: 500, width: 100, height:120, isInvisible: false, isDead: false)
        
        // enemy 2
        let enemy2 = CharacterSprites(name: "Rogue")
        let enemy2Image = enemy2.drawCharacter(view: self.view, x: 100, y: 500, width: 100, height: 120, isInvisible: false, isDead: false)
        
        // enemy 3
        let enemy3 = CharacterSprites(name: "Fighter")
        let enemy3Image =  enemy3.drawCharacter(view: self.view, x: 200, y: 500, width: 100, height: 120, isInvisible: false, isDead: false)
        
        // enemy  4
        let enemy4 = CharacterSprites(name: "Wizard")
        let enemy4Image = enemy4.drawCharacter(view: self.view, x: 290, y: 500, width: 100, height: 120, isInvisible: false, isDead: false)
        
        // items collected list
        var itemsCollected = createLabel(x: 50, y: 575, w: 300, h: 200, font: "munro", size: 25, text: "Items Collected:\n -Potion of healing\n -Elixir of Magic", align: .center)
        itemsCollected.lineBreakMode = .byWordWrapping
        itemsCollected.numberOfLines = 0
        
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
