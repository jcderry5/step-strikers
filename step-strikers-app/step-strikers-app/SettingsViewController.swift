//
//  SettingsViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/8/23.
//

import UIKit
import FirebaseFirestore

class SettingsViewController: UIViewController {

    var volumeSlider:UISlider = UISlider()
    var bloodSwitch:UISwitch = UISwitch()
    var darkModeSwitch:UISwitch = UISwitch()
    var vibrationSwitch:UISwitch = UISwitch()
    var notificationsSwitch:UISwitch = UISwitch()
    var cameFromVC:UIViewController?
    var confirmationView:UIView?
    var background:UIImageView?
    var notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.background = assignSwitchableBackground()
        
        // settings title
        var title = createLabel(x: 100, y: 100, w: 200, h: 100, font: "iso8", size: 40, text: "SETTINGS", align: .center)
        self.view.addSubview(title)

        // volume slider
        var volumeLabel = createLabel(x: 50, y: 250, w: 100, h: 50, font: "munro", size: 25, text: "Volume:", align: .left)
        self.view.addSubview(volumeLabel)
        volumeSlider = createVolumeSlider()
        self.view.addSubview(volumeSlider)
        volumeSlider.setValue(volumeLevel, animated: false)
        
        // blood switch
        var bloodLabel = createLabel(x: 50, y: 310, w: 100, h: 50, font: "munro", size: 25, text: "Blood:", align: .left)
        self.view.addSubview(bloodLabel)
        bloodSwitch = createToggleButton(x: 300, y: 320, width: 50, height: 50, state: false)
        if localCharacter.blood {
            bloodSwitch.setOn(true, animated: false)
        }
        
        // dark mode switch
        var darkModeLabel = createLabel(x: 50, y: 370, w: 200, h: 50, font: "munro", size: 25, text: "Dark Mode:", align: .left)
        self.view.addSubview(darkModeLabel)
        let state = self.traitCollection.userInterfaceStyle == .dark
        darkModeSwitch = createToggleButton(x: 300, y: 380 , width: 50, height: 50, state: state)
        
        // vibration switch
        var vibrationLabel = createLabel(x: 50, y: 430, w: 200, h: 50, font: "munro", size: 25, text: "Vibration:", align: .left)
        self.view.addSubview(vibrationLabel)
        vibrationSwitch = createToggleButton(x: 300, y: 440, width: 50, height: 50, state: false)
        
        // notifications switch
        var notificationsLabel = createLabel(x: 50, y: 490, w: 200, h: 50, font: "munro", size: 25, text: "Notifications:", align: .left)
        self.view.addSubview(notificationsLabel)
        notificationsSwitch = createToggleButton(x: 300, y: 500, width: 50, height: 50, state: false)
        
