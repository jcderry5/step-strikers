//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit

class LoginViewController: UIViewController {
    let munro = "munro"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
        // Create title image
        createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        createLabel(x:9, y:333, w:137, h:25, font:munro, size:22, text:"Username:")
        createTextField(x:154, y:333, w:202, h:34, secured:false)
        
        // Password
        createLabel(x:9, y:403, w:137, h:25, font:munro, size:22, text:"Password:")
        createTextField(x:154, y:403, w:202, h:34, secured:true)
        
        // Register button design
        let loginButton = createButton(x:116, y:560, w:160, h:100, text:"LOG IN", fontSize:24)
        loginButton.addTarget(self, action:#selector(loginPressed), for:.touchUpInside)
        
        // Signin button design
        let signupButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN UP", fontSize:24)
        signupButton.addTarget(self, action:#selector(signupPressed), for:.touchUpInside)
    }

    @objc func loginPressed(_ sender: Any) {
        // TODO: Validate user credentials and navigate to the Stats screen
    }
    
    @objc func signupPressed(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "signupVC") as! RegistrationViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
