//
//  ClassSelectViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/6/23.
//

import UIKit

class SelectBardViewController: UIViewController {
    
    let munro = "munro"
    let iso8 = "iso8"
    let buttonImg = UIImage(named: "Big choice Button")
    let bardDesc = "An inspiring magician whose power echoes the music of creation"

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        _ = createLabel(x: 25, y: 100, w: 361, h: 60, font: iso8, size: 60, text: "BARD", align: .center)
        
        // Add images and arrows
        _ = createImage(x: 107, y: 177, w: 179, h: 197, name: "Bard")
        _ = createLabel(x: 66, y: 350, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 66, y: 394, w: 92, h: 67, name: "left arrow")
        _ = createLabel(x: 235, y: 350, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 225, y: 401, w: 112, h: 62, name: "right arrow")
        
        // Create swipe area
        let swipeView = UIView(frame: CGRect(x:0, y:175, width:393, height:290))
        view.addSubview(swipeView)
        let swipeRight = UISwipeGestureRecognizer(target:self, action:#selector(swipeRight))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target:self, action:#selector(swipeLeft))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
        
        // Name text field
        let nameField = createTextField(x: 61, y: 490, w: 270, h: 34, secured: false)
        nameField!.placeholder = "Enter name"
        
        // Character creation text
        let classDescription = UITextView(frame: CGRectMake(46, 560, 300, 110))
        classDescription.backgroundColor = .clear
        classDescription.font = UIFont(name: munro, size: 24)
        classDescription.textAlignment = .justified
        classDescription.text = bardDesc
        view.addSubview(classDescription)
        
        // Select button
        let selectButton = createButton(x: 46, y: 700, w: 300, h: 85, text: "SELECT", fontSize: 32, normalImage: buttonImg!, highlightedImage: buttonImg!)
        selectButton.addTarget(self, action: #selector(selectPressed), for: .touchUpInside)
    }
    
    @objc func selectPressed(_ sender:UIButton!) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func swipeRight() {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectWizardViewController") as! SelectWizardViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func swipeLeft() {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectRogueViewController") as! SelectRogueViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

}
