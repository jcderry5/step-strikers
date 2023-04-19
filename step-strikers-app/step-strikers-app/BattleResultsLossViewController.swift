//
//  BattleResultsLossViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/5/23.
//

import UIKit

class BattleResultsLossViewController: UIViewController {

    var notificationCenter = NotificationCenter.default
    
    var player1:UIImageView!
    var player2:UIImageView!
    var player3:UIImageView!
    var player4:UIImageView!
    
    var timer1:Timer!
    var timer2:Timer!
    var timer3:Timer!
    var timer4:Timer!
    
    var count1 = 0
    var count2 = 0
    var count3 = 0
    var count4 = 0
    
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
            let drawTeam = CharacterSprites(name: "\(enemy.character_class)")
            if index == 0 {
                x = 10
                player1 = drawTeam.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isHurt: false, isDead: true)
                timer1 = Timer.scheduledTimer(
                    timeInterval: 0.3, target: self, selector: #selector(fallDown1),
                    userInfo: nil, repeats: true)
            } else if index == 1 {
                x = 100
                player2 = drawTeam.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isHurt: false, isDead: true)
                timer2 = Timer.scheduledTimer(
                    timeInterval: 0.3, target: self, selector: #selector(fallDown2),
                    userInfo: nil, repeats: true)
            } else if index == 2 {
                x = 200
                player3 = drawTeam.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isHurt: false, isDead: true)
                timer3 = Timer.scheduledTimer(
                    timeInterval: 0.3, target: self, selector: #selector(fallDown3),
                    userInfo: nil, repeats: true)
            } else if index == 3 {
                x = 290
                player4 = drawTeam.drawCharacter(view: self.view, x: x, y: 550, width: 100, height:100, isInvisible: false, isHurt: false, isDead: true)
                timer4 = Timer.scheduledTimer(
                    timeInterval: 0.3, target: self, selector: #selector(fallDown4),
                    userInfo: nil, repeats: true)
            }

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
    
    @objc func fallDown1() {
        UIView.animate(withDuration: 0, animations: {
            if self.count1 == 6 {
                self.player1.image = UIImage(named: "Skeleton")
            } else {
                self.player1.image = UIImage(named: "\(teamList[0].character_class)FallDown_0\(self.count1)")
            }
        })
        count1 += 1
        if count1 > 6 {
            timer1.invalidate()
        }
    }
    
    @objc func fallDown2() {
        UIView.animate(withDuration: 0, animations: {
            if self.count2 == 6 {
                self.player2.image = UIImage(named: "Skeleton")
            } else {
                self.player2.image = UIImage(named: "\(teamList[1].character_class)FallDown_0\(self.count2)")
            }
        })
        count2 += 1
        if count2 > 6 {
            timer2.invalidate()
        }
    }
    
    @objc func fallDown3() {
        UIView.animate(withDuration: 0, animations: {
            if self.count3 == 6 {
                self.player3.image = UIImage(named: "Skeleton")
            } else {
                self.player3.image = UIImage(named: "\(teamList[2].character_class)FallDown_0\(self.count3)")
            }
        })
        count3 += 1
        if count3 > 6 {
            timer3.invalidate()
        }
    }
    
    @objc func fallDown4() {
        UIView.animate(withDuration: 0, animations: {
            if self.count4 == 6 {
                self.player4.image = UIImage(named: "Skeleton")
            } else {
                self.player4.image = UIImage(named: "\(teamList[3].character_class)FallDown_0\(self.count4)")
            }
        })
        count4 += 1
        if count4 > 6 {
            timer4.invalidate()
        }
    }

}
