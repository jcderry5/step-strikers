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
        createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        createLabel(x:9, y:321, w:137, h:25, font:munro, size:22, text:"Username:")
        var username = createTextField(x:154, y:321, w:202, h:34, secured:false)
        self.usernameTextField = username!
        username?.text = ""
        
        // Password
        createLabel(x:9, y:372, w:137, h:25, font:munro, size:22, text:"Password:")
        var password = createTextField(x:154, y:372, w:202, h:34, secured:true)
        self.passwordTextField = password!
        password?.text = ""
        
        // Confirm password
        createLabel(x:9, y:423, w:137, h:25, font:munro, size:22, text:"Confirm Pwd:")
        createTextField(x:154, y:423, w:202, h:34, secured:true)
                
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

// TODO: Figure out the best way to organize UIViewController
extension UIViewController: UITextFieldDelegate {
    func assignBackground() {
        let background = UIImage(named: "Background")
        var imageView: UIImageView!
        imageView = UIImageView(frame: self.view.frame)
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    func createLabel(x:Int, y:Int, w:Int, h:Int, font:String, size:CGFloat, text:String) {
        let label = UILabel(frame: CGRect(x:x, y:y, width:w, height:h))
        label.textAlignment = .right
        label.text = text
        label.font = UIFont(name:font, size:size)
        view.addSubview(label)
    }
    
    func createTextField(x:Int, y:Int, w:Int, h:Int, secured:Bool) -> UITextField! {
        let field = UITextField(frame: CGRect(x:x, y:y, width:w, height:h))
        field.backgroundColor = UIColor.white
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.isSecureTextEntry = secured
        field.autocapitalizationType = .none
        field.delegate = self
        view.addSubview(field)
        return field
    }
    
    func createButton(x:Int, y:Int, w:Int, h:Int, text:String, fontSize:CGFloat) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x:x, y:y, width:w, height:h)
        button.setTitle(text, for:UIControl.State.normal)
        button.titleLabel!.font = UIFont(name: "munro", size: fontSize)
        button.setTitleColor(.black, for:.normal)
        button.setBackgroundImage(UIImage(named:"Menu Button"), for:UIControl.State.normal)
        button.setBackgroundImage(UIImage(named:"Selected Menu Button"), for:UIControl.State.highlighted)
        view.addSubview(button)
        return button
    }
    
    func createImage(x:Int, y:Int, w:Int, h:Int, name:String) {
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x, y:y, width:w, height:h))
        imageView.image = UIImage(named:name)
        view.addSubview(imageView)
    }
}
