//
//  BattleSelectEquipViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

var statsDisplay:UITableView = UITableView()
var equipLongPressed:Equip?

class BattleSelectEquipViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // array to store items that would exist in the equip menu
    var equips: [Equip] = [Equip]()
    let equipCellId = "equipCell"
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var stats: [StatsRow] = [StatsRow]()
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var equipDisplay:UITableView = UITableView()
    var recentlyTapped:Int = 1000
    var selected:Bool = false
    var rowEquipSelected:Equip?
    var weaponEquiped:Equip?
    var helpPopUp: UIView?
    var helpButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayEnemies(enemyTeam: enemyTeam)
        // Do any additional setup after loading the view.
        
        // background view items based on which submenu is being viewed
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        createBattleActionButtons(actionSelected: unselectedButton, itemSelected: unselectedButton, equipSelected: selectedButton)
        
        // create characters
        // will need to change "name" based on what the enemy players are
//        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
        
        // create Table to display all the Items that a player can equip
        // creates the array of all the data to be displayed
        selected = false
        createEquipArray()
        // creates the table frame
        equipDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        equipDisplay.translatesAutoresizingMaskIntoConstraints = false
        equipDisplay.dataSource = self
        // registers the tableview
        equipDisplay.register(EquipTableViewCell.self, forCellReuseIdentifier: equipCellId)
        equipDisplay.delegate = self
        // sets the table to have a clear background
        equipDisplay.backgroundColor = UIColor.clear
        // add it to the overall view of the the viewController
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(helpPressed))
        equipDisplay.addGestureRecognizer(longPress)
        self.view.addSubview(equipDisplay)
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == equipDisplay {
            return equips.count
        } else if tableView == statsDisplay {
            return stats.count
        }
        return equips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == equipDisplay {
            let cell = tableView.dequeueReusableCell(withIdentifier: equipCellId, for: indexPath) as! EquipTableViewCell
            let currentLastAction = equips[indexPath.row]
            cell.equip = currentLastAction
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
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        if recentlyTapped == indexPath.row && selected == true {
            selected = false
            tableView.deselectRow(at: indexPath, animated: false)
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectEquipViewController") as! BattleSelectEquipViewController
            
            // TODO: @Alekhya: make text in cell red here once selected (tbh I have no idea how to do that, custom cell tings)
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
        } else {
            selected = true
            rowEquipSelected = equips[indexPath.row]
            recentlyTapped = indexPath.row
            equipItem(item: rowEquipSelected!)
        }
    }
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
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
        helpPopUp?.removeFromSuperview()
        
        // view to display
        let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
        popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
        
        // label based on blind or invisible
        var label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
        label.text = ""
        for (index, equip) in equips.enumerated() {
            let equipDescription = equipDescription(equipName: equip.name!)
            label.text!.append("\(equip.name!): \(equipDescription)\n")
        }
        label.font = UIFont(name: "munro", size: 15)
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
        var equipName:String = " "
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: equipDisplay)
            if let indexPath = equipDisplay.indexPathForRow(at: touchPoint){
                helpPopUp?.removeFromSuperview()
                equipName = equips[indexPath.row].name!
                equipLongPressed = equips[indexPath.row]
                
                // view to display
                let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
                popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)
                
                // label based on blind or invisible
                let label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
                let equipDescription = equipDescription(equipName: equipName)
                label.text = "\(equipName): \(equipDescription)"
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
        // remove pop up
        helpPopUp?.removeFromSuperview()
    }

    func equipItem(item: Equip) {
        guard allWeapons.contains(item.name!) || allArmor.contains(item.name!) else {
            print("\(String(describing: item.name)) is not a weapon nor armor")
            return
        }
    
        let quantity: Int = Int((item.quantity?.suffix(1))!)!
        
        if allWeapons.contains(item.name!) {
            // just initializing weaponToEquip with first armor. Will be replaced
            var weaponToEquip: Weapon = localCharacter.weaponsInInventory[0]
            if quantity > 1 {
                for weapon in localCharacter.weaponsInInventory {
                    if weapon.name == item.name! && weapon.useCount > weaponToEquip.useCount {
                        weaponToEquip = weapon
                    }
                }
            } else {
                weaponToEquip = localCharacter.weaponsInInventory.first(where: {weapon in weapon.name == item.name!})!
            }
            localCharacter.wield(weaponObject: weaponToEquip)
        } else {
            // just initializing armorToEquip with first armor. Will be replaced
            var armorToEquip: Armor = localCharacter.armorInInventory[0]
            if quantity > 1 {
                for armor in localCharacter.armorInInventory {
                    if armor.name == item.name! && armor.useCount > armorToEquip.useCount {
                        armorToEquip = armor
                    }
                }
            } else {
                armorToEquip = localCharacter.armorInInventory.first(where: {armor in armor.name == item.name!})!
            }
            localCharacter.wear(armorObject: armorToEquip)
        }
    }
    
    // TODO: change this array based on actual player data
    func createEquipArray() {
        let weaponsArr = localCharacter.weaponsInInventory
        var quantities = localCharacter.inventoryQuantities
        for weapon in weaponsArr {
            if quantities.keys.contains(weapon.name) {
                equips.append(Equip(name: weapon.name, quantity: "x\(quantities[weapon.name]!)"))
                quantities.removeValue(forKey: weapon.name)
            }
        }
        
        let armorArr = localCharacter.armorInInventory
        for armor in armorArr {
            if quantities.keys.contains(armor.name) {
                equips.append(Equip(name: armor.name, quantity: "x\(quantities[armor.name]!)"))
                quantities.removeValue(forKey: armor.name)
            }
        }
        
    }
    
    func createStatsArray() {
        var nameArray:[String] = [String]()
        var healthPoints:[Int] = [Int]()
        var spellPoints:[Int] = [Int]()
        var staminaPoints:[Int] = [Int]()
        for member in teamList {
            nameArray.append(member.userName)
            healthPoints.append(member.health)
            spellPoints.append(member.spellPoints)
            staminaPoints.append(member.stamina)
        }
        header.append(StatsHeaderRow(names: nameArray))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: [30, 30, 30, 30]))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: [30, 30, 30, 30]))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: spellPoints, totalPoints: [30, 30, 30, 30]))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points: staminaPoints, totalPoints: [30, 30, 30, 30]))
    }

}
