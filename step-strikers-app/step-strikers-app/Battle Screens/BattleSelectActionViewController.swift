//
//  BattleSelectActionViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

var boxArrow: [AnyObject] = [AnyObject]()
var rowSelected:Action?
// Dummy currTarget, until get's set by action
var currTarget: currTargetData = currTargetData(name: "EmptyPlayer", userName: "emptyPlayer", character_class: "Fighter", health: 30, armor: noArmor(), modifiedArmorClass: 0, attackModifier: 0, defenseModifier: 0, armorInInventory: [noArmor()], isBlind: false, isDead: false, isSleep: false, isInvisible: false, magicResistanceModifier: 0, currWeapon: fists(), weaponInventory: [fists()], hasAdvantage: false, hasDisadvantage: false)
var actions: [Action] = [Action]()
var player: String = ""
var game: String = ""
var team:String = "" // TODO: @Kelly, Set this global var

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTeam(enemyTeam: "4bDfA6dWfv8fRSdebjWI")
        renderEnemies(enemyTeam: "4bDfA6dWfv8fRSdebjWI")
        // puts full screen image as background of view controller
        // sets up the background images of the view controller
        // THESE NEED TO HAPPEN IN ORDER!!!!
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: selectedButton, itemSelected: unselectedButton, equipSelected: unselectedButton)
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
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
        
        // turn skipped if you are dead or asleep
        checkDeadOrAsleep()
        
        // blind only pop up
        // TODO: change to the blind and invisible variables from localCharacter object
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
        print(enemiesList[0].name)
        if recentlyTapped == indexPath.row && selected == true {
            selected = false
            if characterButtons.isEmpty == false {
               characterButtons[0].removeFromSuperview()
               characterButtons[1].removeFromSuperview()
               characterButtons[2].removeFromSuperview()
               characterButtons[3].removeFromSuperview()
           }
            selectEnemyLabel.removeFromSuperview()
            selectPlayerLabel.removeFromSuperview()
            
            if boxArrow.isEmpty == false {
                boxArrow[0].removeFromSuperview()
                boxArrow[1].removeFromSuperview()
                boxArrow[2].removeFromSuperview()
            }
            tableView.deselectRow(at: indexPath, animated:false)
            // TODO: change to the blind variable from localCharacter object
            if localCharacter.isBlind == false {
                self.view.addSubview(enemiesList[0].imageView)
                self.view.addSubview(enemiesList[1].imageView)
                self.view.addSubview(enemiesList[2].imageView)
                self.view.addSubview(enemiesList[3].imageView)
            }
        } else {
            selected = true
            rowSelected = actions[indexPath.row] // Actions stuct (holds
            recentlyTapped = indexPath.row
            if tableView == actionDisplay {
                // TODO: @Jalyn rowSelected (global) holds the action object/struct of the row selected, rowSelected.name is the string itself
                print("selected row")
                enemiesList[0].imageView.removeFromSuperview()
                enemiesList[1].imageView.removeFromSuperview()
                enemiesList[2].imageView.removeFromSuperview()
                enemiesList[3].imageView.removeFromSuperview()
                selectEnemyLabel.removeFromSuperview()
                if boxArrow.isEmpty == false {
                    boxArrow[0].removeFromSuperview()
                    boxArrow[1].removeFromSuperview()
                    boxArrow[2].removeFromSuperview()
                }
                // will need to resave if the player deselects, but if you do it here it'll override
                
                // Decide if the player needs to select an enemy
                if(actionRequiresEnemy()) {
                    // TODO: change to the blind variable from localCharacter object
                    if localCharacter.isBlind {
                        if actionTargetsTeam() {
                            selectRandomTeamMember()
                        } else {
                            selectRandomEnemy()
                        }
                        if boxArrow.isEmpty == false {
                            boxArrow[0].removeFromSuperview()
                            boxArrow[1].removeFromSuperview()
                            boxArrow[2].removeFromSuperview()
                        }
                    } else {
                        if actionTargetsTeam() {
                            playerButtons = drawPlayerButtons(player1: teamList[0].character_class, player2:    teamList[1].character_class, player3: teamList[2].character_class, player4: teamList[3].character_class)
                        } else {
                            characterButtons = drawEnemiesButton(enemy1: enemiesList[0].character_class, enemy2: enemiesList[1].character_class, enemy3: enemiesList[2].character_class, enemy4: enemiesList[3].character_class)
                            checkAllEnemiesInvisible()
                        }
                    }
                } else {
                    // TODO: Test this with server running
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
                    actions.append(Action(name:WizardActions[index].actionName, staminaCost: RogueActions[index].cost))
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
        // TODO: update all instances of this method
        header.append(StatsHeaderRow(names: ["Host", "Player 1", "Player 2", "Player 3"]))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points:[1,2,3,4] , totalPoints: [1,2,3,4]))
    }
    

    func checkAllEnemiesInvisible() {
       if enemiesList[0].isInvisible && enemiesList[1].isInvisible && enemiesList[2].isInvisible && enemiesList[3].isInvisible {
           selectRandomEnemy()
       }
    }

    func checkAllEnemiesDead() {
        if enemiesList[0].isDead && enemiesList[1].isDead && enemiesList[2].isDead && enemiesList[3].isDead {
                // segue to battle results screen?
                // probably victory since all enemies are dead
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BattleResultsVictoryViewController") as! BattleResultsVictoryViewController
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
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
        var randomMember = Int.random(in: 0...3)
        if rowSelected?.name == "Animate the Dead" {
            // if action is animate the dead don't want to animate yourself on accident
            while teamList[randomMember].userName == localCharacter.userName {
                randomMember = Int.random(in: 0...3)
            }
        }
        let blankButton = UIButton()
        blankButton.backgroundColor = .clear
        blankButton.setTitle("", for: .normal)
        if randomMember == 0 {
            player1Selected(blankButton)
        } else if randomMember == 1 {
            player2Selected(blankButton)
        } else if randomMember == 2 {
            player3Selected(blankButton)
        } else if randomMember == 3 {
            player4Selected(blankButton)
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
                 // TODO: Test with server running
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
       var randomEnemy = Int.random(in: 1...4)
        // while the enemy chosen is dead select new random enemy until an enemy that is not dead is chosen
        while enemiesList[randomEnemy].isDead {
            randomEnemy = Int.random(in: 1...4)
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
                // TODO: Test with server running
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

// TODO: remove these functions to the UIViewController extension and use the information set from Game.swift (?)
struct characterSprites {
    var name:String
    
    func drawCharacter(view:UIView, x:Int, y:Int, width:Int, height:Int, isInvisible:Bool, isDead:Bool) -> UIImageView!{
        let image = UIImage(named:name)
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
        let imageName = name
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
            (localCharacter as! Wizard).castFrostbite(rollValue: rollValue!)
        case "Mage Hand":
            (localCharacter as! Wizard).castMageHand(rollValue: rollValue!)
        case "Shield":
            (localCharacter as! Wizard).castShield()
        case "Sleep":
            (localCharacter as! Wizard).sleep(rollValue: rollValue!)
        case "Animate the Dead":
            (localCharacter as! Wizard).castAnimateDead()
        case "Heal":
            (localCharacter as! Wizard).heal(amtToHeal: rollValue!)
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    } else if (localCharacter.getCharacterClass() == "Bard") {
        switch actionPerformed {
        case "Mage Hand":
            (localCharacter as! Bard).castMageHand(rollValue: rollValue!)
        case "Bardic Inspiration":
            (localCharacter as! Bard).castBardicInspiration()
        case "Vicious Mockery":
            (localCharacter as! Bard).castViciousMockery(rollValue: rollValue!)
        case "Blindness":
            (localCharacter as! Bard).castBlindness(rollValue: rollValue!)
        case "Invisibility":
            (localCharacter as! Bard).castInvisibility()
        case "Motivational Speech":
            (localCharacter as! Bard).castMotivationalSpeech()
        default:
            localCharacter.fight(rollValue: rollValue!)
        }
    }
    endTurn(game: game, player: localCharacter.userName)
}
