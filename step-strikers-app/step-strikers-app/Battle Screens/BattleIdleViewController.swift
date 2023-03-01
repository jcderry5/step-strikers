//
//  BattleIdleViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/27/23.
//

import UIKit
import FirebaseFirestore

var messages:[String] = [String]()
class BattleIdleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectTargetInfoItem :(String, String, String, String, Items)?
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var stats: [StatsRow] = [StatsRow]()
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTeam(enemyTeam: "4bDfA6dWfv8fRSdebjWI")
        renderEnemies(enemyTeam: "4bDfA6dWfv8fRSdebjWI")
        // Do any additional setup after loading the view.
        // background images and view set up
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // stats menu
        createStatsArray()
        statsDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 140, width: 300, height: 300))
        statsDisplay.translatesAutoresizingMaskIntoConstraints = false
        statsDisplay.dataSource = self
        // register the table since it was not created with the storyboard
        // two different types of custom cells hence
        // need to register both types
        statsDisplay.register(StatsTableViewCell.self, forCellReuseIdentifier: statsCellID)
        statsDisplay.register(StatsHeaderTableViewCell.self, forCellReuseIdentifier: statsHeaderID)
        statsDisplay.backgroundColor = UIColor.clear
        statsDisplay.delegate = self
        // cannot press on a row
        statsDisplay.allowsSelection = false
        // get rid of grey separator line in between rows
        statsDisplay.separatorColor = UIColor.clear
        self.view.addSubview(statsDisplay)
        
        // scroll view
        // Set the scrollView's frame to be the size of the screen
        createMessageArray()
        scrollView = UIScrollView(frame: CGRect(x: view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        scrollView.backgroundColor = UIColor.clear
        // Set the contentSize to 100 times the height of the phone's screen so that we can add 100 images in the next step
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.bounds.size.height*25*CGFloat(messages.count))
        view.addSubview(scrollView!)
        var labels = [UILabel]()
        for i in 0...(messages.count-1) {
            labels.append(UILabel())
            labels[i].text = messages[i]
            labels[i].textColor = UIColor.black
            labels[i].font = UIFont(name: "munro", size: 20)
            labels[i].frame = CGRect(x: 0, y: 25*CGFloat(i), width: view.frame.width, height: 25)
            labels[i].contentMode = .scaleAspectFill
            scrollView.addSubview(labels[i])
        }
        
        print("I am \(player)")
        segueWhenTurn()
    }
    
    func createMessageArray() {
        // TODO: append messages passed in through message functionality here
        messages.append("this is 1")
        messages.append("this is 2")
        messages.append("this is 3")
        messages.append("this is 4")
        messages.append("this is 5")
        messages.append("this is 6")
        messages.append("this is 7")
        messages.append("this is 8")
        messages.append("this is 9")
        messages.append("this is 10")
        messages.append("this is 11")
        messages.append("this is 12")
        messages.append("this is 13")
        messages.append("this is 14")
        messages.append("this is 15")
        messages.append("this is 16")
        messages.append("this is 17")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == statsDisplay { // top stats display
            if indexPath.row == 0 {
                // if its the first row then it just should be the header
                // of team member names
                let cell = tableView.dequeueReusableCell(withIdentifier: statsHeaderID, for: indexPath) as! StatsHeaderTableViewCell
                let currentLastAction = header[indexPath.row]
                cell.head = currentLastAction
                // set background of each cell to clear
                cell.backgroundColor = UIColor.clear
                // no separator inset!
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: statsCellID, for: indexPath) as! StatsTableViewCell
                let currentLastAction = stats[indexPath.row]
                cell.stats = currentLastAction
                cell.backgroundColor = UIColor.clear
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {}
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        return 30
    }
    
    func createStatsArray() {
        header.append(StatsHeaderRow(names: ["Host", "Player 1", "Player 2", "Player 3"]))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points:[1,2,3,4] , totalPoints: [1,2,3,4]))
    }
    
    func segueWhenTurn() {
        var first = true
        let docRef = Firestore.firestore().collection("orders").document(game)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if !first {
                        print("change triggered!")
                        
                        let data = document.data()
                        let order = data?["order"] as! [String]
                        
                        print("order[0] is \(order[0]) and I am \(player)")
                        if order[0] == player {
                            print("Woohoo it's your turn!")
                            
                            // bring up battle VC
                            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController
                            
                            self.modalPresentationStyle = .fullScreen
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false)
                            
                        }
                    } else {
                        first = false
                    }
                }
            }
        }
    }
}
