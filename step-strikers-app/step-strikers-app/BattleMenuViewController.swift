//
//  BattleMenuViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit

class BattleMenuViewController: UIViewController {
    
    let buttonImg = UIImage(named: "Big choice Button")

    override func viewDidLoad() {
        super.viewDidLoad()
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
        _ = createImage(x: 16, y: 734, w: 92, h: 67, name: "left arrow")
    }
    
    @objc func createPressed() {
        // TODO: navigate to the PARTY SETUP page
    }
    
    @objc func joinPressed() {
        // TODO: navigate to the CODE ENTRY page
    }

}
