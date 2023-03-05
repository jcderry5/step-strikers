//
//  TeamMatchViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/4/23.
//

import UIKit
var potentialMatches:UITableView = UITableView()
class TeamMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let potentialMatchID = "matchID"
    var teamMatchList: [String] = [String]()
    var confirmDisplay:UIView = UIView()
    var backButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignBackground()

        // giant party code text
        var chooseOpponentLabel = createLabel(x: 10, y: 25, w: 375, h: 200, font: "iso8", size: 45, text: "CHOOSE YOUR OPPONENT", align: .center)
        chooseOpponentLabel.numberOfLines = 0

        // add settings button to bottom right corner
        createSettingsButton(x: 325, y: 775, width: 40, height: 40)
        
        // create the back button to go to battle meny again
        backButton = UIButton()
        backButton.frame = CGRect(x: 160, y:750, width:75, height:60)
        backButton.setTitle("BACK", for:UIControl.State.normal)
        backButton.titleLabel!.font = UIFont(name: "munro", size: 20)
        backButton.setTitleColor(.black, for:.normal)
        backButton.setTitleColor(.brown, for:.normal)
        backButton.setBackgroundImage(UIImage(named: "Menu Button"), for: .normal)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action:#selector(backButtonPressed), for:.touchUpInside)
        
        // display board where table view will go
        displayMatchBoard()
        
        // table view to display potential matches
        createMatchArray()
        potentialMatches = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 300, width: 310, height: 295))
        potentialMatches.translatesAutoresizingMaskIntoConstraints = false
        potentialMatches.dataSource = self
        potentialMatches.delegate = self
        potentialMatches.register(UITableViewCell.self, forCellReuseIdentifier: potentialMatchID)
        potentialMatches.backgroundColor = UIColor.clear
        self.view.addSubview(potentialMatches)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: potentialMatchID, for: indexPath) as! UITableViewCell
        let currentLastAction = teamMatchList[indexPath.row]
        cell.textLabel?.text = currentLastAction
        cell.textLabel?.font = UIFont(name: "munro", size: 30)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMatchList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var matchPicked = teamMatchList[indexPath.row]
        confirmDisplay = displayConfirmation(hostSelected: matchPicked)
        // TODO: add whatever needs to be done when a row is selected
    }
    
    func displayMatchFound(teamNumber:Int) {
        confirmDisplay.removeFromSuperview()
        backButton.removeFromSuperview()
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
        // TODO: wait and then move to next VC roll initiative
        /*
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RollInitiativeViewController") as! RollInitiativeViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
         */
    }
    
    func displayMatchBoard() {
        let board = UIImage(named: "Display Board")
        let upArrow = UIImage(named: "up arrow")
        let downArrow = UIImage(named: "down arrow")
        
        let boardView = UIImageView(frame: CGRect(x: 5, y: 250, width: 385, height: 400))
        boardView.image = board
        let upArrowView = UIImageView(frame: CGRect(x: 170, y: 15, width: 50, height: 30))
        upArrowView.image = upArrow
        boardView.addSubview(upArrowView)
        let downArrowView = UIImageView(frame: CGRect(x: 170, y: 350, width: 50, height: 30))
        downArrowView.image = downArrow
        boardView.addSubview(downArrowView)
        self.view.addSubview(boardView)
    }
    
    func createMatchArray() {
        for i in 1...7 {
            teamMatchList.append("HOST \(i) - 4 Players")
        }
    }
    
    func displayConfirmation(hostSelected:String) -> UIView {
        potentialMatches.allowsSelection = false
        let rect = UIView(frame: CGRect(x: 50, y: 310, width: 300, height: 250))
        rect.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        rect.layer.borderColor = UIColor.black.cgColor
        rect.layer.borderWidth = 2.0
        let confirmLabel = UILabel(frame: CGRect(x: 5, y: 50, width: 300, height: 100))
        confirmLabel.numberOfLines = 0
        confirmLabel.lineBreakMode = .byWordWrapping
        confirmLabel.text = "CONFIRM BATTLE AGAINST \"\(hostSelected)\""
        confirmLabel.font = UIFont(name: "munro", size: 30)
        confirmLabel.textAlignment = .center
        rect.addSubview(confirmLabel)
        
        let confirmButton = UIButton(frame: CGRect(x: 70, y: 175, width: 150, height: 50))
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.titleLabel!.font = UIFont(name: "munro", size: 25)
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
        rect.layer.borderWidth = 1.0
        rect.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(rect)
        return rect
    }

    @objc func backButtonPressed(_ sender:UIButton!) {
        print("Back button pressed")
        // set to battle menu here
        // TODO: set party menu as vc to switch to
        /*
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PartyMenuHostViewController") as! PartyMenuHostViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
         */
    }
    
    @objc func confirmPressed(_ sender:UIButton!) {
        // TODO: finish and save team matching items in here before moving to next VC
        print("confirm button pressed")
        // move to match found screen
        displayMatchFound(teamNumber: 4)
    }

    @objc func xPressed(_ sender:UIButton!) {
        potentialMatches.allowsSelection = true
        //dismiss confirmation
        confirmDisplay.removeFromSuperview()
    }
}
