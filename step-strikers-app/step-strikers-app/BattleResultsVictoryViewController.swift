//
//  BattleResultsVictoryViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/5/23.
//

import UIKit

// TODO: route here when battle is over from battle idle screen
class BattleResultsVictoryViewController: UIViewController {

    var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPlayerStats()
        let loot = randomWinnerItemDrop(newOwner: localCharacter)
        
        assignBackground()
        playBackgroundAudio(fileName: victoryBackgroundMusic)
        // Do any additional setup after loading the view.
        // Victory Title
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
        for (index, team) in teamList.enumerated() {
            var x = 10
            let drawTeam = CharacterSprites(name: team.character_class)
            if index == 0 {
                x = 10
            } else if index == 1 {
                x = 100
            } else if index == 2 {
                x = 200
            } else if index == 3 {
                x = 290
            }
            let teamImage = drawTeam.drawCharacter(view: self.view, x: x, y: 500, width: 100, height:120, isInvisible: false, isHurt:false, isDead: false)
        }
        
        // items collected list
        var itemsCollected = createLabel(x: 50, y: 575, w: 300, h: 200, font: "munro", size: 25, text: "Items Collected:\n -\(loot[0])\n -\(loot[1])\n -\(loot[2]) ", align: .center)
        itemsCollected.lineBreakMode = .byWordWrapping
        itemsCollected.numberOfLines = 0
        
        let bigButton = UIImage(named: "Big choice Button")
        let continueButton = createButton(x: 100, y: 725, w: 200, h: 75, text: "CONTINUE", fontSize: 30, normalImage: bigButton!, highlightedImage: bigButton!)
        continueButton.setTitleColor(.brown, for: .normal)
        continueButton.addTarget(self, action:#selector(continuePressed), for:.touchUpInside)
        
        // Track whenever app moves to the background
        self.notificationCenter.addObserver(self, selector: #selector(pauseMusic), name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(playMusic), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notificationCenter.removeObserver(self)
    }
    
    @objc func continuePressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        
        // reset player stats
        refreshStats()
        
        // route back to stats menu
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    @objc func pauseMusic() {
        backgroundMusic.pause()
    }
    
    @objc func playMusic() {
        backgroundMusic.play()
    }
}
