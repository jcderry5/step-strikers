//
//  PartyMenuNonHostViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/4/23.
//

import UIKit

// TODO: Route here from code entry screen when correct code is input
class PartyMenuNonHostViewController: UIViewController {
    
    var labelText:NSMutableAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()
        // background faded shoe
        createImage(x: 0, y: 250, w: 375, h: 375, name: "Faded Emblem")
        
        // giant party code text
        var partyCodeLabel = createLabel(x: 10, y: 50, w: 375, h: 200, font: "Adventurer", size: 55, text: "PARTY CODE:\n xxxxx", align: .center)
        partyCodeLabel.numberOfLines = 0
        
        // add settings button to bottom right corner
        createSettingsButton(x: 325, y: 775, width: 40, height: 40)
        
        // add joined: label
        let joinedLabel = displayJoinedMembers()
        // TODO: add names for team members using this method
        joinedLabel.0.attributedText = appendMemberJoined(labelText: joinedLabel.1, member: "Host")
        joinedLabel.0.attributedText = appendMemberJoined(labelText: joinedLabel.1, member: "Player X")
        joinedLabel.0.attributedText = appendMemberJoined(labelText: joinedLabel.1, member: "Player Y")
        joinedLabel.0.attributedText = appendMemberJoined(labelText: joinedLabel.1, member: "Player Z")
        
        // leave button
        let leave = createLeaveButton()
        leave.addTarget(self, action:#selector(leavePressed), for:.touchUpInside)
        
        // TODO: call this method when ready to display player's team matched with a team
//        displayMatchFound(teamNumber: 5)
        
        
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
        // TODO: Move to battle menu
//        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "BattleMenuViewController") as! BattleMenuViewController
//
//        self.modalPresentationStyle = .fullScreen
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: false)
    }
}
