//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit

class StatsViewController: UIViewController {
    
    let cellId = "statsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        
        // Create menu title label
        _ = createImage(x:27, y:0, w:338, h:200, name:"Menu Title Board")
        _ = createLabel(x:53, y:91, w:286, h:89, font:"iso8", size:45, text:"STATS", align:.center)
        
        // Create the display board and its contents
        _ = createImage(x:0, y:219, w:393, h:374, name:"Display Board")
        
        // TODO: Pull stats data from Firebase and use as label text
        _ = createImage(x: 25, y: 251, w: 75, h: 75, name: "health")
        _ = createLabel(x: 116, y: 251, w: 150, h: 65, font: "munro", size: 33, text: "__/__", align: .left)
        _ = createImage(x: 25, y: 326, w: 70, h: 70, name: "SpellPoints")
        _ = createLabel(x: 116, y: 326, w: 150, h: 65, font: "munro", size: 33, text: "__/__", align: .left)
        _ = createImage(x: 45, y: 411, w: 45, h: 65, name: "lightningbolt")
        _ = createLabel(x: 116, y: 411, w: 150, h: 65, font: "munro", size: 33, text: "__/__", align: .left)
        _ = createImage(x: 35, y: 486, w: 65, h: 75, name: "Shield")
        _ = createLabel(x: 116, y: 496, w: 150, h: 65, font: "munro", size: 33, text: "__", align: .left)

        // TODO: Display time data in the case that stat values are not at max
        _ = createImage(x: 227, y: 261, w: 35, h: 45, name: "Hourglass")
        _ = createLabel(x: 265, y: 251, w: 150, h: 75, font: "munro", size: 33, text: "__ min", align: .left)
        _ = createImage(x: 227, y: 336, w: 35, h: 45, name: "Hourglass")
        _ = createLabel(x: 265, y: 326, w: 150, h: 75, font: "munro", size: 33, text: "__ min", align: .left)
        _ = createImage(x: 227, y: 421, w: 35, h: 45, name: "Hourglass")
        _ = createLabel(x: 265, y: 411, w: 150, h: 75, font: "munro", size: 33, text: "__ min", align: .left)
        
        // Display steps info
        _ = createImage(x: 25, y: 618, w: 75, h: 75, name: "brown boots")
        // TODO: Pull steps info from firebase and display it here
        _ = createLabel(x: 130, y: 624, w: 253, h: 41, font: "munro", size: 28, text: "__ steps until boost", align: .left)
        _ = createLabel(x: 130, y: 653, w: 253, h: 41, font: "munro", size: 28, text: "__ taken today", align: .left)
        
        // TODO: Display the player's class pixel art below
        _ = createImage(x: 140, y: 716, w: 112, h: 112, name: "Fighter")
        _ = createImage(x: 275, y: 739, w: 112, h: 62, name: "right arrow")
        
        // Swipe left handler
        let swipeView = UIView(frame: CGRect(x: 0, y: 650, width: 393, height: 142))
        view.addSubview(swipeView)
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
    }

    @objc func swipeLeft() {
        // TODO: Set destination to inventory screen
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleMenuViewController") as! BattleMenuViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
