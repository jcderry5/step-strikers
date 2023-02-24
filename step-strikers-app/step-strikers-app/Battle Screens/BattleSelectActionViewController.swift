//
//  BattleSelectActionViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleSelectActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // array of all the actions a player can take
    var actions: [Action] = [Action]()
    let cellId = "actionCell"
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var stats: [StatsRow] = [StatsRow]()
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var actionDisplay:UITableView = UITableView()
    var statsDisplay:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // create characters
        // will need to change "name" based on what the enemy players are
        // TODO: update to take what the enemies character type are
        drawEnemies(enemy1: "Fighter", enemy2: "Bard", enemy3: "Rogue", enemy4: "Wizard")
        
        // create a Table View that displays the action menu, and when pressed does something
        // TODO: set up the transfer to the select target screen when a action is selected
        // the array of all the action a player can do
        createActionArray()
        // the frame of where the table will appear
        actionDisplay = UITableView(frame: CGRect(x: self.view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        actionDisplay.translatesAutoresizingMaskIntoConstraints = false
        actionDisplay.dataSource = self
        // register the table since it was not created with the storyboard
        actionDisplay.register(ActionTableViewCell.self, forCellReuseIdentifier: cellId)
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
        tableView.deselectRow(at: indexPath, animated:true)
        let rowValue = actions[indexPath.row]
        if tableView == actionDisplay {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectTargetViewController") as! BattleSelectTargetViewController
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
        }
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
    
    // TODO: update array with actual actions player can do
    func createActionArray() {
        actions.append(Action(name: "one", staminaCost: "5 STA"))
        actions.append(Action(name: "two", staminaCost: "5 STA"))
        actions.append(Action(name: "three", staminaCost: "5 STA"))
        actions.append(Action(name: "four", staminaCost: "5 STA"))
        actions.append(Action(name: "five", staminaCost: "5 STA"))
        actions.append(Action(name: "six", staminaCost: "5 STA"))
        actions.append(Action(name: "seven", staminaCost: "5 STA"))
        actions.append(Action(name: "eight", staminaCost: "5 STA"))
        actions.append(Action(name: "nine", staminaCost: "5 STA"))
        actions.append(Action(name: "ten", staminaCost: "5 STA"))
    }
    
    func createStatsArray() {
        header.append(StatsHeaderRow(names: ["Host", "Player 1", "Player 2", "Player 3"]))
        // extra to account for header messing everything up
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "health"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: [1,2,3,4] , totalPoints: [1,2,3,4]))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points:[1,2,3,4] , totalPoints: [1,2,3,4]))
    }
    
}

