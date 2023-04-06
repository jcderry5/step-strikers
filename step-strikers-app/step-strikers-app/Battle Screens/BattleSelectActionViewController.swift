//
//  BattleSelectActionViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit
import FirebaseFirestore

var boxArrow: [AnyObject] = [AnyObject]()
var rowSelected:Action?

var actionLongPressed:Action?

// Dummy currTarget, until gets set by action
var currTarget: CurrTargetData = CurrTargetData(name: "EmptyPlayer", userName: "emptyPlayer", character_class: "Fighter", health: 30, armor: NoArmor(), modifiedArmorClass: 0, attackModifier: 0, defenseModifier: 0, armorInInventory: [NoArmor()], isBlind: false, isDead: false, isSleep: false, isInvisible: false, magicResistanceModifier: 0, currWeapon: Fists(), weaponInventory: [Fists()], hasAdvantage: false, hasDisadvantage: false, currStamina: 0)
var actions: [Action] = [Action]()
var game: String = ""
var team:String = ""
var enemyTeam:String = ""

class BattleSelectActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // array of all the actions a player can take
    
    let cellId = "actionCell"
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var stats: [StatsRow] = [StatsRow]()
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var actionDisplay:UITableView = UITableView()
    var statsDisplay:UITableView = UITableView()
    var characters: [UIImageView] = [UIImageView]()
    var characterButtons: [UIButton] = [UIButton]()
    var recentlyTapped:Int = 1000
    var playerButtons: [UIButton] = [UIButton]()
    var selected:Bool = false
    var helpPopUp: UIView?
    var helpButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if game is already over
        if checkAllEnemiesDead() {
            Firestore.firestore().collection("games").document(game).setData([
                "game_over": true,
                "game_winner": team
            ], merge: true)
            
            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BattleResultsVictoryViewController") as! BattleResultsVictoryViewController
            
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        let gameRef = Firestore.firestore().collection("games").document(game)
        gameRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("game_over") as! Bool {
                    if document.get("game_winner") as! String == team {
                        // you win!
                        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "BattleResultsVictoryViewController") as! BattleResultsVictoryViewController
                        
                        self.modalPresentationStyle = .fullScreen
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false)
                        
                    } else {
                        // you lose
                        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "BattleResultsLossViewController") as! BattleResultsLossViewController
                        
                        self.modalPresentationStyle = .fullScreen
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false)
                    }
                }
            }
        }
        
        
        displayEnemies(enemyTeam: enemyTeam)
        // puts full screen image as background of view controller
        // sets up the background images of the view controller
        // THESE NEED TO HAPPEN IN ORDER!!!!
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: selectedButton, itemSelected: unselectedButton, equipSelected: unselectedButton)
        
        // create a Table View that displays the action menu, and when pressed does something
        // the array of all the action a player can do
        selected = false
        recentlyTapped = 1000
        createActionArray()
        // the frame of where the table will appear
        actionDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        actionDisplay.translatesAutoresizingMaskIntoConstraints = false
        actionDisplay.dataSource = self
        // register the table since it was not created with the storyboard
        actionDisplay.register(ActionTableViewCell.self, forCellReuseIdentifier: cellId)
        actionDisplay.delegate = self
        actionDisplay.backgroundColor = UIColor.clear
        // long press for description
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(helpPressed))
        actionDisplay.addGestureRecognizer(longPress)
        self.view.addSubview(actionDisplay)
        
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
        
        helpButton = createButton(x: 300, y: 300, width: 50, height: 50, fontName: "munro", imageName: "helpbutton", fontColor: .black, buttonTitle: "")
        helpButton!.addTarget(self, action:#selector(helpButtonPressed), for:.touchUpInside)
        self.view.addSubview(helpButton!)
        
        // turn skipped if you are dead or asleep
        checkDeadOrAsleep()
        
        // blind only pop up
        if localCharacter.isBlind {
            let popUp = createPopUpBlind()
            self.view.addSubview(popUp)
        }
        // label indicating current player is invisible
        if localCharacter.isInvisible {
            isInvisible_label()
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == actionDisplay {
            return actions.count
        } else if tableView == statsDisplay {
            return stats.count
        }
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // bottom display
        if tableView == actionDisplay {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ActionTableViewCell
            let currentLastAction = actions[indexPath.row]
            cell.action = currentLastAction
            cell.backgroundColor = UIColor.clear
            return cell
        } else if tableView == statsDisplay { // top stats display
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
    
    // TODO: update with segue to select target view controller when pressed
    // TODO: update with real information about the action selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        if recentlyTapped == indexPath.row && selected == true {
            selected = false
            if characterButtons.isEmpty == false {
                for index in characterButtons.indices {
                    characterButtons[index].removeFromSuperview()
                }
           }
            selectEnemyLabel.removeFromSuperview()
            selectPlayerLabel.removeFromSuperview()
            
            if boxArrow.isEmpty == false {
                for index in boxArrow.indices {
                    boxArrow[index].removeFromSuperview()
                }
            }
            tableView.deselectRow(at: indexPath, animated:false)
            if localCharacter.isBlind == false {
                for index in enemiesList.indices {
                    self.view.addSubview(enemiesList[index].imageView)
                }
            }
        } else {
            selected = true
            rowSelected = actions[indexPath.row] // Actions stuct (holds
            recentlyTapped = indexPath.row
            if tableView == actionDisplay {
                for index in enemiesList.indices {
                    if enemiesList[index].isDead == false {
                        enemiesList[index].imageView.removeFromSuperview()
                    }
                    
                }
                selectEnemyLabel.removeFromSuperview()
                if boxArrow.isEmpty == false {
                    for index in boxArrow.indices {
                        boxArrow[index].removeFromSuperview()
                    }
                }
                // will need to resave if the player deselects, but if you do it here it'll override
                
                // Decide if the player needs to select an enemy
                if(actionRequiresEnemy()) {
                    if localCharacter.isBlind {
                        if actionTargetsTeam() {
                            selectRandomTeamMember()
                        } else {
                            selectRandomEnemy()
                        }
                        if boxArrow.isEmpty == false {
                            for index in boxArrow.indices {
                                boxArrow[index].removeFromSuperview()
                            }
                        }
                    } else {
                        if actionTargetsTeam() {
                            for index in enemiesList.indices {
                                self.view.addSubview(enemiesList[index].imageView)
                            }
                            playerButtons = drawPlayerButtons()
                        } else {
                            characterButtons = drawEnemiesButton()
                            checkAllEnemiesInvisible()
                        }
                    }
                } else {
                    performBattleAction()
                    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                    self.modalPresentationStyle = .fullScreen
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc,animated: false)
                }
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        if tableView == statsDisplay {
            return 30
        } else {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
        }
        
        return UITableView.automaticDimension
    }
    
    @objc func helpButtonPressed(_ sender: UIButton) {
        playSoundEffect(fileName: menuSelectEffect)
        helpPopUp?.removeFromSuperview()
        
        // view to display
        let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
        popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        
        // label based on blind or invisible
        var label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
        label.text = ""
        for (index, action) in actions.enumerated() {
            let actionDescription = actionDescription(actionName: action.name!)
            label.text!.append("\(action.name!): \(actionDescription)\n")
        }
        label.font = UIFont(name: "munro", size: 12)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        popView.addSubview(label)
        
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
        helpPopUp = popView
        self.view.addSubview(helpPopUp!)
    }
    
    // long press on action from action table
    @objc func helpPressed(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        playSoundEffect(fileName: menuSelectEffect)
        var actionName:String = " "
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: actionDisplay)
            if let indexPath = actionDisplay.indexPathForRow(at: touchPoint){
                helpPopUp?.removeFromSuperview()
                actionName = actions[indexPath.row].name!
                actionLongPressed = actions[indexPath.row]
                
                // view to display
                let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
                popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
                
                // label based on blind or invisible
                let label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
                let actionDescription = actionDescription(actionName: actionName)
                label.text = "\(actionName): \(actionDescription)"
                label.font = UIFont(name: "munro", size: 20)
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
                label.textColor = UIColor.black
                label.backgroundColor = UIColor.clear
                popView.addSubview(label)
                
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
                helpPopUp = popView
                self.view.addSubview(helpPopUp!)
            }
        }

    }

    // x pressed on the help button
    @objc func xPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        // remove pop up
        helpPopUp?.removeFromSuperview()
    }
    
    func createActionArray() {
        actions.removeAll()
        // First: check if the fight action (possible for all characters) is possible
        // Note: String format makes the number 2 digits
        if(localCharacter.currWeapon.staminaCost <= localCharacter.currStamina) {
            actions.append(Action(name: "Fight", staminaCost: "\(String(format: "%02d", localCharacter.currWeapon.staminaCost)) STA"))
        }
        
        // Next: Add all other actions. Check against stamina for Attackers and against spell points for Casters
        let characterClass = localCharacter.getCharacterClass()
        if characterClass == "Fighter" {
            for index in 1 ... (FighterActions.count-1) {
                let cost: Int = Int(FighterActions[index].cost.prefix(2))!
                if(cost <= localCharacter.currStamina) {
                    actions.append(Action(name:FighterActions[index].actionName, staminaCost: FighterActions[index].cost))
                }
            }
        } else if characterClass == "Wizard" {
            for index in 1 ... (WizardActions.count-1) {
                let cost: Int = Int(WizardActions[index].cost.prefix(2))!
                if(cost <= (localCharacter as! Wizard).currSpellPoints) {
                    actions.append(Action(name:WizardActions[index].actionName, staminaCost: WizardActions[index].cost))
                }
            }
        } else if characterClass == "Rogue" {
            for index in 1 ... (RogueActions.count-1) {
                let cost: Int = Int(RogueActions[index].cost.prefix(2))!
                if(cost <= localCharacter.currStamina){
                    actions.append(Action(name:RogueActions[index].actionName, staminaCost: RogueActions[index].cost))
                }
            }
        } else if characterClass == "Bard" {
            for index in 1 ... (BardActions.count-1) {
                let cost: Int = Int(BardActions[index].cost.prefix(2))!
                if(cost <= (localCharacter as! Bard).currSpellPoints) {
                    actions.append(Action(name:BardActions[index].actionName, staminaCost: BardActions[index].cost))
                }
            }
        }
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
    

    func checkAllEnemiesInvisible() {
        var areAllInvisible: Bool = true
        for enemies in enemiesList {
            if enemies.isInvisible == false {
                areAllInvisible = false
            }
        }
       if areAllInvisible {
           selectRandomEnemy()
       }
    }
    
    func checkDeadOrAsleep() {
        print(localCharacter.isDead)
        if localCharacter.isDead || localCharacter.isAsleep {
            let popUp = createPopUpDeadAsleep()
            self.view.addSubview(popUp)
            endTurn(game: game, player: localCharacter.userName)
            let seconds = 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            }
        }
    }

    func isInvisible_label() {
       let invisible = createLabel(x: 40, y: 300, w: 200, h: 30, font: "munro", size: 15, text: "* You are invisible!", align: .left)
       self.view.addSubview(invisible)
    }
    
    func selectRandomTeamMember() {
        var randomMember = Int.random(in: 1...teamList.count)
        if rowSelected?.name == "Animate the Dead" {
            // if action is animate the dead don't want to animate yourself on accident
            while teamList[randomMember].userName == localCharacter.userName {
                randomMember = Int.random(in: 1...teamList.count)
            }
        }
        let blankButton = UIButton()
        blankButton.backgroundColor = .clear
        blankButton.setTitle("", for: .normal)
        if randomMember == 1 {
            player1Selected(blankButton)
        } else if randomMember == 2 {
            player2Selected(blankButton)
        } else if randomMember == 3 {
            player3Selected(blankButton)
        } else if randomMember == 4 {
            player4Selected(blankButton)
        }
        let seconds = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            // Decide if the player needs to roll or not
             if(actionRequiresRoll()) {
                 let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController

                 self.modalPresentationStyle = .fullScreen
                 vc.modalPresentationStyle = .fullScreen
                 self.present(vc,animated: false)
             } else {
                 performBattleAction()
                 let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                 let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                 self.modalPresentationStyle = .fullScreen
                 vc.modalPresentationStyle = .fullScreen
                 self.present(vc,animated: false)
             }
        }
    }

    func selectRandomEnemy() {
        // check if all the enemies are dead
        // TODO: when ready to finish battle as all enemies are dead uncomment this checker method
       // checkAllEnemiesDead()
       // edit change to enemy count instead of 4
        var randomEnemy = Int.random(in: 1...enemiesList.count)
        // while the enemy chosen is dead select new random enemy until an enemy that is not dead is chosen
        while enemiesList[randomEnemy].isDead {
            randomEnemy = Int.random(in: 1...enemiesList.count)
        }
       let blankButton = UIButton()
       blankButton.backgroundColor = .clear
       blankButton.setTitle("", for: .normal)
       if randomEnemy == 1 {
           enemy1Selected(blankButton)
       } else if randomEnemy == 2 {
           enemy2Selected(blankButton)
       } else if randomEnemy == 3 {
           enemy3Selected(blankButton)
       } else if randomEnemy == 4 {
           enemy4Selected(blankButton)
       }
       let seconds = 1.5
       DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
           let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           // Decide if the player needs to roll or not
            if(actionRequiresRoll()) {
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController
                vc.selectTargetInfo = (enemiesList[0].userName, enemiesList[1].userName, enemiesList[2].userName, enemiesList[3].userName, rowSelected!)

                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            } else {
                performBattleAction()
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            }
       }
    }

    func createPopUpBlind() -> UIView {
       // view to display
       let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
       popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)

       // label based on blind or invisible
       let label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
       label.text = "You are blind\nYour enemy will be randomly selected for you\nPlease select an action it will be completed for you"
       label.font = UIFont(name: "munro", size: 20)
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.textColor = UIColor.black
       label.backgroundColor = UIColor.clear
       popView.addSubview(label)

       // popView border
       popView.layer.borderWidth = 1.0
       popView.layer.borderColor = UIColor.black.cgColor

       return popView
    }
    
    func createPopUpDeadAsleep() -> UIView {
       // view to display
       let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
       popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)

       // label based on dead or asleep
       let label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
        if localCharacter.isDead {
            label.text = "You are dead\nYour turn will now be skipped for you"
            label.font = UIFont(name: "munro", size: 20)
        } else if localCharacter.isAsleep {
            label.text = "You are asleep\nYour turn will now be skipped for you"
        }
       label.font = UIFont(name: "munro", size: 20)
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.textColor = UIColor.black
       label.backgroundColor = UIColor.clear
       popView.addSubview(label)

       // popView border
       popView.layer.borderWidth = 1.0
       popView.layer.borderColor = UIColor.black.cgColor

       return popView
    }
    
}

