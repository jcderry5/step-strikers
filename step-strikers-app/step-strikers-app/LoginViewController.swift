//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.font = UIFont(name: "munro", size: 22)
        passLabel.font = UIFont(name: "munro", size: 22)
        loginButton.titleLabel!.font = UIFont(name: "munro", size: 24)
        signupButton.titleLabel!.font = UIFont(name: "munro", size: 24)
    }

    @IBAction func loginPressed(_ sender: Any) {
        
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "signupVC") as! RegistrationViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
