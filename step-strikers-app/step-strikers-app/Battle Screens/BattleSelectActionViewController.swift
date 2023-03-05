//
//  BattleSelectActionViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

var boxArrow: [AnyObject] = [AnyObject]()
var rowSelected:Action?
var currTarget: currTargetData = currTargetData(name: "", character_class: "", health: 30, armor: noArmor(), defenseModifier: 0, armorInInventory: [noArmor()]) //TODO: @jalyn fix later...need to initialize it to something
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
    var selected:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            characterButtons[0].removeFromSuperview()
            characterButtons[1].removeFromSuperview()
            characterButtons[2].removeFromSuperview()
            characterButtons[3].removeFromSuperview()
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
            tableView.deselectRow(at: indexPath, animated:false)
            self.view.addSubview(enemiesList[0].imageView)
            self.view.addSubview(enemiesList[1].imageView)
            self.view.addSubview(enemiesList[2].imageView)
            self.view.addSubview(enemiesList[3].imageView)
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
                if boxArrow.isEmpty == false {
                    boxArrow[0].removeFromSuperview()
                    boxArrow[1].removeFromSuperview()
                    boxArrow[2].removeFromSuperview()
                }
                // TODO: save the function clicked here
                // will need to resave if the player deselects, but if you do it here it'll override
                characterButtons = drawEnemiesButton(enemy1: enemiesList[0].character_class, enemy2: enemiesList[1].character_class, enemy3: enemiesList[2].character_class, enemy4: enemiesList[3].character_class)
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
        let characterClass = LocalCharacter.getCharacterClass()
        print(characterClass)
        if characterClass == "Fighter" {
            for index in 0 ... (FighterActions.count-1) {
                actions.append(Action(name:FighterActions[index].actionName, staminaCost: FighterActions[index].cost))
            }
        } else if characterClass == "Wizard" {
            for index in 0 ... (WizardActions.count-1) {
                actions.append(Action(name:WizardActions[index].actionName, staminaCost: WizardActions[index].cost))
            }
        } else if characterClass == "Rogue" {
            for index in 0 ... (RogueActions.count-1) {
                actions.append(Action(name:WizardActions[index].actionName, staminaCost: RogueActions[index].cost))
            }
        } else if characterClass == "Bard" {
            for index in 0 ... (BardActions.count-1) {
                actions.append(Action(name:BardActions[index].actionName, staminaCost: BardActions[index].cost))
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
    

    
    
}

// TODO: remove these functions to the UIViewController extension and use the information set from Game.swift (?)
struct characterSprites {
    var name:String
    
    func drawCharacter(view:UIView, x:Int, y:Int, width:Int, height:Int) -> UIImageView!{
        let image = UIImage(named:name)
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x, y: y, width: width, height: height))
        imageView.image = image
        view.addSubview(imageView)
        return imageView
    }
    
    func drawButtonCharacter(controller:UIViewController, x:Int, y:Int, width:Int, height:Int) -> UIButton {
        let imageName = name
        let characterButton = controller.createButton(x:x, y:y, width:width, height:height, fontName: "munro", imageName:imageName, fontColor: UIColor.black, buttonTitle:"")
        return characterButton
    }
}

func performBattleAction() {
    let actionPerformed: String = rowSelected?.name! ?? "Fight"
    // rowSelected holds your action struct
    
    // Generic action all players can do
    if actionPerformed == "Fight" {LocalCharacter.fight()}
    
    print("The action performed= \(actionPerformed)")
    // Validating character name with actions they can doo
    if (LocalCharacter.getCharacterClass() == "Fighter"){
        switch actionPerformed {
        case "Second Wind":
            (LocalCharacter as! Fighter).secondWind()
        case "Action Surge":
            (LocalCharacter as! Fighter).actionSurge()
        case "Sharpen Weapon":
            (LocalCharacter as! Fighter).sharpenWeapon()
        default:
            print("A fighter is trying to do a non-fighter action")
            LocalCharacter.fight()
        }
    } else if (LocalCharacter.getCharacterClass() == "Rogue") {
        switch actionPerformed {
        case "Uncanny Dodge":
            (LocalCharacter as! Rogue).uncannyDodge()
        case "Hone Skill":
            (LocalCharacter as! Rogue).honeSkill()
        case "Insight":
            (LocalCharacter as! Rogue).insight()
        case "Allsight":
            (LocalCharacter as! Rogue).allSight()
        default:
            print("A Rogue is trying to do a non-rogue action")
            LocalCharacter.fight()
        }
    } else if (LocalCharacter.getCharacterClass() == "Wizard") {
        switch actionPerformed {
        case "Frost Bite":
            (LocalCharacter as! Wizard).castFrostbite(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Mage Hand":
            (LocalCharacter as! Wizard).castMageHand(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Shield":
            (LocalCharacter as! Wizard).castShield(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Sleep":
            (LocalCharacter as! Wizard).sleep(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Animate the Dead":
            (LocalCharacter as! Wizard).castAnimateDead(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Heal":
            (LocalCharacter as! Wizard).heal(caster: LocalCharacter.characterName, target: currTarget.name)
        default:
            print("A wizard is trying to do a non-wizard action")
            LocalCharacter.fight()
        }
    } else if (LocalCharacter.getCharacterClass() == "Bard") {
        switch actionPerformed {
        case "Mage Hand":
            (LocalCharacter as! Bard).castMageHand(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Bardic Inspiration":
            (LocalCharacter as! Bard).castBardicInspiration(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Vicious Mockery":
            (LocalCharacter as! Bard).castViciousMockery(caster: LocalCharacter.characterName, target: currTarget.name)
        case "Blindness":
            (LocalCharacter as! Bard).castBlindness(caster: LocalCharacter.characterName, target: currTarget.name, game: game)
        case "Invisibility":
            (LocalCharacter as! Bard).castInvisibility(caster: LocalCharacter.characterName, target: currTarget.name, game: game)
        case "Motivational Speech":
            (LocalCharacter as! Bard).castMotivationalSpeech(caster: LocalCharacter.characterName, team: team)
        default:
            print("A bard is trying to do a non-bard action")
            LocalCharacter.fight()
        }
    }
    print("Just finished perform battle action. Here are new enemy stats")
    currTarget.printEnemyData()
    print("Here are the stats of Local Character")
    LocalCharacter.printLocalCharacterDetailsToConsole()
}
