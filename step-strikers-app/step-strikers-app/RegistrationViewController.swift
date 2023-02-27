//
//  RegistrationViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.font = UIFont(name: "munro", size: 22)
        passLabel.font = UIFont(name: "munro", size: 22)
        confirmLabel.font = UIFont(name: "munro", size: 22)
        
        // Register button design
        registerButton.titleLabel!.font = UIFont(name: "munro", size: 24)
        registerButton.setBackgroundImage(UIImage(named: "Selected Menu Button"), for: UIControl.State.highlighted)
        
        // Signin button design
        signInButton.titleLabel!.font = UIFont(name: "munro", size: 24)
        signInButton.setBackgroundImage(UIImage(named: "Selected Menu Button"), for: UIControl.State.highlighted)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        // TODO: Register credentials to Firebase and navigate to Stats screen
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
