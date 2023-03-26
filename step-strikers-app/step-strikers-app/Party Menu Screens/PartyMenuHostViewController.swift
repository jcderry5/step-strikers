//
//  PartyMenuHostViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/4/23.
//

import UIKit
import FirebaseFirestore

// TODO: Route here from battle menu when CREATE team is pressed
class PartyMenuHostViewController: UIViewController {

    var labelText:NSMutableAttributedString?
    var partyCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()
        // background faded shoe
        createImage(x: 0, y: 250, w: 375, h: 375, name: "Faded Emblem")
        
        // giant party code text
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Adventurer", size: 55)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        var partyCodeText = NSMutableAttributedString(attributedString: NSMutableAttributedString(string: "PARTY CODE:\n", attributes: attributes))
        let otherAttributes = [NSAttributedString.Key.font: UIFont(name: "munro", size: 40)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        let anotherString = NSMutableAttributedString(string: "\n\(partyCode)", attributes: otherAttributes)
        partyCodeText.append(anotherString)
        var partyCodeLabel = UILabel(frame: CGRect(x:10, y: 50, width: 375, height: 200))
        partyCodeLabel.textAlignment = .center
        partyCodeLabel.attributedText = partyCodeText
        partyCodeLabel.numberOfLines = 0
        self.view.addSubview(partyCodeLabel)
        
        // add settings button to bottom right corner
        createSettingsButton(x: 325, y: 775, width: 40, height: 40)
        
        // add joined: label
        var joinedLabel = displayJoinedMembers()
        let docRef = Firestore.firestore().collection("teams").document(self.partyCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching team document \(self.partyCode): \(error!)")
                        return
                    }

                    let players = document.get("players") as! [String]
                    joinedLabel.0.removeFromSuperview()
                    joinedLabel = self.displayJoinedMembers()
                    for player in players {
                        joinedLabel.0.attributedText = self.appendMemberJoined(labelText: joinedLabel.1, member: player)
                    }
                }
            }
        }
        
        // leave button
        let ready = createReadyButton()
    }
    
    func displayJoinedMembers() -> (UILabel, NSMutableAttributedString) {
        let label = UILabel(frame: CGRect(x: 50, y: 250, width: 400, height: 400))
        let attributes = [NSAttributedString.Key.font: UIFont(name: "munro", size: 50)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        let labelText = NSMutableAttributedString(string: "JOINED:\n", attributes: attributes)
        let range = (labelText.string as NSString).range(of: "JOINED:")
        labelText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        labelText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.brown, range: range)
        label.backgroundColor = UIColor.clear
        label.attributedText = labelText
        label.numberOfLines = 0
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        label.textAlignment = .left
        self.view.addSubview(label)
        return (label, labelText)
    }
    
    func appendMemberJoined(labelText:NSMutableAttributedString, member:String) -> NSMutableAttributedString {
        let mutableString = labelText
        let attributes = [NSAttributedString.Key.font: UIFont(name: "munro", size: 45)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        let anotherString = NSMutableAttributedString(string: "• \(member)\n", attributes: attributes)
        let range = (anotherString.string as NSString).range(of: "• \(member)\n")
        anotherString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        mutableString.append(anotherString)
        return mutableString
    }
    
    func createReadyButton() -> UIButton {
        let image = UIImage(named: "Big choice Button")
        let readyButton = UIButton(frame: CGRect(x: 125, y: 700, width: 150, height: 75))
        readyButton.setBackgroundImage(image, for: .normal)
        readyButton.setTitle("READY !", for: .normal)
        readyButton.setTitleColor(.brown, for: .normal)
        readyButton.titleLabel?.font = UIFont(name: "munro", size: 30)
        readyButton.titleLabel?.textAlignment = .center
        self.view.addSubview(readyButton)
        readyButton.addTarget(self, action:#selector(readyPressed), for:.touchUpInside)
        return readyButton
    }
    
//    func createEjectButtons() -> [UIButton] {
//        let ejectImage = UIImage(named: "Eject Button")
//        // eject 1
//        let eject1 = UIButton(frame: CGRect(x: 300, y: 405, width: 50, height: 50))
//        eject1.setBackgroundImage(ejectImage, for: .normal)
//        eject1.setTitle("", for: .normal)
//        self.view.addSubview(eject1)
//
//        // eject 2
//        let eject2 = UIButton(frame: CGRect(x: 300, y: 455, width: 50, height: 50))
//        eject2.setBackgroundImage(ejectImage, for: .normal)
//        eject2.setTitle("", for: .normal)
//        self.view.addSubview(eject2)
//
//        // eject 3
//        let eject3 = UIButton(frame: CGRect(x: 300, y: 505, width: 50, height: 50))
//        eject3.setBackgroundImage(ejectImage, for: .normal)
//        eject3.setTitle("", for: .normal)
//        self.view.addSubview(eject3)
//
//        return [eject1, eject2, eject3]
//    }
    
    @objc func readyPressed(_ sender: Any) {
        // signal that team is ready to be matched
        Firestore.firestore().collection("matchable_teams").document("teams").updateData(["teams": FieldValue.arrayUnion([self.partyCode])])
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TeamMatchViewController") as! TeamMatchViewController

        vc.partyCode = self.partyCode
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
