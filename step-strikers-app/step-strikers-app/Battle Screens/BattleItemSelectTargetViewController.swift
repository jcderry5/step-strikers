//
//  BattleItemSelectTargetViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleItemSelectTargetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: unselectedButton, itemSelected: selectedButton, equipSelected: unselectedButton)
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        // TODO: for target selection need to change this to button ver.
        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
    }
}
