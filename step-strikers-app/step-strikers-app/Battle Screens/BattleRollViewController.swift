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
    var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        // puts full screen image as background of view controller
        // sets up the background images of the view controller
        // THESE NEED TO HAPPEN IN ORDER!!!!
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        
        // create characters
        let xValues = [10,100,200,290]
        for index in 0...(enemiesList.count-1) {
            let enemies = enemiesList[index]
            var isHurt = enemies.health <= getMaxHealth(characterClass: enemies.character_class)/2
            let character = CharacterSprites(name: enemies.character_class)
            character.drawCharacter(view: self.view, x: xValues[index], y: 400, width: 100, height: 100, isInvisible: enemies.isInvisible, isHurt:isHurt, isDead: enemies.isDead)
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
    
        // Track whenever app moves to the background
        self.notificationCenter.addObserver(self, selector: #selector(pauseMusic), name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(playMusic), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notificationCenter.removeObserver(self)
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
        var nameArray:[String] = [String]()
        var healthPoints:[Int] = [Int]()
        var spellPoints:[Int] = [Int]()
        var staminaPoints:[Int] = [Int]()
        var totalHealth:[Int] = [Int]()
        var totalStamina:[Int] = [Int]()
        var totalSpellPoints:[Int] = [Int]()
        for member in teamList {
            nameArray.append(member.userName)
            healthPoints.append(member.health)
            spellPoints.append(member.spellPoints)
            staminaPoints.append(member.stamina)
            totalHealth.append(getMaxHealth(characterClass: member.character_class))
            totalStamina.append(getMaxStamina(characterClass: member.character_class))
            totalSpellPoints.append(getMaxSpellPoints(characterClass: member.character_class))
        }
        header.append(StatsHeaderRow(names: nameArray))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: totalHealth))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: totalHealth))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: spellPoints, totalPoints: totalStamina))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points: staminaPoints, totalPoints: totalSpellPoints))
    }
    
    func displayRollingScreen() {
        let diceButton = UIButton()
        diceButton.frame = CGRect(x:125, y:625, width:150, height:150)
        diceButton.setBackgroundImage(UIImage(named: "d20"), for:.normal)
        view.addSubview(diceButton)
        diceButton.addTarget(self, action:#selector(rollPressed), for:.touchUpInside)
        
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
        playSoundEffect(fileName: menuSelectEffect)
        // Decide which type of die to roll
        var rollValue = 0
        if(actionRequiresRoll()) {
            rollValue = rollDie(sides: 20, withAdvantage: localCharacter.hasAdvantage, withDisadvantage: localCharacter.hasDisadvantage)
            // Replace advantage and disadvantage back to false
            if rollValue == 1 {
                playSoundEffect(fileName: natOneEffect)
            } else if rollValue == 20 {
                playSoundEffect(fileName: natTwentyEffect)
            }
            
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
        playSoundEffect(fileName: menuSelectEffect)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }
    
    @objc func pauseMusic() {
        backgroundMusic.pause()
    }
    
    @objc func playMusic() {
        backgroundMusic.play()
    }

}
