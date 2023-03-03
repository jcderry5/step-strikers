//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit

class StatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        
        // Create menu title label
        _ = createImage(x:27, y:0, w:338, h:200, name:"Menu Title Board")
        _ = createLabel(x:53, y:91, w:286, h:89, font:"iso8", size:45, text:"STATS", align:.center)
        
        // Create the display board and its contents
        _ = createImage(x:0, y:219, w:393, h:374, name:"Display Board")
    }

}