struct CharacterSprites {
    var name:String
    
    func drawCharacter(view:UIView, x:Int, y:Int, width:Int, height:Int, isInvisible:Bool, isHurt:Bool, isDead:Bool) -> UIImageView!{
        var image = UIImage(named:name)
        if localCharacter.blood {
            image = UIImage(named:name+"-Blood")
        }
        if isHurt {
            print("Is Hurt")
            image = UIImage(named:name+"-Hurt")
        }
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x, y: y, width: width, height: height))
        imageView.image = image
        if isDead {
            imageView?.image = UIImage(named: "Skeleton")
        }
        if isInvisible == false {
           view.addSubview(imageView)
        } else if isInvisible == true && isDead {
           view.addSubview(imageView)
        }
        return imageView
    }
    
    func drawButtonCharacter(controller:UIViewController, x:Int, y:Int, width:Int, height:Int) -> UIButton {
        var imageName = name
        if localCharacter.blood {
            imageName = "\(name)-Blood"
        }
        let characterButton = controller.createButton(x:x, y:y, width:width, height:height, fontName: "munro", imageName:imageName, fontColor: UIColor.black, buttonTitle:"")
        return characterButton
    }
}

func performBattleAction(rollValue: Int? = nil) {
    let actionPerformed: String = rowSelected?.name! ?? "Fight"
    // rowSelected holds your action struct

    // Validating character name with actions they can doo
    if (localCharacter.getCharacterClass() == "Fighter"){
        switch actionPerformed {
        case "Second Wind":
            (localCharacter as! Fighter).secondWind()
        case "Action Surge":
            (localCharacter as! Fighter).actionSurge(rollValue: rollValue!)
        case "Sharpen Weapon":
            (localCharacter as! Fighter).sharpenWeapon()
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    } else if (localCharacter.getCharacterClass() == "Rogue") {
        switch actionPerformed {
        case "Uncanny Dodge":
            (localCharacter as! Rogue).uncannyDodge()
        case "Hone Skill":
            (localCharacter as! Rogue).honeSkill()
        case "Insight":
            (localCharacter as! Rogue).insight()
        case "Allsight":
            (localCharacter as! Rogue).allSight()
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    } else if (localCharacter.getCharacterClass() == "Wizard") {
        switch actionPerformed {
        case "Frost Bite":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).castFrostbite(rollValue: rollValue!)
        case "Mage Hand":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).castMageHand(rollValue: rollValue!)
        case "Shield":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).castShield()
        case "Sleep":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).sleep(rollValue: rollValue!)
        case "Animate the Dead":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).castAnimateDead()
        case "Heal":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Wizard).heal(amtToHeal: rollValue!)
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    } else if (localCharacter.getCharacterClass() == "Bard") {
        switch actionPerformed {
        case "Mage Hand":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castMageHand(rollValue: rollValue!)
        case "Bardic Inspiration":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castBardicInspiration()
        case "Vicious Mockery":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castViciousMockery(rollValue: rollValue!)
        case "Blindness":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castBlindness(rollValue: rollValue!)
        case "Invisibility":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castInvisibility()
        case "Motivational Speech":
            playSoundEffect(fileName: castSpellEffect)
            (localCharacter as! Bard).castMotivationalSpeech()
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    }
    endTurn(game: game, player: localCharacter.userName)
}

func checkAllEnemiesDead() -> Bool {
    for enemy in enemiesList {
        if !enemy.isDead {
            return false
        }
    }
    return true
}
