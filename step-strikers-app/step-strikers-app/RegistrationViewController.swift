//
//  RegistrationViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore

class RegistrationViewController: UIViewController {
    let munro = "munro"
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
        // Create title image
        _ = createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        _ = createLabel(x:9, y:321, w:137, h:25, font:munro, size:22, text:"Username:", align:.right)
        var username = createTextField(x:154, y:321, w:202, h:34, secured:false)
        self.usernameTextField = username!
        username?.text = ""
        
        // Password
        _ = createLabel(x:9, y:372, w:137, h:25, font:munro, size:22, text:"Password:", align:.right)
        var password = createTextField(x:154, y:372, w:202, h:34, secured:true)
        self.passwordTextField = password!
        password?.text = ""
        
        // Confirm password
        _ = createLabel(x:9, y:423, w:137, h:25, font:munro, size:22, text:"Confirm Pwd:", align:.right)
        _ = createTextField(x:154, y:423, w:202, h:34, secured:true)
                
        // Register button design
        let registerButton = createButton(x:116, y:560, w:160, h:100, text:"REGISTER", fontSize:24)
        registerButton.addTarget(self, action:#selector(registerPressed), for:.touchUpInside)
        
        // Signin button design
        let signInButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN IN", fontSize:24)
        signInButton.addTarget(self, action:#selector(signInPressed), for:.touchUpInside)
    }
    
    @objc func registerPressed() {
        // TODO: Register credentials to Firebase and navigate to Stats screen
        if self.usernameTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("username not entered")
        } else if passwordTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("password not entered")
        } else {
            Firestore.firestore().collection("players").document(self.usernameTextField!.text!).setData(["password": self.passwordTextField!.text!]) { err in if let err = err {
                    print("Error writing document: \(err)")
                }
            }
        }
        
        // TODO: @Nick for beta go to character creation screen
    }
    
    @objc func signInPressed() {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
