//
//  BattleSelectTargetViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleSelectTargetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // make background image
        assignBackground()
        // the two backround menu images
        createBattleActionMenu()
        createBattleStatsDisplay()
        // based on which
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: selectedButton, itemSelected: unselectedButton, equipSelected: unselectedButton)
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        // TODO: Change to Buttons that trigger something when clicked
        drawEnemiesButton(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
    }

}
