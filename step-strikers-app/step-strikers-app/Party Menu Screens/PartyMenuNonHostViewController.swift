//
//  PartyMenuNonHostViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/4/23.
//

import UIKit
import FirebaseFirestore

class PartyMenuNonHostViewController: UIViewController {
    
    var labelText:NSMutableAttributedString?
    var partyCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playBackgroundAudio(fileName: partyMenuMusicFile)
        
        assignBackground()
        // background faded shoe
        createImage(x: 0, y: 250, w: 375, h: 375, name: "Faded Emblem")
        
        // giant party code text
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Adventurer", size: 55)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        var partyCodeText = NSMutableAttributedString(attributedString: NSMutableAttributedString(string: "PARTY CODE:\n", attributes: attributes))
        let otherAttributes = [NSAttributedString.Key.font: UIFont(name: "munro", size: 20)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        // TODO: replace with actual code
        let anotherString = NSMutableAttributedString(string: "\nxxxxx", attributes: otherAttributes)
        partyCodeText.append(anotherString)
        var partyCodeLabel = UILabel(frame: CGRect(x:10, y: 50, width: 375, height: 200))
        partyCodeLabel.textAlignment = .center
        partyCodeLabel.attributedText = partyCodeText
        partyCodeLabel.numberOfLines = 0
        self.view.addSubview(partyCodeLabel)
        
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
        let leave = createLeaveButton()
        leave.addTarget(self, action:#selector(leavePressed), for:.touchUpInside)
        
        // listen for when to move to TeamMatchViewController
        let teamRef = Firestore.firestore().collection("teams").document(self.partyCode)
        teamRef.getDocument { (document, error) in
            if let document = document, document.exists {
                teamRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching team document \(self.partyCode): \(error!)")
                        return
                    }

                    if document.get("game_id") != nil {
                        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "TeamMatchViewController") as! TeamMatchViewController

                        vc.partyCode = self.partyCode
                        self.modalPresentationStyle = .fullScreen
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false)
                    }
                }
            }
        }
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
    
    func createLeaveButton() -> UIButton {
        let image = UIImage(named: "Big choice Button")
        let leaveButton = UIButton(frame: CGRect(x: 125, y: 700, width: 150, height: 75))
        leaveButton.setBackgroundImage(image, for: .normal)
        leaveButton.setTitle("LEAVE", for: .normal)
        leaveButton.setTitleColor(.brown, for: .normal)
        leaveButton.titleLabel?.font = UIFont(name: "munro", size: 30)
        leaveButton.titleLabel?.textAlignment = .center
        self.view.addSubview(leaveButton)
        return leaveButton
    }
    
    func displayMatchFound(teamNumber:Int) {
        let image = UIImage(named: "team match board")
        let imageView = UIImageView(frame: CGRect(x: 50, y: 325, width: 300, height: 200))
        imageView.image = image
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 290, height: 200))
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Adventurer", size: 30)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        let labelText = NSMutableAttributedString(string: "MATCH FOUND:\n\n", attributes: attributes)
        let range = (labelText.string as NSString).range(of: "MATCH FOUND:")
        labelText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        let otherAttribute = [NSAttributedString.Key.font: UIFont(name: "munro", size: 40)!, .underlineStyle: 0] as [NSAttributedString.Key : Any]
        let anotherString = NSMutableAttributedString(string: "\(teamNumber)", attributes: otherAttribute)
        labelText.append(anotherString)
        label.attributedText = labelText
        label.textAlignment = .center
        imageView.addSubview(label)
        self.view.addSubview(imageView)
    }
    
    @objc func leavePressed(_ sender: Any) {
        playSoundEffect(fileName: menuSelectEffect)
        // remove player from the team on firebase
        let docRef = Firestore.firestore().collection("teams").document(self.partyCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.updateData(["players": FieldValue.arrayRemove([localCharacter.userName])])
            }
        }

        // go back to battle menu
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleMenuViewController") as! BattleMenuViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
