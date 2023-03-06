//
//  InventoryViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/3/23.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var inventoryTable:UITableView = UITableView()
    let cellId = "inventoryCell"
    
    let buttonImg = UIImage(named:"Menu Button")
    let selectedImg = UIImage(named:"Selected Menu Button")
    var weaponsButton:UIButton = UIButton()
    var armorButton:UIButton = UIButton()
    var itemsButton:UIButton = UIButton()
    
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
        let segments = UISegmentedControl(items:["WEAPONS", "ARMOR", "ITEMS"])
        // Set attributes for each segment
        segments.frame = CGRect(x: 15, y: 620, width: Int(view.frame.maxX)-30, height: 70)
        segments.selectedSegmentIndex = 0
        segments.setBackgroundImage(buttonImg, for: .normal, barMetrics: .default)
        segments.setBackgroundImage(selectedImg, for: .selected, barMetrics: .default)
        segments.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name:"munro", size:24)!], for: .normal)
        segments.setWidth(115, forSegmentAt: 0)
        segments.setWidth(115, forSegmentAt: 1)
        segments.setWidth(115, forSegmentAt: 2)
        // Format divider image between each segment
        // Side note: doesn't seem like you can add space b/w segments
        var divider = UIImage(named:"segment_divider")
        UIGraphicsBeginImageContext(CGSizeMake(9, 70))
        divider!.draw(in: CGRectMake(0, 0, 9, 70))
        divider = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        segments.setDividerImage(divider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        view.addSubview(segments)
        
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
        swipeRight.direction = .left
        swipeView.addGestureRecognizer(swipeRight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Implement
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Implement
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // Adjust size of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc func weaponsPressed(_ sender:UIButton!) {
        // TODO: Fill tableview with weapon cells
        print("WEAPONS PRESSED")
        weaponsButton.isHighlighted = true
    }
    
    @objc func armorPressed(_ sender:UIButton!) {
        // TODO: Fill tableview with armor cells
        print("ARMOR PRESSED")
        armorButton.isHighlighted = true
    }
    
    @objc func itemsPressed(_ sender:UIButton!) {
        // TODO: FIll tableview with item cells
        print("ITEMS PRESSED")
        itemsButton.isHighlighted = true
    }
    
    @objc func swipeLeft() {
        // TODO: Navigate to BATTLE MENU
    }
    
    @objc func swipeRight() {
        // TODO: Navigate to STATS MENU
    }

}
