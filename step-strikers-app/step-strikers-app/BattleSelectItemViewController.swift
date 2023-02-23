//
//  BattleSelectItemViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleSelectItemViewController: UIViewController, UITableViewDataSource {

    var items: [Item] = [Item]()
    let itemCellId = "itemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: unselectedButton, itemSelected: selectedButton, equipSelected: unselectedButton)
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
        // create UI Table View with
        createItemArray()
        let itemDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        itemDisplay.translatesAutoresizingMaskIntoConstraints = false
        itemDisplay.dataSource = self
        itemDisplay.register(ItemTableViewCell.self, forCellReuseIdentifier: itemCellId)
        itemDisplay.backgroundColor = UIColor.clear
        self.view.addSubview(itemDisplay)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! ItemTableViewCell
        let currentLastAction = items[indexPath.row]
        cell.item = currentLastAction
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        let rowValue = items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        
        return UITableView.automaticDimension
    }

    func createItemArray() {
        items.append(Item(name: "one", quantity: "x5"))
        items.append(Item(name: "two", quantity: "x5"))
        items.append(Item(name: "three", quantity: "x5"))
        items.append(Item(name: "four", quantity: "x5"))
        items.append(Item(name: "five", quantity: "x5"))
        items.append(Item(name: "six", quantity: "x5"))
        items.append(Item(name: "seven", quantity: "x5"))
        items.append(Item(name: "eight", quantity: "x5"))
        items.append(Item(name: "nine", quantity: "x5"))
        items.append(Item(name: "ten", quantity: "x5"))
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct Item {
    let name:String?
    let quantity:String?
}
