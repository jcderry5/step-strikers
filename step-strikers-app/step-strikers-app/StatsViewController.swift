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
