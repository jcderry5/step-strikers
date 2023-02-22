//
//  BattleSelectActionViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/22/23.
//

import UIKit

class BattleSelectActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // puts full screen image as background of view controller
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        createBattleActionButtons()
        createSettingsButton(x: 10, y: 50, width: 40, height: 40)
        
        // create characters
        // will need to change "name" based on what the enemy players are
        // player 1
        let player1 = characterSprites(name: "Fighter")
        player1.drawCharacter(view: self.view, x: 10, y: 400, width: 100, height: 100)
        
        // player 2
        let player2 = characterSprites(name: "Bard")
        player2.drawCharacter(view: self.view, x: 100, y: 400, width: 100, height: 100)
        
        // player 3
        let player3 = characterSprites(name: "Rogue")
        player3.drawCharacter(view: self.view, x: 200, y: 400, width: 100, height: 100)
        
        // player  4
        let player4 = characterSprites(name: "Wizard")
        player4.drawCharacter(view: self.view, x: 290, y: 400, width: 100, height: 100)
    }

}

extension UIViewController {
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
    
    func createBattleStatsDisplay() {
        let battleTopBoard = UIImage(named: "Battle Top Board")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x: self.view.safeAreaInsets.left+10, y: self.view.safeAreaInsets.top+100, width: 375, height: 200))
        imageView.image = battleTopBoard
        view.addSubview(imageView)
    }
    
    func createBattleActionMenu() {
        let battleBottomBoard = UIImage(named: "Battle Bottom Board")
        var imageView: UIImageView!
        imageView = UIImageView(frame: CGRect(x: self.view.safeAreaInsets.left+10, y: 600, width: 375, height: 240))
        imageView.image = battleBottomBoard
        view.addSubview(imageView)
        
        // create the three buttons on the bottom of the board
        createBattleActionButtons()
    }
    
    func createBattleActionButtons() {
        let selectedButton:String = "Selected Action Button"
        let unselectedButton:String = "Unselected action button"
        let fontNamed:String = "munro"
        // action button
        let actionButton:UIButton = createButton(x:20, y:785, width:126, height:50, fontName: fontNamed, imageName: selectedButton, fontColor: UIColor.black, buttonTitle: "ACTION")
        actionButton.addTarget(self, action:#selector(self.actionButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(actionButton)
        
        // item button
        let itemButton:UIButton = createButton(x:137, y:785, width:126, height:50, fontName: fontNamed, imageName: unselectedButton, fontColor: UIColor.black, buttonTitle: "ITEM")
        itemButton.addTarget(self, action:#selector(self.itemButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(itemButton)

        // equip button
        let equipButton:UIButton = createButton(x:254, y:785, width:126, height:50, fontName: fontNamed, imageName: unselectedButton, fontColor: UIColor.black, buttonTitle: "EQUIP")
        equipButton.addTarget(self, action:#selector(self.equipButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(equipButton)

    }
    
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
    
    func createSettingsButton(x:Int, y:Int, width:Int, height:Int) {
        let imageName = "Setting Icon"
        let settingsButton = createButton(x:x, y:y, width:width, height:height, fontName: "munro", imageName:imageName, fontColor: UIColor.black, buttonTitle:"")
        settingsButton.addTarget(self, action:#selector(self.settingsButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(settingsButton)
    }
    
    func drawEnemies(enemy1:String, enemy2:String, enemy3:String, enemy4:String)
    
    @objc func actionButtonPressed(_ sender:UIButton!) {
        print("my action button pressed")
    }
    
    @objc func itemButtonPressed(_ sender:UIButton!) {
        print("my item button pressed")
    }
    
    @objc func equipButtonPressed(_ sender:UIButton!) {
        print("my equip button pressed")
    }
    
    @objc func settingsButtonPressed(_ sender:UIButton!) {
        print("my settings button pressed")
    }
}

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
