//
//  BattleSelectItemViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

var rowItemSelected:Items?

class BattleSelectItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // array of the items to be displayed in the items menu in battle
    var items: [Items] = [Items]()
    let itemCellId = "itemCell"
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var stats: [StatsRow] = [StatsRow]()
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var statsDisplay:UITableView = UITableView()
    var itemDisplay:UITableView = UITableView()
    var recentlyTapped:Int = 1000
    var selected:Bool = false
    var characters: [UIImageView] = [UIImageView]()
    var playerButtons: [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        renderTeam(playerTeam: "4bDfA6dWfv8fRSdebjWI")
        displayEnemies(enemyTeam:  enemyTeam)
        // Do any additional setup after loading the view.
        // background images and view set up
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: unselectedButton, itemSelected: selectedButton, equipSelected: unselectedButton)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        // TODO: change based to reflect the actual classes that enemies have
//        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
        
        // create a Table View that displays the item menu, and when pressed does something
        // TODO: set up the transfer to the select target screen when a item is selected
        // the array of all the items a player has
        createItemArray()
        // frame for where table view should be located
        itemDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        itemDisplay.translatesAutoresizingMaskIntoConstraints = false
        itemDisplay.dataSource = self
        // registers the table with the display
        itemDisplay.register(ItemTableViewCell.self, forCellReuseIdentifier: itemCellId)
        // sets the background of the table to transparent
        itemDisplay.backgroundColor = UIColor.clear
        itemDisplay.delegate = self
        self.view.addSubview(itemDisplay)
        
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
        if tableView == itemDisplay {
            return items.count
        } else if tableView == statsDisplay {
            return stats.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == itemDisplay {
            let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! ItemTableViewCell
            let currentLastAction = items[indexPath.row]
            cell.item = currentLastAction
            cell.backgroundColor = UIColor.clear
            return cell
        } else if tableView == statsDisplay {
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
    
    // TODO: complete for when a row is selected to segue to Battle Item Select target screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        if recentlyTapped == indexPath.row && selected == true {
            selected = false
            for index in playerButtons.indices {
                playerButtons[index].removeFromSuperview()
            }
            for index in boxArrow.indices {
                boxArrow[index].removeFromSuperview()
            }
            tableView.deselectRow(at: indexPath, animated:false)
        } else {
        selected = true
        rowItemSelected = items[indexPath.row]
        recentlyTapped = indexPath.row
            if tableView == itemDisplay {
                
                print("selected row")
                if boxArrow.isEmpty == false {
                    for index in boxArrow.indices {
                        boxArrow[index].removeFromSuperview()
                    }
                }
                
                playerButtons = drawPlayerButtons()
//                boxArrow = drawSelectBoxButtonArrowItem(x: 40, y: 130, width: 70, height: 150)
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

    // TODO: Update with actual item data
    func createItemArray() {
        let itemsArr = localCharacter.itemsInInventory
        var quantities = localCharacter.inventoryQuantities
        for invItem in itemsArr {
            if quantities.keys.contains(invItem.name) {
                items.append(Items(name: invItem.name, quantity: "x\(quantities[invItem.name]!)"))
                quantities.removeValue(forKey: invItem.name)
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
}
