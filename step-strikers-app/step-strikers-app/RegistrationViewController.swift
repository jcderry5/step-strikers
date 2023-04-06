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
    var message:UILabel = UILabel()
    
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
        
        // Invalid credentials label
        self.message = createLabel(x: 55, y: 500, w: 297, h: 20, font:munro, size:18, text:"", align:.center)
        self.message.textColor = .red
                
        // Register button design
        let registerButton = createButton(x:116, y:560, w:160, h:100, text:"REGISTER", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        registerButton.addTarget(self, action:#selector(registerPressed), for:.touchUpInside)
        
        // Signin button design
        let signInButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN IN", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        signInButton.addTarget(self, action:#selector(signInPressed), for:.touchUpInside)
        
        // Ask for alerts and implement the handler
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            // granted = whether you have permission, error = error
            granted, error in
            if granted {
                print("All set")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
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
        playSoundEffect(fileName: menuSelectEffect)
        if self.usernameTextField!.text == "" {
            self.message.text = "Username not entered"
        } else if passwordTextField!.text == "" {
            self.message.text = "Password not entered"
        } else if passwordTextField!.text != confirmPasswordTextField!.text {
            self.message.text = "Passwords are not matching"
        } else {
            Firestore.firestore().collection("players").document(self.usernameTextField!.text!).setData([
                "password": self.passwordTextField!.text!,
                "darkmode": false,
                "blood": true
            ]) { err in if let err = err {
                    print("Error writing document: \(err)")
                }
            }
            
            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelectFighterViewController") as! SelectFighterViewController

            vc.userName = usernameTextField!.text!
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    @objc func signInPressed() {
        playSoundEffect(fileName: menuSelectEffect)
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
