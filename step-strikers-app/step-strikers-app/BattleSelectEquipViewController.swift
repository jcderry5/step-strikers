//
//  BattleSelectEquipViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleSelectEquipViewController: UIViewController, UITableViewDataSource {
    
    // array to store items that would exist in the equip menu
    var equips: [Equip] = [Equip]()
    let equipCellId = "equipCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // background view items based on which submenu is being viewed
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: unselectedButton, itemSelected: unselectedButton, equipSelected: selectedButton)
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
        
        // create Table to display all the Items that a player can equip
        // creates the array of all the data to be displayed
        createEquipArray()
        // creates the table frame
        let equipDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        equipDisplay.translatesAutoresizingMaskIntoConstraints = false
        equipDisplay.dataSource = self
        // registers the tableview
        equipDisplay.register(EquipTableViewCell.self, forCellReuseIdentifier: equipCellId)
        // sets the table to have a clear background
        equipDisplay.backgroundColor = UIColor.clear
        // add it to the overall view of the the viewController
        self.view.addSubview(equipDisplay)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: equipCellId, for: indexPath) as! EquipTableViewCell
        let currentLastAction = equips[indexPath.row]
        cell.equip = currentLastAction
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        let rowValue = equips[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        
        return UITableView.automaticDimension
    }

    // TODO: change this array based on actual player data
    func createEquipArray() {
        equips.append(Equip(name: "one", quantity: "x5"))
        equips.append(Equip(name: "two", quantity: "x5"))
        equips.append(Equip(name: "three", quantity: "x5"))
        equips.append(Equip(name: "four", quantity: "x5"))
        equips.append(Equip(name: "five", quantity: "x5"))
        equips.append(Equip(name: "six", quantity: "x5"))
        equips.append(Equip(name: "seven", quantity: "x5"))
        equips.append(Equip(name: "eight", quantity: "x5"))
        equips.append(Equip(name: "nine", quantity: "x5"))
        equips.append(Equip(name: "ten", quantity: "x5"))
    }

}

struct Equip {
    let name:String?
    let quantity:String?
}
