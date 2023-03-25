//
//  BattleRollViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/24/23.
//

import UIKit

class BattleRollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var actions: [Action] = [Action]()
    let cellId = "actionCell"
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var stats: [StatsRow] = [StatsRow]()
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var actionDisplay:UITableView = UITableView()
    var statsDisplay:UITableView = UITableView()
    var selectTargetInfo :(String, String, String, String, Action)?
    var rollValueToBeat: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // puts full screen image as background of view controller
        // sets up the background images of the view controller
        // THESE NEED TO HAPPEN IN ORDER!!!!
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        let xValues = [10,100,200,290]
        for index in 0...3 {
            let enemies = enemiesList[index]
            let character = characterSprites(name: enemies.character_class)
            character.drawCharacter(view: self.view, x: xValues[index], y: 400, width: 100, height: 100, isInvisible: enemies.isInvisible, isDead: enemies.isDead)
        }
        
        displayRollingScreen()
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // top stats display
        if tableView == statsDisplay {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        if tableView == statsDisplay {
            return 30
        } else {
            if indexPath.row == 0 {
                return 80
            }
        }
        
        return UITableView.automaticDimension
    }
    
    func createStatsArray() {
        header.append(StatsHeaderRow(names: ["Host", "Player 1", "Player 2", "Player 3"]))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points:[1,2,3,4] , totalPoints: [1,2,3,4]))
    }
    
    func displayRollingScreen() {
        let diceButton = UIButton()
        diceButton.frame = CGRect(x:125, y:625, width:150, height:150)
        diceButton.setBackgroundImage(UIImage(named: "d20"), for:.normal)
        view.addSubview(diceButton)
        diceButton.addTarget(self, action:#selector(rollPressed), for:.touchUpInside)
        // TODO: CHANGE label text to display number to beat
        
        let label = UILabel(frame: CGRect(x:100, y:790, width:250, height:25))
        label.center.x = view.center.x
        label.text = "Number to Beat: __"
        label.textAlignment = .center
        label.font = UIFont(name:"munro", size:22)
        view.addSubview(label)
        
        // Checking what to display as rollToBeat
        if(actionIsContested()) {
            rollValueToBeat = calculateModifiedArmorClass()
            label.text = "Number to Beat: \(String(describing: rollValueToBeat!)) + MOD"
        } else if rowSelected?.name == "Heal" {
            label.text = "You can heal up to 8HP"
        } else {
            label.text = "Number to Beat: __"
        }
    }
    
    @objc func rollPressed(sender: UIButton!) {
        // Decide which type of die to roll
        var rollValue = 0
        if(actionRequiresRoll()) {
            rollValue = rollDie(sides: 20, withAdvantage: localCharacter.hasAdvantage, withDisadvantage: localCharacter.hasDisadvantage)
            // Replace advantage and disadvantage back to false
            localCharacter.hasAdvantage = false
            localCharacter.hasDisadvantage = false
        }
        sender.isHidden = true
        
        let continueButton = UIButton()
        continueButton.frame = CGRect(x: self.view.safeAreaInsets.left+10, y:600, width:375, height:240)
        continueButton.addTarget(self, action:#selector(continuePressed), for:.touchUpInside)
        view.addSubview(continueButton)
        
        let rollLabel = UILabel(frame: CGRect(x:165, y:625, width:250, height:125))
        rollLabel.textAlignment = .center
        rollLabel.center.x = view.center.x
        rollLabel.numberOfLines = 2
        rollLabel.text = "You rolled a\n\(rollValue) + MOD!"
        rollLabel.font = UIFont(name:"munro", size:40)
        view.addSubview(rollLabel)
        
        let dice1 = UIImageView(frame: CGRect(x: 35, y:700, width: 50, height:50))
        dice1.image = UIImage(named:"d20")
        view.addSubview(dice1)
        
        let dice2 = UIImageView(frame: CGRect(x: 315, y:700, width: 50, height:50))
        dice2.image = UIImage(named:"d20")
        view.addSubview(dice2)
        
        performBattleAction(rollValue: rollValue)
    }
    
    @objc func continuePressed(sender: UIButton!) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }

}
