//
//  ExtendUIViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/24/23.
//

import UIKit
import FirebaseFirestore

var enemiesList: [EnemyData] = [EnemyData]()
var teamList: [TeamData] = [TeamData]()

var selectEnemyLabel:UILabel = UILabel()
var selectPlayerLabel:UILabel = UILabel()

// these methods are now part of the UIViewController class as more than one view controller needs them
// i.e. all the battle menus
extension UIViewController {
    
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
        enemiesList.removeAll()
        var count:Int = 0
        let xValues = [10,100,200,290]
        let enemiesRef = Firestore.firestore().collection("teams").document(enemyTeam)
        enemiesRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("This team does not exist")
                return
            }
            let enemies = document.get("players") as! [String]
            for enemy in enemies {
                let gameRef = Firestore.firestore().collection("players").document(enemy)
                gameRef.getDocument { (document2, error) in
                    guard let document2 = document2, document2.exists else {
                        print("This player does not exist")
                        return
                    }
                    let data = document2.data()
                    let userName = enemy
                    let name = data!["character_name"] as! String
                    let character_class = data!["class"] as! String
                    let health = data!["health"] as! Int
                    let armor = data!["current_armor"] as! String
                    let defenseModifier = data!["defense_modifier"] as! Int
                    let armorInventory = data!["armor_inventory"] as! [String]
                    let armorInventoryToStore = rebuildArmorInventory(armorInventory: armorInventory)
                    
                    let isBlind = data!["is_blind"] as! Bool
                    let isDead = data!["is_dead"] as! Bool
                    let isSleep = data!["is_asleep"] as! Bool
                    let isInvisible = data!["is_invisible"] as! Bool
                    
                    let magicResistanceModifier = data!["magic_resistance_modifier"] as! Int
                    let currWeapon = data!["current_weapon"] as! String
                    let currWeaponToStore = rebuildWeaponToStore(currWeapon: currWeapon)
                    let weaponInventory = data!["weapon_inventory"] as! [String]
                    let weaponInventoryToStore: [Weapon] = rebuildWeaponInventory(weaponInventory: weaponInventory)
                    
                    let hasAdvantage = data!["has_advantage"] as! Bool
                    let hasDisadvantage = data!["has_disadvantage"] as! Bool
                    // Rebuild all armor and add them to inventory

                    let currArmorToStore: Armor = rebuildArmorToStore(armorToStore: armor)
                    
                    let player1Image:UIImageView?
                    player1Image = UIImageView()
                    player1Image!.backgroundColor = .clear
                    
                    enemiesList.append(EnemyData(userName: userName, name: name, character_class: character_class, health: health, isBlind: isBlind, isInvisible: isInvisible, imageView: player1Image!, armor: currArmorToStore, defenseModifier: defenseModifier, armorInInventory: armorInventoryToStore, isDead: isDead, isSleep: isSleep, magicResistanceModifier: magicResistanceModifier, currWeapon: currWeaponToStore, weaponInventory: weaponInventoryToStore, hasAdvantage: hasAdvantage, hasDisadvantage: hasDisadvantage))
                    
                    count = count + 1
                    }
                }
            }
        print("The number of enemies are \(enemiesList.count)")
    }
    
    // For now, pass in "4bDfA6dWfv8fRSdebjWI"
    func displayEnemies(enemyTeam: String) {
        var count:Int = 0
        let xValues = [10,100,200,290]
        let enemiesRef = Firestore.firestore().collection("teams").document(enemyTeam)
        enemiesRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("This team does not exist")
                return
            }
            let enemies = document.get("players") as! [String]
            for enemy in enemies {
                let gameRef = Firestore.firestore().collection("players").document(enemy)
                gameRef.getDocument { (document2, error) in
                    guard let document2 = document2, document2.exists else {
                        print("This player does not exist")
                        return
                    }
                    let data = document2.data()
                    let userName = enemy
                    let name = data!["character_name"] as! String
                    let character_class = data!["class"] as! String
                    let health = data!["health"] as! Int
                    let armor = data!["current_armor"] as! String
                    let defenseModifier = data!["defense_modifier"] as! Int
                    let armorInventory = data!["armor_inventory"] as! [String]
                    let armorInventoryToStore = rebuildArmorInventory(armorInventory: armorInventory)
                    
                    let isBlind = data!["is_blind"] as! Bool
                    let isDead = data!["is_dead"] as! Bool
                    let isSleep = data!["is_asleep"] as! Bool
                    let isInvisible = data!["is_invisible"] as! Bool
                    
                    let magicResistanceModifier = data!["magic_resistance_modifier"] as! Int
                    let currWeapon = data!["current_weapon"] as! String
                    let currWeaponToStore = rebuildWeaponToStore(currWeapon: currWeapon)
                    let weaponInventory = data!["weapon_inventory"] as! [String]
                    let weaponInventoryToStore: [Weapon] = rebuildWeaponInventory(weaponInventory: weaponInventory)
                    
                    let hasAdvantage = data!["has_advantage"] as! Bool
                    let hasDisadvantage = data!["has_disadvantage"] as! Bool
                    // Rebuild all armor and add them to inventory

                    let currArmorToStore: Armor = rebuildArmorToStore(armorToStore: armor)
                    
                    let player1Image:UIImageView?
                    player1Image = UIImageView()
                    player1Image!.backgroundColor = .clear
                    var isHurt = health <= getMaxHealth(characterClass: character_class)/2
                    
                    // don't show enemies if the current player is blind dead or asleep
                    if localCharacter.isBlind == false && localCharacter.isDead == false && localCharacter.isAsleep == false {
                        let player1 = CharacterSprites(name: character_class)
                        let player1Image = player1.drawCharacter(view: self.view, x: xValues[count], y: 400, width: 100, height: 100, isInvisible: isInvisible, isHurt: isHurt, isDead: isDead)
                        enemiesList[count].imageView = player1Image!
                    }
                    
                    count = count + 1
                    }
                }
            }
        print("The number of enemies are \(enemiesList.count)")
    }
    
    func renderTeam(playerTeam: String) {
        teamList.removeAll()
        var count:Int = 0
        let xValues = [10,100,200,290]
        // TODO: update with team reference
        let playerRef = Firestore.firestore().collection("teams").document(playerTeam)
        playerRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("This team does not exist")
                return
            }
            let players = document.get("players") as! [String]
            for player in players {
                let gameRef = Firestore.firestore().collection("players").document(player)
                gameRef.getDocument { (document2, error) in
                    guard let document2 = document2, document2.exists else {
                        print("This player does not exist")
                        return
                    }
                    let data = document2.data()
                    let name = data!["character_name"] as! String
                    let character_class = data!["class"] as! String
                    let health = data!["health"] as! Int
                    let isBlind = data!["is_blind"] as! Bool
                    let isInvisible = data!["is_invisible"] as! Bool
                    let hasAdvantage = data!["has_advantage"] as! Bool
                    let defenseModifier = data!["defense_modifier"] as! Int
                    let spellPoints = data!["spell_points"] as! Int
                    let currStamina = data!["stamina"] as! Int
                    let userName = player
                    let hasDisadvantage = data!["has_disadvantage"] as! Bool
                    let weaponInventory = rebuildWeaponInventory(weaponInventory: data!["weapon_inventory"] as! [String])
                    let currWeapon = rebuildWeaponToStore(currWeapon: data!["current_weapon"] as! String)
                    let armorInventory = rebuildArmorInventory(armorInventory: data!["armor_inventory"] as! [String])
                    let armor = rebuildArmorToStore(armorToStore: data!["current_armor"] as! String)
                    let attackModifier = data!["attack_modifier"] as! Int
                    let magicResistanceModifier = data!["magic_resistance_modifier"] as! Int
                    // hasDisadvantage attackModifier
                    
                    teamList.append(TeamData(userName: userName, name: name, character_class: character_class, health: health, isBlind: isBlind, isInvisible: isInvisible, hasAdvantage: hasAdvantage, hasDisadvantage: hasDisadvantage, attackModifier: attackModifier, defenseModifier: defenseModifier, spellPoints: spellPoints, stamina: currStamina, weaponInventory: weaponInventory, currWeapon: currWeapon, armorInInventory: armorInventory, currArmor:armor, magicResistanceModifier:magicResistanceModifier))
                    count = count + 1
                }
            }
        }
    }
    
    // draw the static characters for the enemies with just their names
    // the parameter strings need to match the image asset names like "Fighter", "Rogue", "Bard", "Wizard"
    // nothing will show up if you dont use one of those!!!
    func drawEnemies() -> [UIImageView] {
        // do not change the x y width and height for any of the characters
        // will need to change "name" based on what the enemy players are
        // but that should be dealt with before you call the methods and use the names as the parameter
        //        print(enemiesList[0].name)
        var returnArray:[UIImageView]  = [UIImageView]()
        for (index, enemies) in enemiesList.enumerated() {
            var x = 0
            if index == 0 {
                x = 10
            } else if index == 1 {
                x = 100
            } else if index == 2 {
                x = 200
            } else if index == 3 {
                x = 290
            }
            let player1 = CharacterSprites(name: enemiesList[index].character_class)
            var isHurt = enemiesList[index].health <= getMaxHealth(characterClass: enemiesList[index].character_class)/2
            print("Is it hurt? : \(isHurt) \(enemiesList[index].health)")
            let player1Image = player1.drawCharacter(view: self.view, x: 10, y: 400, width: 100, height: 100, isInvisible: enemiesList[index].isInvisible, isHurt: isHurt, isDead: enemiesList[index].isDead)!
            returnArray.append(player1Image)
        }
        
        return returnArray
    }
    
    // this method draw the enemy characters as selectable buttons for the select target screens
    // still need to work out the corresponding button methods and what they need as parameters
    func drawEnemiesButton() -> [UIButton] {
        // select character label
        selectEnemyLabel = UILabel(frame: CGRect(x:100, y: 300, width:200, height:100))
        selectEnemyLabel.text = ("Select an Enemy")
        selectEnemyLabel.font = UIFont(name: "munro", size: 30)
        self.view.addSubview(selectEnemyLabel)
        var returnArray:[UIButton] = [UIButton]()
        for (index, enemy) in enemiesList.enumerated() {
            print("DEBUG: Index in drawEnemiesButton: \(index)")
            var x = 0
            if index == 0 {
                print("Added player 1")
                x = 10
                let player1 = CharacterSprites(name: enemiesList[index].character_class)
                let player1Button = player1.drawButtonCharacter(controller: self, x: x, y: 400, width: 100, height: 100)
                if enemiesList[index].health <= getMaxHealth(characterClass: enemiesList[index].character_class)/2 {
                    player1Button.setBackgroundImage(UIImage(named:"\(enemiesList[index].character_class)-Hurt"), for: UIControl.State.normal)
                }
                player1Button.addTarget(self, action:#selector(self.enemy1Selected(_:)), for: .touchUpInside)
                if enemiesList[index].isInvisible == false && enemiesList[index].isDead == false {
                            self.view.addSubview(player1Button)
                }
                returnArray.append(player1Button)
            } else if index == 1 {
                x = 100
                let player2 = CharacterSprites(name: enemiesList[index].character_class)
                let player2Button = player2.drawButtonCharacter(controller: self, x: x, y: 400, width: 100, height: 100)
                if enemiesList[index].health <= getMaxHealth(characterClass: enemiesList[index].character_class)/2 {
                    player2Button.setBackgroundImage(UIImage(named:"\(enemiesList[index].character_class)-Hurt"), for: UIControl.State.normal)
                }
                player2Button.addTarget(self, action:#selector(self.enemy2Selected(_:)), for: .touchUpInside)
                if enemiesList[index].isInvisible == false && enemiesList[index].isDead == false {
                            self.view.addSubview(player2Button)
                }
                returnArray.append(player2Button)
            } else if index == 2 {
                x = 200
                let player3 = CharacterSprites(name: enemiesList[index].character_class)
                let player3Button = player3.drawButtonCharacter(controller: self, x: x, y: 400, width: 100, height: 100)
                if enemiesList[index].health <= getMaxHealth(characterClass: enemiesList[index].character_class)/2 {
                    player3Button.setBackgroundImage(UIImage(named:"\(enemiesList[index].character_class)-Hurt"), for: UIControl.State.normal)
                }
                player3Button.addTarget(self, action:#selector(self.enemy3Selected(_:)), for: .touchUpInside)
                if enemiesList[index].isInvisible == false && enemiesList[index].isDead == false {
                            self.view.addSubview(player3Button)
                }
                returnArray.append(player3Button)
            } else if index == 3 {
                x = 290
                let player4 = CharacterSprites(name: enemiesList[index].character_class)
                let player4Button = player4.drawButtonCharacter(controller: self, x: x, y: 400, width: 100, height: 100)
                if enemiesList[index].health <= getMaxHealth(characterClass: enemiesList[index].character_class)/2{
                    player4Button.setBackgroundImage(UIImage(named:"\(enemiesList[index].character_class)-Hurt"), for: UIControl.State.normal)
                }
                player4Button.addTarget(self, action:#selector(self.enemy4Selected(_:)), for: .touchUpInside)
                if enemiesList[index].isInvisible == false && enemiesList[index].isDead == false {
                            self.view.addSubview(player4Button)
                }
                returnArray.append(player4Button)
            }
            
        }
        
        return returnArray
    }
    
    func drawPlayerButtons() -> [UIButton] {
        var returnArray: [UIButton] = [UIButton]()
        // label indicating to pick a player to give item to
        selectPlayerLabel = UILabel(frame: CGRect(x: 50, y: 80, width: 300, height: 75))
        selectPlayerLabel.text = "Select a team member to give item to"
        selectPlayerLabel.font = UIFont(name: "munro", size: 18)
        selectPlayerLabel.textAlignment = .center
        self.view.addSubview(selectPlayerLabel)
        
        for (index, teamMember) in teamList.enumerated() {
            var x = 40
            var y = 70
            if index == 1 {
                x = 120
                y = 60
            } else if index == 2 {
                x = 200
                y = 60
            } else if index == 3 {
                x = 270
                y = 70
            }
            // self.view.safeAreaInsets.left+40, y: 140, width: 300, height: 300
            let player1Button = createButton(x: x, y: y, width: 70, height: 150, fontName: "munro", imageName: "", fontColor: UIColor.clear, buttonTitle: "player1")
            player1Button.backgroundColor = UIColor.clear
            if index == 0 {
                player1Button.addTarget(self, action:#selector(self.player1Selected(_:)), for: .touchUpInside)
            } else if index == 1 {
                player1Button.addTarget(self, action:#selector(self.player2Selected(_:)), for: .touchUpInside)
            } else if index == 2 {
                player1Button.addTarget(self, action:#selector(self.player3Selected(_:)), for: .touchUpInside)
            } else if index == 3 {
                player1Button.addTarget(self, action:#selector(self.player4Selected(_:)), for: .touchUpInside)
            }
            // cannot pick self if animate the dead
            if isAnimateDead() == false {
                self.view.addSubview(player1Button)
            }
            returnArray.append(player1Button)
        }
        
        return returnArray
    }
    
    func drawSelectBoxButtonArrowItem(x:Int, y:Int, width:Int, height:Int) -> [AnyObject] {
        let doubleTapTarget:UILabel = UILabel(frame: CGRect(x:x, y:y - 100, width:110, height:100))
        doubleTapTarget.text = "Double Tap to Choose Target"
        doubleTapTarget.numberOfLines = 0
        doubleTapTarget.lineBreakMode = .byWordWrapping
        doubleTapTarget.textAlignment = .center
        doubleTapTarget.font = UIFont(name: "munro", size: 15)
        self.view.addSubview(doubleTapTarget)
        let selectRectangle = createButton(x: x, y: y, width: width, height: height, fontName: "munro", imageName: "Select Rectangle", fontColor: UIColor.black, buttonTitle: "")
        selectRectangle.addTarget(self, action: #selector(playerBoxSelected(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.addSubview(selectRectangle)
        let image = UIImage(named:"down arrow")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x+10, y: y-30, width: 50, height: 30))
        imageView.image = image
        view.addSubview(imageView)
        return [selectRectangle, imageView,doubleTapTarget]
    }
    
    func drawSelectBoxButtonArrow(x:Int, y:Int, width:Int, height:Int) -> [AnyObject] {
        let doubleTapTarget:UILabel = UILabel(frame: CGRect(x:x, y:y - 100, width:110, height:100))
        doubleTapTarget.text = "Double Tap to Choose Target"
        doubleTapTarget.numberOfLines = 0
        doubleTapTarget.lineBreakMode = .byWordWrapping
        doubleTapTarget.textAlignment = .center
        doubleTapTarget.font = UIFont(name: "munro", size: 15)
        self.view.addSubview(doubleTapTarget)
        let selectRectangle = createButton(x: x, y: y, width: width, height: height, fontName: "munro", imageName: "Select Rectangle", fontColor: UIColor.black, buttonTitle: "")
        selectRectangle.addTarget(self, action: #selector(enemyBoxSelected(_:event:)), for: UIControl.Event.touchDownRepeat)
        self.view.addSubview(selectRectangle)
        let image = UIImage(named:"down arrow")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x:x+30, y: y-30, width: 50, height: 30))
        imageView.image = image
        view.addSubview(imageView)
        return [selectRectangle, imageView, doubleTapTarget]
    }
    
    // will transder to BattleSelectActionViewController
    // will do even if you are already on it
    @objc func actionButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        rowItemSelected = nil // to acoid an item being here
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
        playSoundEffect(fileName: menuSelectEffect)
        rowSelected = nil // to avoid an action being held here
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectItemViewController") as! BattleSelectItemViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    // will transfer to BattleSelectEquipViewController
    @objc func equipButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        // avoid these holding actions and items
        rowSelected = nil
        rowItemSelected = nil
        print("my equip button pressed")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BattleSelectEquipViewController") as! BattleSelectEquipViewController
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc,animated: false)
    }
    
    // please dont make separate storyboards for all the types of boards right now
    @objc func settingsButtonPressed(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated:false)
    }
    
    @objc func enemy1Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(enemyIndex: 0)
        // if enemy 1 is selected use enemiesList[0].variableName
        selectEnemyLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrow(x: 10, y: 400, width: 100, height: 100)
    }
    
    @objc func enemy2Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(enemyIndex: 1)
        selectEnemyLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrow(x: 100, y: 400, width: 100, height: 100)
    }

    @objc func enemy3Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(enemyIndex: 2)
        selectEnemyLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrow(x: 200, y: 400, width: 100, height: 100)
    }
    
    @objc func enemy4Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(enemyIndex: 3)
        selectEnemyLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrow(x: 290, y: 400, width: 100, height: 100)
    }
    
    @objc func player1Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(teamMemberIndex: 0)
        selectPlayerLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrowItem(x: 40, y: 130, width: 70, height: 150)
    }
    
    @objc func player2Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(teamMemberIndex: 1)
        selectPlayerLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrowItem(x: 120, y: 130, width: 70, height: 150)
    }
    
    @objc func player3Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(teamMemberIndex: 2)
        selectPlayerLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrowItem(x: 200, y: 130, width: 70, height: 150)
    }
    
    @objc func player4Selected(_ sender:UIButton!) {
        playSoundEffect(fileName: menuSelectEffect)
        updateCurrTargetData(teamMemberIndex: 3)
        selectPlayerLabel.removeFromSuperview()
        if boxArrow.isEmpty == false {
            boxArrow[0].removeFromSuperview()
            boxArrow[1].removeFromSuperview()
            boxArrow[2].removeFromSuperview()
        }
        boxArrow = drawSelectBoxButtonArrowItem(x: 270, y: 130, width: 70, height: 150)
    }
    
    @objc func enemyBoxSelected(_ sender:UIButton, event: UIEvent) {
        playSoundEffect(fileName: menuSelectEffect)
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            // save the variables after you know its a double tap
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            // Decide if the player needs to roll or not
            if(actionRequiresRoll()) {
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController
                
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            } else {
                performBattleAction()
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            }
            
        }
    }
    
    @objc func playerBoxSelected(_ sender:UIButton, event: UIEvent) {
        playSoundEffect(fileName: menuSelectEffect)
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2) {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            // update currTarget with the playerBox they selected
            print("Inside playerBoxSelected and rowSelected is: \(String(describing: rowItemSelected?.name))")
            if(actionRequiresRoll()) {
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleRollViewController") as! BattleRollViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            } else if rowItemSelected != nil {
                // rowItemSelected holds string of item selected
                let itemToUse = returnItemFromInventory(requestedItemName: (rowItemSelected?.name)!, itemInventory: localCharacter.itemsInInventory)
                
                // Check if the target is yourself or a target
                if localCharacter.characterName == currTarget.name {
                    itemToUse.useOnSelf()
                } else {
                    itemToUse.useOnTarget()
                }
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
                endTurn(game: game, player: localCharacter.userName)
            } else {
                // Note: Both of these actions will send them to idle menu after
                performBattleAction()
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BattleIdleViewController") as! BattleIdleViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated: false)
            }
        }
    }
    
    func updateCurrTargetData(enemyIndex: Int) {
        currTarget.name = enemiesList[enemyIndex].name
        currTarget.userName = enemiesList[enemyIndex].userName
        currTarget.character_class = enemiesList[enemyIndex].character_class
        currTarget.health = enemiesList[enemyIndex].health
        currTarget.armor = enemiesList[enemyIndex].armor
        currTarget.modifiedArmorClass = calculateModifiedArmorClass()
        currTarget.defenseModifier = enemiesList[enemyIndex].defenseModifier
        currTarget.armorInInventory = enemiesList[enemyIndex].armorInInventory
        currTarget.isBlind = enemiesList[enemyIndex].isBlind
        currTarget.isDead = enemiesList[enemyIndex].isDead
        currTarget.isSleep = enemiesList[enemyIndex].isSleep
        currTarget.magicResistanceModifier = enemiesList[enemyIndex].magicResistanceModifier
        currTarget.currWeapon = enemiesList[enemyIndex].currWeapon
        currTarget.weaponInventory = enemiesList[enemyIndex].weaponInventory
        currTarget.hasAdvantage = enemiesList[enemyIndex].hasAdvantage
        currTarget.hasDisadvantage = enemiesList[enemyIndex].hasDisadvantage
    }
    
    func updateCurrTargetData(teamMemberIndex: Int) {
        currTarget.name = teamList[teamMemberIndex].name
        currTarget.userName = teamList[teamMemberIndex].userName
        currTarget.character_class = teamList[teamMemberIndex].character_class
        currTarget.health = teamList[teamMemberIndex].health
        currTarget.isBlind = teamList[teamMemberIndex].isInvisible
        currTarget.hasAdvantage = teamList[teamMemberIndex].hasAdvantage
        currTarget.defenseModifier = teamList[teamMemberIndex].defenseModifier
        currTarget.spellPoints = teamList[teamMemberIndex].spellPoints
        currTarget.currStamina = teamList[teamMemberIndex].stamina
    }
}
