//
//  BattleMenuViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit
import FirebaseFirestore

class BattleMenuViewController: UIViewController {
    
    let buttonImg = UIImage(named: "Big choice Button")
    
    var background:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        
        playBackgroundAudio(fileName: nonCombatBattleMusicFile)
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        let icon = createImage(x: -4, y: 226, w: 400, h: 400, name: "icon")
        icon.alpha = 0.25
        
        // Create menu title label
        _ = createImage(x:27, y:0, w:338, h:200, name:"Menu Title Board")
        _ = createLabel(x:53, y:91, w:286, h:89, font:"iso8", size:45, text:"BATTLE", align:.center)
        
        // CREATE TEAM button
        let createTeamButton = createButton(x: 78, y: 305, w: 240, h: 102, text: "CREATE TEAM", fontSize: 32, normalImage: buttonImg!, highlightedImage: buttonImg!)
        createTeamButton.addTarget(self, action:#selector(createPressed), for:.touchUpInside)
        
        // JOIN TEAM button
        let joinTeamButton = createButton(x: 78, y: 480, w: 240, h: 102, text: "JOIN TEAM", fontSize: 32, normalImage: buttonImg!, highlightedImage: buttonImg!)
        joinTeamButton.addTarget(self, action:#selector(joinPressed), for:.touchUpInside)
        
        _ = createImage(x: 140, y: 716, w: 112, h: 102, name: "Battle Menu icon")
        _ = createLabel(x: 16, y: 690, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 16, y: 734, w: 92, h: 67, name: "left arrow")
        
        // Swipe right handler
        let swipeView = UIView(frame: CGRect(x: 0, y: 650, width: 393, height: 142))
        view.addSubview(swipeView)
        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(swipeRight))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)
    }
    
    @objc func createPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        // generate code
        let code = generateCode()
        team = code
        print(code)

        Firestore.firestore().collection("teams").document(code).setData([
            "matched": false,
            "players": [localCharacter.userName]
        ]) { err in
            if let err = err {
                print("Error writing new team document: \(err)")
            }
        }

        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PartyMenuHostViewController") as! PartyMenuHostViewController
        
        vc.partyCode = code
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func joinPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CodeEntryViewController") as! CodeEntryViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func swipeRight() {
        playSoundEffect(fileName: menuSelectEffect)
        // Navigate to the INVENTORY screen
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InventoryViewController") as! InventoryViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func generateCode() -> String {
      let letters = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ123456789"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if localCharacter.darkMode {
            self.background?.image = UIImage(named: "Background-darkmode")
        } else {
            self.background?.image = UIImage(named: "Background")
        }
    }
}
