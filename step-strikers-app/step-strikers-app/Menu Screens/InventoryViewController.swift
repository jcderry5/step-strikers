//
//  InventoryViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/3/23.
//

import UIKit

struct inventoryStruct {
    var name:String
    var image:UIImage
    var quantity:Int
}

class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var inventoryTable:UITableView = UITableView()
    let cellId = "inventoryCell"
    var inventoryArr:[inventoryStruct] = [inventoryStruct]()
    
    let buttonImg = UIImage(named:"Menu Button")
    let selectedImg = UIImage(named:"Selected Menu Button")
    var weaponsButton:UIButton = UIButton()
    var armorButton:UIButton = UIButton()
    var itemsButton:UIButton = UIButton()
    
    var segCtrl:UISegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        
        // Create menu title label
        _ = createImage(x: 27, y: 0, w: 338, h: 200, name: "Menu Title Board")
        _ = createLabel(x: 53, y: 91, w: 286, h: 89, font: "iso8", size: 45, text: "INVENTORY", align: .center)
        
        // Create the display board and its contents
        _ = createImage(x: 0, y: 219, w: 393, h: 374, name: "Display Board")
        inventoryTable = UITableView(frame: CGRect(x:15, y:234, width:363, height:344))
        inventoryTable.translatesAutoresizingMaskIntoConstraints = false
        inventoryTable.dataSource = self
        
        // Register tableview
        inventoryTable.register(InventoryTableViewCell.self, forCellReuseIdentifier: cellId)
        inventoryTable.delegate = self
        inventoryTable.backgroundColor = UIColor.clear
        inventoryTable.layer.borderWidth = 2
        view.addSubview(inventoryTable)
        
        // Inventory segmented controller
        segCtrl = UISegmentedControl(items:["WEAPONS", "ARMOR", "ITEMS"])
        // Set attributes for each segment
        segCtrl.frame = CGRect(x: 15, y: 620, width: Int(view.frame.maxX)-30, height: 70)
        segCtrl.selectedSegmentIndex = 0
        segCtrl.setBackgroundImage(buttonImg, for: .normal, barMetrics: .default)
        segCtrl.setBackgroundImage(selectedImg, for: .selected, barMetrics: .default)
        segCtrl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name:"munro", size:24)!], for: .normal)
        segCtrl.setWidth(115, forSegmentAt: 0)
        segCtrl.setWidth(115, forSegmentAt: 1)
        segCtrl.setWidth(115, forSegmentAt: 2)
        // Format divider image between each segment
        // Side note: doesn't seem like you can add space b/w segments
        var divider = UIImage(named:"segment_divider")
        UIGraphicsBeginImageContext(CGSizeMake(9, 70))
        divider!.draw(in: CGRectMake(0, 0, 9, 70))
        divider = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        segCtrl.setDividerImage(divider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segCtrl.addTarget(self, action: #selector(onSegmentChanged), for: .valueChanged)
        view.addSubview(segCtrl)
        
        // Populate the table with weapons on load
        let weaponsArr = localCharacter.weaponsInInventory
        var quantities = localCharacter.inventoryQuantities
        for weapon in weaponsArr {
            if weapon.name != "Fists" && quantities.keys.contains(weapon.name) {
                inventoryArr.append(inventoryStruct(name: weapon.name, image: UIImage(named:weapon.name) ?? UIImage(named:"battle axe")!, quantity: quantities[weapon.name]!))
                quantities.removeValue(forKey: weapon.name)
            }
        }
        
        // Swipe display
        _ = createImage(x: 140, y: 716, w: 112, h: 112, name: "backpack")
        _ = createLabel(x: 285, y: 690, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 275, y: 739, w: 112, h: 62, name: "right arrow")
        _ = createLabel(x: 16, y: 690, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 16, y: 734, w: 92, h: 67, name: "left arrow")
        
        // Swipe left handler
        let swipeView = UIView(frame: CGRect(x: 0, y: 677, width: 393, height: 120))
        view.addSubview(swipeView)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
        
        // Swipe right handler
        view.addSubview(swipeView)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        swipeView.addGestureRecognizer(swipeRight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InventoryTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.inventoryObj = inventoryArr[indexPath.row]
        return cell
    }
    
    // Adjust size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc func onSegmentChanged(_ sender: UISegmentedControl!) {
        // TODO: Combine duplicate weapons/armor/items into one inventoryObj (quantity counter)
        // Replace tableview cells depending on selected index
        inventoryArr.removeAll()
        switch segCtrl.selectedSegmentIndex {
        case 0:
            let weaponsArr = localCharacter.weaponsInInventory
            var quantities = localCharacter.inventoryQuantities
            for weapon in weaponsArr {
                if weapon.name != "Fists" && quantities.keys.contains(weapon.name) {
                    inventoryArr.append(inventoryStruct(name: weapon.name, image: UIImage(named:weapon.name) ?? UIImage(named:"battle axe")!, quantity: quantities[weapon.name]!))
                    quantities.removeValue(forKey: weapon.name)
                }
            }
        case 1:
            let armorArr = localCharacter.armorInInventory
            var quantities = localCharacter.inventoryQuantities
            for armor in armorArr {
                if armor.name != "No Armor" && quantities.keys.contains(armor.name) {
                    inventoryArr.append(inventoryStruct(name: armor.name, image: UIImage(named:armor.name) ?? UIImage(named:"battle axe")!, quantity: quantities[armor.name]!))
                    quantities.removeValue(forKey: armor.name)
                }
            }
        case 2:
            let itemsArr = localCharacter.itemsInInventory
            var quantities = localCharacter.inventoryQuantities
            for item in itemsArr {
                if quantities.keys.contains(item.name) {
                    inventoryArr.append(inventoryStruct(name: item.name, image: UIImage(named:item.name) ?? UIImage(named:"battle axe")!, quantity: quantities[item.name]!))
                    quantities.removeValue(forKey: item.name)
                }
            }
        default:
            print("Selecting an invalid inventory genre")
        }
        
        inventoryTable.reloadData()
    }
    
    @objc func swipeLeft() {
        // Navigate to BATTLE MENU
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BattleMenuViewController") as! BattleMenuViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func swipeRight() {
        // Navigate to STATS MENU
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

}
