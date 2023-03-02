//
//  DiceSprite.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/1/23.
//

import UIKit
import SpriteKit

class DiceSprite: SKScene {
    let d20  = SKSpriteNode(imageNamed: "d20")
        override func didMove(to view: SKView) {
            backgroundColor = .clear
            d20.size.width = 100
            d20.size.height = 100
            d20.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            self.addChild(d20)
        }

        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
}
