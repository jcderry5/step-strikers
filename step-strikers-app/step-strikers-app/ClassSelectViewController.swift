//
//  ClassSelectViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/6/23.
//

import UIKit

class ClassSelectViewController: UIViewController {
    
    let munro = "munro"
    let iso8 = "iso8"

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        _ = createLabel(x: 25, y: 100, w: 361, h: 60, font: iso8, size: 60, text: "FIGHTER", align: .center)
        
        _ = createImage(x: 107, y: 177, w: 179, h: 197, name: "Fighter")
        _ = createLabel(x: 66, y: 350, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 66, y: 394, w: 92, h: 67, name: "left arrow")
        _ = createLabel(x: 235, y: 350, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 225, y: 401, w: 112, h: 62, name: "right arrow")
        
        _ = createTextField(x: 61, y: 490, w: 270, h: 34, secured: false)
    }

}
