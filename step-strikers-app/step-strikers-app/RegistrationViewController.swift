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
        registerButton.titleLabel!.font = UIFont(name: "munro", size: 24)
        signInButton.titleLabel!.font = UIFont(name: "munro", size: 24)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
    }
}
