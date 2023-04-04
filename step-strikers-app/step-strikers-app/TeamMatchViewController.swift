//
//  TeamMatchViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 3/4/23.
//

import UIKit
import FirebaseFirestore

var potentialMatches:UITableView = UITableView()
class TeamMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let potentialMatchID = "matchID"
    var teamMatchList: [String] = [String]()
    var confirmDisplay:UIView = UIView()
    var backButton:UIButton = UIButton()
    var partyCode = ""
    var numPlayers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignBackground()

        // giant party code text
        var chooseOpponentLabel = createLabel(x: 10, y: 25, w: 375, h: 200, font: "iso8", size: 40, text: "WAITING FOR OPPONENT", align: .center)
        chooseOpponentLabel.numberOfLines = 0
        
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
        
        // listen for matches
        let docRef = Firestore.firestore().collection("teams").document(self.partyCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    if document.get("matched") as! Bool {
                        self.displayConfirmation(hostSelected: self.partyCode)
                    }
                }
            }
        }
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
    
    func displayMatchBoard() {
        let board = UIImage(named: "Display Board")

        let boardView = UIImageView(frame: CGRect(x: 5, y: 250, width: 385, height: 400))
        boardView.image = board
        self.view.addSubview(boardView)
    }
    
    func displayConfirmation(hostSelected:String) -> UIView {
        // set game_id
        let docRef = Firestore.firestore().collection("teams").document(self.partyCode)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                enemyTeam = document.get("enemy_team") as! String
                game = document.get("game_id") as! String
                print("game \(game)")
            } else {
                print("error in confirmPressed: \(error!)")
            }
        }
        
        potentialMatches.allowsSelection = false
        let rect = UIView(frame: CGRect(x: 50, y: 310, width: 300, height: 250))
        rect.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        rect.layer.borderColor = UIColor.black.cgColor
        rect.layer.borderWidth = 2.0
        let confirmLabel = UILabel(frame: CGRect(x: 5, y: 50, width: 300, height: 100))
        confirmLabel.numberOfLines = 0
        confirmLabel.lineBreakMode = .byWordWrapping
        confirmLabel.text = "OPPONENT FOUND"
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
        // remove your team from team list
        Firestore.firestore().collection("matchable_teams").document("teams").updateData(["teams": FieldValue.arrayRemove(["self.partyCode)-\(numPlayers)"])])

        // move to roll initiative screen
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RollInitiativeViewController") as! RollInitiativeViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }
}
