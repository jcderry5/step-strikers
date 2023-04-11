//
//  BattleResultsLossViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/5/23.
//

import UIKit

class BattleResultsLossViewController: UIViewController {

    var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        resetPlayerStats()
        assignBackground()
        playBackgroundAudio(fileName: defeatBackgroundMusic)
        // Do any additional setup after loading the view.
        // victory Title
        _ = createLabel(x: 50, y: 50, w: 300, h: 200, font: "iso8", size: 55, text: "YOU LOST", align: .center)
        
        // draw victory
        let skull = UIImage(named: "Skull")
        let skullView = UIImageView(frame: CGRect(x: 0, y: 150, width: 380, height: 500))
        skullView.image = skull
        self.view.addSubview(skullView)
        
        // draw skeletons
        for (index, enemy) in teamList.enumerated() {
            var x = 10
            let drawTeam = CharacterSprites(name: "Skeleton")
            if index == 0 {
                x = 10
            } else if index == 1 {
                x = 100
            } else if index == 2 {
                x = 200
            } else if index == 3 {
                x = 290
            }

            let teamImage = drawTeam.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isHurt: false, isDead: true)
        }
        
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
