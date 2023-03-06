//
//  RegistrationViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    let munro = "munro"
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?
    var confirmPasswordTextField:UITextField?
    
    let buttonImg = UIImage(named:"Menu Button")
    let selectedImg = UIImage(named:"Selected Menu Button")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        usernameTextField?.delegate = self
        // Create title image
        _ = createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        _ = createLabel(x:9, y:321, w:137, h:25, font:munro, size:22, text:"Username:", align:.right)
        let username = createTextField(x:154, y:321, w:202, h:34, secured:false)
        self.usernameTextField = username!
        username?.text = ""
        
        // Password
        _ = createLabel(x:9, y:372, w:137, h:25, font:munro, size:22, text:"Password:", align:.right)
        let password = createTextField(x:154, y:372, w:202, h:34, secured:true)
        self.passwordTextField = password!
        password?.text = ""
        
        // Confirm password
        _ = createLabel(x:9, y:423, w:137, h:25, font:munro, size:22, text:"Confirm Pwd:", align:.right)
        let confirmPassword = createTextField(x:154, y:423, w:202, h:34, secured:true)
        self.confirmPasswordTextField = confirmPassword!
        confirmPassword?.text = ""
                
        // Register button design
        let registerButton = createButton(x:116, y:560, w:160, h:100, text:"REGISTER", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        registerButton.addTarget(self, action:#selector(registerPressed), for:.touchUpInside)
        
        // Signin button design
        let signInButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN IN", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        signInButton.addTarget(self, action:#selector(signInPressed), for:.touchUpInside)
    }
    
    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    @objc func registerPressed() {
        // TODO: Register credentials to Firebase and navigate to Stats screen
        if self.usernameTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("Username not entered")
        } else if passwordTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("Password not entered")
        } else if passwordTextField!.text != confirmPasswordTextField!.text {
            // TODO: @Nick don't print this, display it on the screen
            print("Passwords are not matching")
        } else {
            // This is just dummy data. In beta most of this will be populated by the character creation screen
            Firestore.firestore().collection("players").document(self.usernameTextField!.text!).setData([
                "password": self.passwordTextField!.text!,
                "armor_inventory": [],
                "attack_modifier": 0,
                "character_name": "New character",
                "class": "Bard",
                "current_armor": "00No Armor",
                "current_weapon": "00Fists",
                "defense_modifier": 0,
                "has_advantage": false,
                "health": 20,
                "is_blind": false,
                "is_invisible": false,
                "item_inventory": [],
                "magic_resistance_modifier": 0,
                "spell_points": 10,
                "stamina": 20,
                "weapon_inventory": []
            ]) { err in if let err = err {
                    print("Error writing document: \(err)")
                }
            }
            
            // Temporarily hardcoded
            game = "zIuUhRjKte6oUcvdrP4D"
            player = self.usernameTextField!.text!
            
            // TODO: For beta go to character creation screen
            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "RollInitiativeViewController") as! RollInitiativeViewController

            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    @objc func signInPressed() {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
