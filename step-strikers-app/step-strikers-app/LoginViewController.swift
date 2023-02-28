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
                let username = self.usernameTextField!.text!
                print("username: \(username)")
                let currHealth = document.get("health") as! Int
                print("currHealth: \(currHealth)")
                let currStamina = document.get("stamina") as! Int
                print("currStamina: \(currStamina)")
                
                let weaponInventory = document.get("weapon_inventory") as! [String:[String:Int]]
                for weapon in weaponInventory {
                    let condition = weaponInventory[weapon.key]!["condition"]
                    print("\(weapon.key) condition: \(condition!)")
                    let useCount = weaponInventory[weapon.key]!["use_count"]
                    print("\(weapon.key) useCount: \(useCount!)")

                    // TODO: @jalyn create weapon objects and add each weapon to the local inventory one by one
                }
                let currWeaponName = document.get("current_weapon") as! String
                print("currWeaponName: \(currWeaponName)")
                let currWeaponCondition = weaponInventory[currWeaponName]!["condition"]
                print("currWeaponCondition: \(currWeaponCondition!)")
                let currWeaponUseCount = weaponInventory[currWeaponName]!["use_count"]
                print("currWeaponUseCount: \(currWeaponUseCount!)")
                
                let armorInventory = document.get("armor_inventory") as! [String:[String:Int]]
                for armor in armorInventory {
                    let condition = armorInventory[armor.key]!["condition"]
                    print("\(armor.key) condition: \(condition!)")
                    let useCount = armorInventory[armor.key]!["use_count"]
                    print("\(armor.key) useCount: \(useCount!)")

                    // TODO: @jalyn create armor objects and add each armor to the local inventory one by one
                }
                let currArmorName = document.get("current_armor") as! String
                print("currArmorName: \(currArmorName)")
                let currArmorCondition = armorInventory[currArmorName]!["condition"]
                print("currArmorCondition: \(currArmorCondition!)")
                let currArmorUseCount = armorInventory[currArmorName]!["use_count"]
                print("currArmorUseCount: \(currArmorUseCount!)")
                
                let itemInventory = document.get("item_inventory") as! [String]
                print("itemInventory: \(itemInventory)")
                
                // TODO: @jalyn set global RPGCharacter values
                
                
                
                
                // TODO: @Nick transition to the right screen
                
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
