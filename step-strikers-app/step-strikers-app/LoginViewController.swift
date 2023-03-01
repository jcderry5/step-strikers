//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore

class LoginViewController: UIViewController {
    let munro = "munro"
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
        // Create title image
        createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        createLabel(x:9, y:333, w:137, h:25, font:munro, size:22, text:"Username:")
        var username = createTextField(x:154, y:333, w:202, h:34, secured:false)
        self.usernameTextField = username!
        username?.text = ""
        // Password
        createLabel(x:9, y:403, w:137, h:25, font:munro, size:22, text:"Password:")
        var password = createTextField(x:154, y:403, w:202, h:34, secured:true)
        self.passwordTextField = password!
        password?.text = ""
        
        // Register button design
        let loginButton = createButton(x:116, y:560, w:160, h:100, text:"LOG IN", fontSize:24)
        loginButton.addTarget(self, action:#selector(loginPressed), for:.touchUpInside)
        
        // Signin button design
        let signupButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN UP", fontSize:24)
        signupButton.addTarget(self, action:#selector(signupPressed), for:.touchUpInside)
    }

    // when testing this use username: jazzyjalyn, password: doesn't matter yet but can't be empty
    @objc func loginPressed(_ sender: Any) {
        if self.usernameTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("username not entered")
        } else if passwordTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("password not entered")
        } else {
            // TODO: @Kelly validate password
            let docRef = Firestore.firestore().collection("players").document(self.usernameTextField!.text!)
            docRef.getDocument { (document, error) in if let document = document, document.exists {
                // TODO: @jalyn you can remove all these prints after you're done. I used them to test and left them in case they're helpful!
                let characterName = document.get("character_name") as! String
                print("characterName: \(characterName)")
                let characterClass = document.get("class") as! String
                print("characterClass: \(characterClass)")
                let username = self.usernameTextField!.text!
                print("username: \(username)")
                let currHealth = document.get("health") as! Int
                print("currHealth: \(currHealth)")
                let currStamina = document.get("stamina") as! Int
                print("currStamina: \(currStamina)")
                let attackModifier = document.get("attack_modifier") as! Int
                print("attackModifier: \(attackModifier)")
                let defenseModifier = document.get("defense_modifier") as! Int
                print("defenseModifier: \(defenseModifier)")
                let magicResistanceModifier = document.get("magic_resistance_modifier") as! Int
                print("magicResistanceModifier: \(magicResistanceModifier)")
                
                let weaponInventory = document.get("weapon_inventory") as! [String]
                for weapon in weaponInventory {
                    print("disgusting weapon string: \(weapon)")

                    // TODO: @jalyn create weapon objects and add each weapon to the local inventory one by one
                }
                let currWeapon = document.get("current_weapon") as! String
                print("disgusting currWeapon string: \(currWeapon)")
                
                let armorInventory = document.get("armor_inventory") as! [String]
                for armor in armorInventory {
                    print("disgusting armor string: \(armor)")

                    // TODO: @jalyn create armor objects and add each weapon to the local inventory one by one
                }
                let currArmor = document.get("current_armor") as! String
                print("disgusting currArmor string: \(currArmor)")
                
                let itemInventory = document.get("item_inventory") as! [String]
                print("itemInventory: \(itemInventory)")
                
                // TODO: @jalyn set global RPGCharacter values
                
                
                
                
                // TODO: @Nick transition to the right screen
                if username == "Player 1" {
                    let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController
                    
                    self.modalPresentationStyle = .fullScreen
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                } else {
                    let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                    
                    vc.game = "zIuUhRjKte6oUcvdrP4D"
                    
                    self.modalPresentationStyle = .fullScreen
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                }
            } else {
                // TODO: @Nick display this on screen instead of printing
                print("Incorrect username or password")
            }
            
        }
        
        
        }
    }
    
    @objc func signupPressed(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "signupVC") as! RegistrationViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