        // create the back button to go to battle meny again
        let backButton = UIButton()
        backButton.frame = CGRect(x: 160, y: 750, width:75, height:60)
        backButton.setTitle("BACK", for:UIControl.State.normal)
        backButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        backButton.setTitleColor(.brown, for:.normal)
        backButton.setBackgroundImage(UIImage(named: "Menu Button"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action:#selector(backButtonPressed), for:.touchUpInside)
        
        // delete account button
        let deleteButton = UIButton()
        deleteButton.frame = CGRect(x: 125, y:575, width: 150, height: 75)
        deleteButton.setTitle("DELETE ACCOUNT", for:UIControl.State.normal)
        deleteButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        deleteButton.setTitleColor(.red, for:.normal)
        deleteButton.setBackgroundImage(UIImage(named: "Menu Button"), for: .normal)
        self.view.addSubview(deleteButton)
        deleteButton.addTarget(self, action:#selector(deleteButtonPressed), for:.touchUpInside)
        
        let signOutButton = UIButton()
        signOutButton.frame = CGRect(x: 125, y: 650, width: 150, height: 75)
        signOutButton.setTitle("Sign Out", for:UIControl.State.normal)
        signOutButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        signOutButton.setTitleColor(.brown, for:.normal)
        signOutButton.setBackgroundImage(UIImage(named: "Menu Button"), for: .normal)
        self.view.addSubview(signOutButton)
        signOutButton.addTarget(self, action:#selector(signOutButtonPressed), for:.touchUpInside)
    
        // Track whenever app moves to the background
        self.notificationCenter.addObserver(self, selector: #selector(pauseMusic), name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(playMusic), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notificationCenter.removeObserver(self)
    }
    
    func createVolumeSlider() -> UISlider {
        var volume = UISlider(frame: CGRect(x: 145, y: 267, width: 200, height: 20))
        volume.backgroundColor = UIColor(red: 0.96, green: 0.80, blue: 0.61, alpha: 1.00)
        volume.setThumbImage(UIImage(named: "d20Resized"), for: .normal)
        volume.setThumbImage(UIImage(named: "d20Resized"), for: .highlighted)
        volume.layer.borderWidth = 0.5
        volume.layer.borderColor = UIColor.black.cgColor
        volume.minimumTrackTintColor = .black
        volume.isContinuous = false
        volume.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return volume
    }
    
    func createToggleButton(x: Int, y:Int, width:Int, height:Int, state:Bool) -> UISwitch {
        var toggle = UISwitch(frame: CGRect(x: x, y: y, width: width, height: height))
        toggle.backgroundColor = .red
        toggle.layer.cornerRadius = toggle.frame.height / 2
        toggle.translatesAutoresizingMaskIntoConstraints = true
        toggle.onTintColor = .green
        toggle.layer.borderWidth = 2.0
        toggle.layer.borderColor = UIColor.black.cgColor
        toggle.thumbTintColor = .black
        toggle.addTarget(self, action: #selector(switchStatedidChange), for: .valueChanged)
        toggle.setOn(state, animated: false)
        self.view.addSubview(toggle)
        return toggle
    }
    
    func displayConfirmation() -> UIView {
        let rect = UIView(frame: CGRect(x: 50, y: 310, width: 300, height: 150))
        rect.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        rect.layer.borderColor = UIColor.black.cgColor
        rect.layer.borderWidth = 2.0
        let confirmLabel = UILabel(frame: CGRect(x: 5, y: 20, width: 300, height: 100))
        confirmLabel.numberOfLines = 0
        confirmLabel.lineBreakMode = .byWordWrapping
        confirmLabel.text = "ARE YOU SURE YOU WANT TO DELETE YOUR ACCOUNT?"
        confirmLabel.font = UIFont(name: "munro", size: 20)
        confirmLabel.textAlignment = .center
        rect.addSubview(confirmLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
        confirmButton.setTitle("YES", for: .normal)
        confirmButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        confirmButton.backgroundColor = UIColor(red: 0.941, green: 0.651, blue: 0.157, alpha: 1.0)
        confirmButton.setTitleColor(.brown, for:.normal)
        confirmButton.layer.borderWidth = 3.0
        confirmButton.layer.borderColor = UIColor.brown.cgColor
        confirmButton.addTarget(self, action:#selector(confirmPressed), for:.touchUpInside)
        rect.addSubview(confirmButton)
        
        // x button
        let xButton = UIButton(frame: CGRect(x: 270, y: 10, width: 20, height: 15))
        xButton.setTitle("x", for: UIControl.State.normal)
        xButton.backgroundColor = UIColor.clear
        xButton.titleLabel!.font = UIFont(name: "American Typewriter", size: 20)
        xButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        xButton.addTarget(self, action: #selector(xPressed), for: .touchUpInside)
        rect.addSubview(xButton)
        
        // popView border
        rect.layer.borderWidth = 2.0
        rect.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(rect)
        return rect
    }
    
    func confirmSignOut() -> UIView {
        let rect = UIView(frame: CGRect(x: 50, y: 310, width: 300, height: 150))
        rect.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        rect.layer.borderColor = UIColor.black.cgColor
        rect.layer.borderWidth = 2.0
        let confirmLabel = UILabel(frame: CGRect(x: 5, y: 20, width: 300, height: 100))
        confirmLabel.numberOfLines = 0
        confirmLabel.lineBreakMode = .byWordWrapping
        confirmLabel.text = "Are you sure you want to sign out?"
        confirmLabel.font = UIFont(name: "munro", size: 20)
        confirmLabel.textAlignment = .center
        rect.addSubview(confirmLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
        confirmButton.setTitle("YES", for: .normal)
        confirmButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        confirmButton.backgroundColor = UIColor(red: 0.941, green: 0.651, blue: 0.157, alpha: 1.0)
        confirmButton.setTitleColor(.brown, for:.normal)
        confirmButton.layer.borderWidth = 3.0
        confirmButton.layer.borderColor = UIColor.brown.cgColor
        confirmButton.addTarget(self, action:#selector(confirmPressed), for:.touchUpInside)
        rect.addSubview(confirmButton)
        
        // x button
        let xButton = UIButton(frame: CGRect(x: 270, y: 10, width: 20, height: 15))
        xButton.setTitle("x", for: UIControl.State.normal)
        xButton.backgroundColor = UIColor.clear
        xButton.titleLabel!.font = UIFont(name: "American Typewriter", size: 20)
        xButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        xButton.addTarget(self, action: #selector(xPressed), for: .touchUpInside)
        rect.addSubview(xButton)
        
        // popView border
        rect.layer.borderWidth = 2.0
        rect.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(rect)
        return rect
    }

    @objc func backButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        // Update values in Firebase
        Firestore.firestore().collection("players").document(localCharacter.userName).updateData([
            "darkmode": darkModeSwitch.isOn,
            "blood": bloodSwitch.isOn
        ])
        
        // Return to battle menu
        self.dismiss(animated: false)
    }
    
    @objc func deleteButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        confirmationView = displayConfirmation()
    }
    
    @objc func signOutButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        confirmationView = confirmSignOut()
    }
    
    @objc func confirmPressed(_ sender:UIButton!) {
        // save or delete things here!
        playSoundEffect(fileName: menuSelectEffect)
        
        // switch to registration screen
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "signupVC") as! RegistrationViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }
    
    @objc func xPressed(_ sender: UIButton) {
        playSoundEffect(fileName: menuSelectEffect)
        confirmationView?.removeFromSuperview()
    }
    
    @objc func switchStatedidChange(_ sender:UISwitch!) {
        playSoundEffect(fileName: menuSelectEffect)
        if (sender.isOn == true) {
            if sender == bloodSwitch {
                print("blood switch turned on")
                localCharacter.blood = true
                bloodSwitch.setOn(true, animated: true)
            } else if sender == darkModeSwitch {
                print("dark mode switch turned on")
                let appDelegate = UIApplication.shared.windows.first
                appDelegate?.overrideUserInterfaceStyle = .dark
                localCharacter.darkMode = true
                self.background?.image = UIImage(named: "Background-darkmode")
            } else if sender == vibrationSwitch {
                print("vibration switch turned on")
            } else if sender == notificationsSwitch {
                print("notifications switch turned on")
            } else {
                print("Whoops, this shouldn't happen")
            }
        }
        else {
            if sender == bloodSwitch {
                print("blood switch turned off")
                localCharacter.blood = false
                bloodSwitch.setOn(false, animated: true)
            } else if sender == darkModeSwitch {
                print("dark mode switch turned off")
                let appDelegate = UIApplication.shared.windows.first
                appDelegate?.overrideUserInterfaceStyle = .light
                localCharacter.darkMode = false
                self.background?.image = UIImage(named: "Background")
            } else if sender == vibrationSwitch {
                print("vibration switch turned off")
            } else if sender == notificationsSwitch {
                print("notifications switch turned off")
            } else {
                print("Whoops, this shouldn't happen")
            }
        }
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        // adjust volume here based on sender.value
        changeVolume(newVolumeLevel: sender.value)
    }
    
    @objc func pauseMusic() {
        backgroundMusic.pause()
    }
    
    @objc func playMusic() {
        backgroundMusic.play()
    }
    
}
