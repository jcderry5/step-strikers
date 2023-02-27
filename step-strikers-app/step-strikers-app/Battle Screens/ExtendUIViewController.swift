//
//  ExtendUIViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/24/23.
//

import UIKit
import FirebaseFirestore

var enemiesList: [enemyData] = [enemyData]()
var teamList: [teamData] = [teamData]()

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
    
    // For now, pass in "4bDfA6dWfv8fRSdebjWI"
    func renderEnemies(enemyTeam: String) {
        var count:Int = 0
        let xValues = [10,100,200,290]
        let enemiesRef = Firestore.firestore().collection("teams").document(enemyTeam)
        enemiesRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let enemies = document.get("players") as! [String]
                for enemy in enemies {
                    let gameRef = Firestore.firestore().collection("players").document(enemy)
                    gameRef.getDocument { (document2, error) in
                        if let document2 = document2, document2.exists {
                            let data = document2.data()
                            let name = data!["character_name"] as! String
                            let character_class = data!["class"] as! String
                            let health = data!["health"] as! Int
                            let isBlind = data!["is_blind"] as! Bool
                            let isInvisible = data!["is_invisible"] as! Bool
                            let userName = enemy
                            
                            // replace this with whatever data structure you want
                            let newTuple = (name, character_class, health, isBlind, isInvisible)
                            print(newTuple)
                            // or don't save info and do UI stuff here one enemy at a time
                            let player1 = characterSprites(name: character_class)
                            let player1Image = player1.drawCharacter(view: self.view, x: xValues[count], y: 400, width: 100, height: 100)
                            
                            enemiesList.append(enemyData(userName: userName, name: name, character_class: character_class, health: health, isBlind: isBlind, isInvisible: isInvisible,imageView: player1Image!))
                            
                            count = count + 1
                        } else {
                            print("This player does not exist")
                        }
                    }
                }
            } else {
                print("This team does not exist")
            }
        }
    }
    
    func renderTeam(enemyTeam: String) {
        var count:Int = 0
        let xValues = [10,100,200,290]
        // TODO: update with team reference
        let enemiesRef = Firestore.firestore().collection("teams").document(enemyTeam)
        enemiesRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let enemies = document.get("players") as! [String]
                for enemy in enemies {
                    let gameRef = Firestore.firestore().collection("players").document(enemy)
                    gameRef.getDocument { (document2, error) in
                        if let document2 = document2, document2.exists {
                            let data = document2.data()
                            let name = data!["character_name"] as! String
                            let character_class = data!["class"] as! String
                            let health = data!["health"] as! Int
                            let isBlind = data!["is_blind"] as! Bool
                            let isInvisible = data!["is_invisible"] as! Bool
                            let userName = enemy
                            
                            // replace this with whatever data structure you want
                            let newTuple = (name, character_class, health, isBlind, isInvisible)
                            print(newTuple)
                            // or don't save info and do UI stuff here one enemy at a time
                            
                            teamList.append(teamData(userName: userName, name: name, character_class: character_class, health: health, isBlind: isBlind, isInvisible: isInvisible))
                            
                            count = count + 1
                        } else {
                            print("This player does not exist")
                        }
                    }
                }
            } else {
                print("This team does not exist")
            }
        }
    }
    
    // draw the static characters for the enemies with just their names
    // the parameter strings need to match the image asset names like "Fighter", "Rogue", "Bard", "Wizard"
    // nothing will show up if you dont use one of those!!!
    func drawEnemies(enemy1:String, enemy2:String, enemy3:String, enemy4:String) -> [UIImageView] {
        // do not change the x y width and height for any of the characters
        // will need to change "name" based on what the enemy players are
        // but that should be dealt with before you call the methods and use the names as the parameter
//        print(enemiesList[0].name)
        // player 1
        let player1 = characterSprites(name: enemiesList[0].character_class)
        let player1Image = player1.drawCharacter(view: self.view, x: 10, y: 400, width: 100, height: 100)
        
        // player 2
        let player2 = characterSprites(name: enemy2)
        let player2Image = player2.drawCharacter(view: self.view, x: 100, y: 400, width: 100, height: 100)
        
        // player 3
        let player3 = characterSprites(name: enemy3)
        let player3Image =  player3.drawCharacter(view: self.view, x: 200, y: 400, width: 100, height: 100)
        
        // player  4
        let player4 = characterSprites(name: enemy4)
        let player4Image = player4.drawCharacter(view: self.view, x: 290, y: 400, width: 100, height: 100)
        
        return [player1Image!, player2Image!, player3Image!, player4Image!]
    }
    
    // this method draw the enemy characters as selectable buttons for the select target screens
    // still need to work out the corresponding button methods and what they need as parameters
    // TODO: figure out when to put the red arrow
    func drawEnemiesButton(enemy1:String, enemy2:String, enemy3:String, enemy4:String) -> [UIButton] {
        // will need to change "name" based on what the enemy players are
        // player 1
        let player1 = characterSprites(name: enemy1)
        let player1Button = player1.drawButtonCharacter(controller: self, x: 10, y: 400, width: 100, height: 100)
        // need to change to a method that does whatever happens when enemy 1 is pressed
        player1Button.addTarget(self, action:#selector(self.enemy1Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player1Button)
        
        // player 2
        let player2 = characterSprites(name: enemy2)
//        player2.drawCharacter(view: self.view, x: 100, y: 400, width: 100, height: 100)
        let player2Button = player2.drawButtonCharacter(controller: self, x: 100, y: 400, width: 100, height: 100)
        player2Button.addTarget(self, action:#selector(self.enemy2Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player2Button)
        
        // player 3
        let player3 = characterSprites(name: enemy3)
        let player3Button = player3.drawButtonCharacter(controller: self, x: 200, y: 400, width: 100, height: 100)
        player3Button.addTarget(self, action:#selector(self.enemy3Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player3Button)
        
        // player  4
        let player4 = characterSprites(name: enemy4)
        let player4Button = player4.drawButtonCharacter(controller: self, x: 290, y: 400, width: 100, height: 100)
        player4Button.addTarget(self, action:#selector(self.enemy4Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player4Button)
        
        return [player1Button, player2Button, player3Button, player4Button]
    }
    
    func drawPlayerButtons(player1:String, player2:String, player3:String, player4:String) -> [UIButton] {
        // self.view.safeAreaInsets.left+40, y: 140, width: 300, height: 300
        let player1Button = createButton(x: 40, y: 140, width: 70, height: 150, fontName: "munro", imageName: "", fontColor: UIColor.clear, buttonTitle: "player1")
        player1Button.backgroundColor = UIColor.clear
        player1Button.addTarget(self, action:#selector(self.player1Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player1Button)
        
        let player2Button = createButton(x: 120, y: 140, width: 60, height: 150, fontName: "munro", imageName: "", fontColor: UIColor.clear, buttonTitle: "")
        player2Button.backgroundColor = UIColor.clear
        player2Button.addTarget(self, action:#selector(self.player2Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player2Button)
        
        let player3Button = createButton(x: 200, y: 140, width: 60, height: 150, fontName: "munro", imageName: "", fontColor: UIColor.clear, buttonTitle: "")
        player3Button.backgroundColor = UIColor.clear
        player3Button.addTarget(self, action:#selector(self.player3Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player3Button)
        
        let player4Button = createButton(x: 270, y: 140, width: 70, height: 150, fontName: "munro", imageName: "", fontColor: UIColor.clear, buttonTitle: "")
        player4Button.backgroundColor = UIColor.clear
        player4Button.addTarget(self, action:#selector(self.player4Selected(_:)), for: .touchUpInside)
        self.view.addSubview(player4Button)
        
        return [player1Button, player2Button, player3Button, player4Button]
    }
    
    func drawSelectBoxButtonArrowItem(x:Int, y:Int, width:Int, height:Int) -> [AnyObject] {
        let selectRectangle = createButton(x: x, y: y, width: width, height: height, fontName: "munro", imageName: "Select Rectangle", fontColor: UIColor.black, buttonTitle: "")
        selectRectangle.addTarget(self, action: #selector(playerBoxSelected(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.addSubview(selectRectangle)
        let image = UIImage(named:"down arrow")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x+10, y: y-30, width: 50, height: 30))
        imageView.image = image
        view.addSubview(imageView)
        return [selectRectangle, imageView]
    }
    
    func drawSelectBoxButtonArrow(x:Int, y:Int, width:Int, height:Int) -> [AnyObject] {
        let selectRectangle = createButton(x: x, y: y, width: width, height: height, fontName: "munro", imageName: "Select Rectangle", fontColor: UIColor.black, buttonTitle: "")
        selectRectangle.addTarget(self, action: #selector(enemyBoxSelected(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.addSubview(selectRectangle)
        let image = UIImage(named:"down arrow")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x+30, y: y-30, width: 50, height: 30))
        imageView.image = image
        view.addSubview(imageView)
        return [selectRectangle, imageView]
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
    
    @objc func enemy1Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrow(x: 10, y: 400, width: 100, height: 100)
    }
    
    @objc func enemy2Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrow(x: 100, y: 400, width: 100, height: 100)
    }
    
    @objc func enemy3Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrow(x: 200, y: 400, width: 100, height: 100)
    }
    
    @objc func enemy4Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrow(x: 290, y: 400, width: 100, height: 100)
    }
    
    @objc func player1Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrowItem(x: 40, y: 130, width: 70, height: 150)
    }
    
    @objc func player2Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrowItem(x: 120, y: 130, width: 70, height: 150)
    }
    
    @objc func player3Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrowItem(x: 200, y: 130, width: 70, height: 150)
    }
    
    @objc func player4Selected(_ sender:UIButton!) {
        boxArrow[0].removeFromSuperview()
        boxArrow[1].removeFromSuperview()
        boxArrow = drawSelectBoxButtonArrowItem(x: 270, y: 130, width: 70, height: 150)
    }
    
    @objc func enemyBoxSelected(_ sender:UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController
            vc.selectTargetInfo = (enemiesList[0].userName, enemiesList[1].userName, enemiesList[2].userName, enemiesList[3].userName, rowSelected!)
            print(vc.selectTargetInfo!.0)
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
        }
    }
    
    @objc func playerBoxSelected(_ sender:UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController
            vc.selectTargetInfoItem = (teamList[0].userName, teamList[1].userName, teamList[2].userName, teamList[3].userName, rowItemSelected!)
            print(vc.selectTargetInfoItem!.0)
            self.modalPresentationStyle = .fullScreen
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated: false)
        }
    }
}