// these methods are now part of the UIViewController class as more than one view controller needs them
// i.e. all the battle menus
extension UIViewController {
    // takes the background image and places it as a UIImage across the entire screen
    // shouldn't matter if this one is done last
    func assignBackground() {
        let background = UIImage(named: "Background")
        var imageView: UIImageView!
        imageView = UIImageView(frame: self.view.frame)
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // creates the initial top board, without the table
    func createBattleStatsDisplay() {
        let battleTopBoard = UIImage(named: "Battle Top Board")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x: self.view.safeAreaInsets.left+10, y: self.view.safeAreaInsets.top+100, width: 375, height: 200))
        imageView.image = battleTopBoard
        view.addSubview(imageView)
    }
    
    // creates the initial bottom board, without the table
    func createBattleActionMenu() {
        let battleBottomBoard = UIImage(named: "Battle Bottom Board")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x: self.view.safeAreaInsets.left+10, y: 600, width: 375, height: 240))
        imageView.image = battleBottomBoard
        view.addSubview(imageView)
    }
    
    // creates the action, item, and equip button based on if they are selected or not
    // uses munro font
    func createBattleActionButtons(actionSelected:String, itemSelected:String, equipSelected:String) {
        let fontNamed:String = "munro"
        // action button
        // the function actionButtonPressed is added as a target, function will be called when button is pressed inside
        let actionButton:UIButton = createButton(x:20, y:785, width:126, height:50, fontName: fontNamed, imageName: actionSelected, fontColor: UIColor.black, buttonTitle: "ACTION")
        actionButton.addTarget(self, action:#selector(self.actionButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(actionButton)
        
        // item button
        // associated function: itemButton Pressed
        let itemButton:UIButton = createButton(x:137, y:785, width:126, height:50, fontName: fontNamed, imageName: itemSelected, fontColor: UIColor.black, buttonTitle: "ITEM")
        itemButton.addTarget(self, action:#selector(self.itemButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(itemButton)

        // equip button
        let equipButton:UIButton = createButton(x:254, y:785, width:126, height:50, fontName: fontNamed, imageName: equipSelected, fontColor: UIColor.black, buttonTitle: "EQUIP")
        equipButton.addTarget(self, action:#selector(self.equipButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(equipButton)

    }
    
    // generic function to create a button
    // x y width height sets where it will show up and how big the button will be
    // image Name should be the same as it was in assets
    // use UIColor for font color
    // buttonTitle is what text you want the button to display, if no text just enter ""
    // will return button for you to addTarget and addSubview
    func createButton(x:Int, y:Int, width:Int, height:Int, fontName:String, imageName:String, fontColor:UIColor, buttonTitle:String) -> UIButton {
        let button = UIButton()
        let image = UIImage(named:imageName)
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.setTitle(buttonTitle, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: fontName, size: 20)
        button.setTitleColor(fontColor, for: UIControl.State.normal)
        return button
    }
    
    // creates the settings button based on where you want it placed, because different screens have it in different locations
    func createSettingsButton(x:Int, y:Int, width:Int, height:Int) {
        let imageName = "Setting Icon"
        let settingsButton = createButton(x:x, y:y, width:width, height:height, fontName: "munro", imageName:imageName, fontColor: UIColor.black, buttonTitle:"")
        settingsButton.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(settingsButton)
    }
    
    // draw the static characters for the enemies with just their names
    // the parameter strings need to match the image asset names like "Fighter", "Rogue", "Bard", "Wizard"
    // nothing will show up if you dont use one of those!!!
    func drawEnemies(enemy1:String, enemy2:String, enemy3:String, enemy4:String) {
        // do not change the x y width and height for any of the characters
        // will need to change "name" based on what the enemy players are
        // but that should be dealt with before you call the methods and use the names as the parameter
        
        // player 1
        let player1 = characterSprites(name: enemy1)
        player1.drawCharacter(view: self.view, x: 10, y: 400, width: 100, height: 100)
        
        // player 2
        let player2 = characterSprites(name: enemy2)
        player2.drawCharacter(view: self.view, x: 100, y: 400, width: 100, height: 100)
        
        // player 3
        let player3 = characterSprites(name: enemy3)
        player3.drawCharacter(view: self.view, x: 200, y: 400, width: 100, height: 100)
        
        // player  4
        let player4 = characterSprites(name: enemy4)
        player4.drawCharacter(view: self.view, x: 290, y: 400, width: 100, height: 100)
    }
    
    // this method draw the enemy characters as selectable buttons for the select target screens
    // still need to work out the corresponding button methods and what they need as parameters
    // TODO: figure out when to put the red arrow
    func drawEnemiesButton(enemy1:String, enemy2:String, enemy3:String, enemy4:String) {
        // will need to change "name" based on what the enemy players are
        // player 1
        let player1 = characterSprites(name: enemy1)
        let player1Button = player1.drawButtonCharacter(controller: self, x: 10, y: 400, width: 100, height: 100)
        // need to change to a method that does whatever happens when enemy 1 is pressed
        player1Button.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(player1Button)
        
        // player 2
        let player2 = characterSprites(name: enemy2)
        player2.drawCharacter(view: self.view, x: 100, y: 400, width: 100, height: 100)
        let player2Button = player2.drawButtonCharacter(controller: self, x: 10, y: 400, width: 100, height: 100)
        player2Button.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(player1Button)
        
        // player 3
        let player3 = characterSprites(name: enemy3)
        let player3Button = player3.drawButtonCharacter(controller: self, x: 10, y: 400, width: 100, height: 100)
        player3Button.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(player3Button)
        
        // player  4
        let player4 = characterSprites(name: enemy4)
        let player4Button = player4.drawButtonCharacter(controller: self, x: 10, y: 400, width: 100, height: 100)
        player4Button.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(player4Button)
    }
    
    // will transder to BattleSelectActionViewController
    // will do even if you are already on it
    @objc func actionButtonPressed(_ sender:UIButton!) {
        print("my action button pressed")
        // storyboard
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        // need to set the storyboard ID in Main.board for each viewcontroller if you want to segue to them
        // instead of segueing we are presenting the next view controller because I did not want to deal with preparing for segue
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    // will transfer to BattleSelectItemViewController
    @objc func itemButtonPressed(_ sender:UIButton!) {
        print("my item button pressed")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectItemViewController") as! BattleSelectItemViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    // will transfer to BattleSelectEquipViewController
    @objc func equipButtonPressed(_ sender:UIButton!) {
        print("my equip button pressed")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectEquipViewController") as! BattleSelectEquipViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    // TODO: Change this to transfer to the settings screen when it is built
    // please dont make separate storyboards for all the types of boards right now
    @objc func settingsButtonPressed(_ sender:UIButton!) {
        print("my settings button pressed")
    }
}

// TODO: remove these functions to the UIViewController extension and use the information set from Game.swift (?)
struct characterSprites {
    var name:String
    
    func drawCharacter(view:UIView, x:Int, y:Int, width:Int, height:Int) {
        let image = UIImage(named:name)
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x, y: y, width: width, height: height))
        imageView.image = image
        view.addSubview(imageView)
    }
    
    func drawButtonCharacter(controller:UIViewController, x:Int, y:Int, width:Int, height:Int) -> UIButton {
        let imageName = name
        let characterButton = controller.createButton(x:x, y:y, width:width, height:height, fontName: "munro", imageName:imageName, fontColor: UIColor.black, buttonTitle:"")
        return characterButton
    }
}
