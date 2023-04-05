//
//  ClassSelectViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/6/23.
//

import UIKit
import FirebaseFirestore

class SelectRogueViewController: UIViewController {
    
    let munro = "munro"
    let iso8 = "iso8"
    let buttonImg = UIImage(named: "Big choice Button")
    let rogueDesc = "A scoundrel who uses stealth and trickery to overcome obstacles and enemies"
    
    var nameField:UITextField?
    var userName = ""
    var message:UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        _ = createLabel(x: 25, y: 100, w: 361, h: 60, font: iso8, size: 60, text: "ROGUE", align: .center)
        
        // Add images and arrows
        _ = createImage(x: 107, y: 177, w: 179, h: 197, name: "Rogue")
        _ = createLabel(x: 66, y: 350, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 66, y: 394, w: 92, h: 67, name: "left arrow")
        
        // Create swipe area
        let swipeView = UIView(frame: CGRect(x:0, y:175, width:393, height:290))
        view.addSubview(swipeView)
        let swipeRight = UISwipeGestureRecognizer(target:self, action:#selector(swipeRight))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)
        
        // Error label
        message = createLabel(x: 61, y: 460, w: 270, h: 34, font: munro, size: 18, text: "", align: .center)
        message.textColor = .red
        
        // Name text field
        nameField = createTextField(x: 61, y: 490, w: 270, h: 34, secured: false)
        nameField!.placeholder = "Enter name"
        
        // Character creation text
        let classDescription = UITextView(frame: CGRectMake(46, 560, 300, 110))
        classDescription.backgroundColor = .clear
        classDescription.font = UIFont(name: munro, size: 24)
        classDescription.textAlignment = .justified
        classDescription.text = rogueDesc
        view.addSubview(classDescription)
        
        // Select button
        let selectButton = createButton(x: 46, y: 700, w: 300, h: 85, text: "SELECT", fontSize: 32, normalImage: buttonImg!, highlightedImage: buttonImg!)
        selectButton.addTarget(self, action: #selector(selectPressed), for: .touchUpInside)
    }
    
    @objc func selectPressed(_ sender:UIButton!) {
        // Display error message if a name was not given
        if nameField?.text == "" {
            message.text = "Please enter a name"
            return
        }
        
        // create localCharacter
        let currWeapon = Fists(useCount: 0)
        let currArmor = NoArmor(useCount: 0)
        localCharacter = Rogue(characterName: nameField!.text!, userName: userName, health: 40, stamina: 55, dead: false, asleep: false, blind: false, invisible: false, currWeapon: currWeapon, weaponsInInventory: [], currArmor: currArmor, armorInInventory: [], itemsInInventory: [], inventoryQuantities: [:])
        
        // write to firebase
        Firestore.firestore().collection("players").document(userName).setData([
            "armor_inventory": [],
            "attack_modifier": 0,
            "character_name": localCharacter.characterName,
            "class": "Rogue",
            "current_armor": "00No Armor",
            "current_weapon": "00Fists",
            "defense_modifier": 0,
            "has_advantage": false,
            "has_disadvantage": false,
            "health": localCharacter.currHealth,
            "is_blind": false,
            "is_invisible": false,
            "is_asleep": false,
            "is_dead": false,
            "item_inventory": [],
            "magic_resistance_modifier": 0,
            "spell_points": 0,
            "stamina": localCharacter.currStamina,
            "weapon_inventory": []
        ], merge: true) { err in if let err = err {
                print("Error writing document: \(err)")
            }
        }
        
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func swipeRight() {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectBardViewController") as! SelectBardViewController
        
        vc.userName = userName
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

}
