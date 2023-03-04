//
//  CodeEntryViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/1/23.
//

import UIKit

class CodeEntryViewController: UIViewController {
    
    var popUp:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignBackground()
        
        // background faded shoe
        createImage(x: 0, y: 250, w: 375, h: 375, name: "Faded Emblem")
        
        // giant enter code text
        createLabel(x: 50, y: 200, w: 300, h: 200, font: "iso8", size: 45, text: "ENTER CODE:", align: .center)
        
        // textfield for people to enter code
        // TODO: save this to check later
        let textField = UITextField(frame: CGRect(x: 100, y: 350, width: 200, height: 40))
        textField.backgroundColor = UIColor.white
        textField.layer.borderColor = UIColor.brown.cgColor
        textField.layer.borderWidth = 2.0
        self.view.addSubview(textField)
        
        // add settings button to bottom right corner
        createSettingsButton(x: 325, y: 775, width: 40, height: 40)
        // create the back button to go to battle meny again
        let backButton = UIButton()
        backButton.frame = CGRect(x: 160, y:700, width:75, height:60)
        backButton.setTitle("BACK", for:UIControl.State.normal)
        backButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        backButton.setTitleColor(.black, for:.normal)
        backButton.setTitleColor(.brown, for:.normal)
        backButton.setBackgroundImage(UIImage(named: "Menu Button"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action:#selector(backButtonPressed), for:.touchUpInside)
        
        // confirm button for entering code in text field
        let confirmButton = UIButton(frame: CGRect(x: 125, y: 600, width: 150, height: 75))
        confirmButton.setTitle("Confirm", for: UIControl.State.normal)
        confirmButton.titleLabel!.font = UIFont(name: "munro", size: 30)
        confirmButton.setBackgroundImage(UIImage(named:"Big choice Button"), for:UIControl.State.normal)
        confirmButton.setTitleColor(.brown, for:.normal)
        confirmButton.addTarget(self, action:#selector(confirmButtonPressed), for:.touchUpInside)
        self.view.addSubview(confirmButton)
    }
    
    @objc func backButtonPressed(_ sender:UIButton!) {
        print("Back button pressed")
        // set to battle menu here
        // TODO: set battle menu view controller as vc to switch to
        /*
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
         */
    }
    
    @objc func confirmButtonPressed(_ sender:UIButton!) {
        // TODO: someone figure out how to check if they entered the right code
        var codeCorrect:Bool = false
        if codeCorrect {
            // TODO: edit so goes to correct party menu after the correct code is placed
        } else {
            popUp = createPopUp()
            self.view.addSubview(popUp!)
        }
    }
    
    func createPopUp() -> UIView {
        // view to display
        let popView = UIView(frame: CGRect(x: 50, y: 300, width: 300, height: 200))
        popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        
        // incorrect party code label
        let label = UILabel(frame: CGRect(x: 50, y: 5, width: 250, height: 100))
        label.text = "PARTY CODE INCORRECT"
        label.font = UIFont(name: "munro", size: 25)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        popView.addSubview(label)
        
        // ok button
        let okButton = UIButton(frame: CGRect(x: 25, y: 125, width: 250, height: 50))
        okButton.setTitle("OKAY", for: UIControl.State.normal)
        okButton.titleLabel!.font = UIFont(name: "munro", size: 25)
        okButton.backgroundColor = UIColor(red: 0.941, green: 0.651, blue: 0.157, alpha: 1.0)
        okButton.setTitleColor(.brown, for:.normal)
        okButton.layer.borderWidth = 3.0
        okButton.layer.borderColor = UIColor.brown.cgColor
        okButton.addTarget(self, action:#selector(okPressed), for:.touchUpInside)
        popView.addSubview(okButton)
        
        // x button
        let xButton = UIButton(frame: CGRect(x: 270, y: 10, width: 20, height: 15))
        xButton.setTitle("x", for: UIControl.State.normal)
        xButton.backgroundColor = UIColor.clear
        xButton.titleLabel!.font = UIFont(name: "American Typewriter", size: 20)
        xButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        xButton.addTarget(self, action: #selector(xPressed), for: .touchUpInside)
        popView.addSubview(xButton)
        
        // popView border
        popView.layer.borderWidth = 1.0
        popView.layer.borderColor = UIColor.black.cgColor
        
        return popView
    }
    
    @objc func okPressed(_ sender:UIButton!) {
        print("Ok button pressed")
        // TODO: Route to next screen
        /*
         let sb = UIStoryboard(name: "Main", bundle: nil)
         let vc = sb.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController

         self.modalPresentationStyle = .fullScreen
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated:false)
         */
    }
    
    @objc func xPressed(_ sender:UIButton!) {
        // remove pop up
        popUp?.removeFromSuperview()
    }
}
