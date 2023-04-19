//
//  BattleIdleViewController.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/27/23.
//

import UIKit
import FirebaseFirestore

var messages:[String] = [String]()
var readyForBattleVC = 0

class BattleIdleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectTargetInfoItem :(String, String, String, String, Items)?
    let statsCellID = "statsCell"
    let statsHeaderID = "statsHeader"
    var header: [StatsHeaderRow] = [StatsHeaderRow]()
    var stats: [StatsRow] = [StatsRow]()
    var scrollView: UIScrollView!
    var notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readyForBattleVC = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(segue), name: Notification.Name("health"), object: nil)
        
        // check if game is already over
        let gameRef = Firestore.firestore().collection("games").document(game)
        gameRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if document.get("game_over") as! Bool {
                    if document.get("game_winner") as! String == team {
                        // you win!
                        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "BattleResultsVictoryViewController") as! BattleResultsVictoryViewController
                        
                        self.modalPresentationStyle = .fullScreen
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false)
                        
                    } else {
                        // you lose
                        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "BattleResultsLossViewController") as! BattleResultsLossViewController
                        
                        self.modalPresentationStyle = .fullScreen
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: false)
                    }
                }
            }
        }
        
        displayEnemies(enemyTeam: enemyTeam)
        // Do any additional setup after loading the view.
        // background images and view set up
        assignBackground()
        createBattleActionMenu()
        createBattleStatsDisplay()
        
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
        statsDisplay.isScrollEnabled = false
        // cannot press on a row
        statsDisplay.allowsSelection = false
        // get rid of grey separator line in between rows
        statsDisplay.separatorColor = UIColor.clear
        self.view.addSubview(statsDisplay)
        
        // if a player is blind
        if localCharacter.isBlind {
            let popUp = createPopUpBlind()
            self.view.addSubview(popUp)
        }
        
        checkDeadOrAsleep()
        
        // scroll view
        // Set the scrollView's frame to be the size of the screen
        scrollView = UIScrollView(frame: CGRect(x: view.safeAreaInsets.left+40, y: 640, width: 320, height: 150))
        scrollView.backgroundColor = UIColor.clear
        // Set the contentSize to 100 times the height of the phone's screen so that we can add 100 images in the next step
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.bounds.size.height*25*CGFloat(messages.count))
        view.addSubview(scrollView!)
        var labels = [UILabel]()
        
        // update messages
        let docRef = Firestore.firestore().collection("games").document(game)
        docRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    messages = document.get("messages") as! [String]
                    messageLog.replaceMessageLog(newMessages: messages)
                    for i in 0..<messages.count {
                        print("DEBUG: messages.count has a length of \(messages.count)")
                        labels.append(UILabel())
                        labels[i].text = "\(messages[i])\n"
                        labels[i].numberOfLines = 0
                        labels[i].lineBreakMode = .byWordWrapping
                        labels[i].textColor = UIColor.black
                        labels[i].font = UIFont(name: "munro", size: 20)
                        labels[i].frame = CGRect(x: 0, y: 50*CGFloat(i), width: self.scrollView.bounds.size.width, height: 100)
                        labels[i].contentMode = .scaleAspectFill
                        self.scrollView.addSubview(labels[i])
                    }
                }
            }
        }
        
        // listen for when you should refresh localCharacter from firebase
        refreshStats()
        // listen for when it's your turn
        segueWhenTurn()
        // listen for when game is over
        checkGameOver()
    
        // Track whenever app moves to the background
        self.notificationCenter.addObserver(self, selector: #selector(pauseMusic), name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(playMusic), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("health"), object: nil)
        self.notificationCenter.removeObserver(self)
    }
    
    @objc func segue() {
       let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       let vc = sb.instantiateViewController(withIdentifier: "BattleSelectActionViewController") as! BattleSelectActionViewController

       self.modalPresentationStyle = .fullScreen
       vc.modalPresentationStyle = .fullScreen
       self.present(vc, animated: false)

   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == statsDisplay { // top stats display
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
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {}
    
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
        return 30
    }
    
    func checkDeadOrAsleep() {
        print(localCharacter.isDead)
        if localCharacter.isDead || localCharacter.isAsleep {
            let popUp = createPopUpDeadAsleep()
            self.view.addSubview(popUp)
        }
    }
    
    func createPopUpDeadAsleep() -> UIView {
       // view to display
       let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
       popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)

       // label based on dead or asleep
        let label = UILabel(frame: CGRect(x: 50, y: 5, width: 250, height: 200))
        if localCharacter.isDead {
            label.text = "You are dead\nWait for the battle to complete"
            label.font = UIFont(name: "munro", size: 30)
        } else if localCharacter.isAsleep {
            label.text = "You are asleep\nWait until you wake up"
        }
       label.font = UIFont(name: "munro", size: 30)
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.textColor = UIColor.black
       label.backgroundColor = UIColor.clear
       popView.addSubview(label)

       // popView border
       popView.layer.borderWidth = 1.0
       popView.layer.borderColor = UIColor.black.cgColor

       return popView
    }
    
    func createPopUpBlind() -> UIView {
       // view to display
       let popView = UIView(frame: CGRect(x: 50, y: 350, width: 300, height: 200))
       popView.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.690, alpha: 1.0)

       // label based on blind or invisible
       let label = UILabel(frame: CGRect(x: 25, y: 5, width: 250, height: 200))
       label.text = "You are blind\nYou will not be able to see your enemies"
       label.font = UIFont(name: "munro", size: 30)
       label.lineBreakMode = .byWordWrapping
       label.numberOfLines = 0
       label.textColor = UIColor.black
       label.backgroundColor = UIColor.clear
       popView.addSubview(label)

       // popView border
       popView.layer.borderWidth = 1.0
       popView.layer.borderColor = UIColor.black.cgColor

       return popView
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
            nameArray.append(member.name)
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
        stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: spellPoints, totalPoints: totalSpellPoints))
        stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points: staminaPoints, totalPoints: totalStamina))
    }
    
    func updateLists() {
        for i in 0..<teamList.count {
            let playerRef = Firestore.firestore().collection("players").document(teamList[i].userName)
            playerRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    print("This player does not exist")
                    return
                }
                
                teamList[i].health = document.get("health") as! Int
                teamList[i].stamina = document.get("stamina") as! Int
                teamList[i].spellPoints = document.get("spell_points") as! Int
                teamList[i].hasAdvantage = document.get("has_advantage") as! Bool
                teamList[i].hasDisadvantage = document.get("has_disadvantage") as! Bool
                teamList[i].weaponInventory = rebuildWeaponInventory(weaponInventory: document.get("weapon_inventory") as! [String])
                teamList[i].currWeapon = rebuildWeaponToStore(currWeapon: document.get("current_weapon") as! String)
                teamList[i].armorInInventory = rebuildArmorInventory(armorInventory: document.get("armor_inventory") as! [String])
                teamList[i].currArmor = rebuildArmorToStore(armorToStore: document.get("current_armor") as! String)
                teamList[i].defenseModifier = document.get("defense_modifier") as! Int
                teamList[i].magicResistanceModifier = document.get("magic_resistance_modifier") as! Int
            }
        }
        
        // get enemy info again
        for i in 0..<enemiesList.count {
            let playerRef = Firestore.firestore().collection("players").document(enemiesList[i].userName)
            playerRef.getDocument { (document2, error) in
                guard let document2 = document2, document2.exists else {
                    print("This player does not exist")
                    return
                }
                
                let data = document2.data()
                enemiesList[i].health = data!["health"] as! Int
                enemiesList[i].stamina = data!["stamina"] as! Int
                enemiesList[i].spellPoints = data!["spell_points"] as! Int
                enemiesList[i].isBlind = data!["is_blind"] as! Bool
                enemiesList[i].isDead = data!["is_dead"] as! Bool
                enemiesList[i].isSleep = data!["is_asleep"] as! Bool
                enemiesList[i].isInvisible = data!["is_invisible"] as! Bool
                enemiesList[i].hasAdvantage = data!["has_advantage"] as! Bool
                enemiesList[i].hasDisadvantage = data!["has_disadvantage"] as! Bool
                enemiesList[i].weaponInventory = rebuildWeaponInventory(weaponInventory: data!["weapon_inventory"] as! [String])
                enemiesList[i].currWeapon = rebuildWeaponToStore(currWeapon: data!["current_weapon"] as! String)
                enemiesList[i].armorInInventory = rebuildArmorInventory(armorInventory: data!["armor_inventory"] as! [String])
                enemiesList[i].armor = rebuildArmorToStore(armorToStore: data!["current_armor"] as! String)
                enemiesList[i].defenseModifier = data!["defense_modifier"] as! Int
                enemiesList[i].magicResistanceModifier = data!["magic_resistance_modifier"] as! Int
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            statsDisplay.beginUpdates()
            self.stats.removeAll()
            var healthPoints:[Int] = [Int]()
            var spellPoints:[Int] = [Int]()
            var staminaPoints:[Int] = [Int]()
            var totalHealth:[Int] = [Int]()
            var totalStamina:[Int] = [Int]()
            var totalSpellPoints:[Int] = [Int]()
            for member in teamList {
                healthPoints.append(member.health)
                spellPoints.append(member.spellPoints)
                staminaPoints.append(member.stamina)
                totalHealth.append(getMaxHealth(characterClass: member.character_class))
                totalStamina.append(getMaxStamina(characterClass: member.character_class))
                print("DEBUG: my max stamina is \(getMaxStamina(characterClass: member.character_class))")
                totalSpellPoints.append(getMaxSpellPoints(characterClass: member.character_class))
            }
            self.stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: totalHealth))
            self.stats.append(StatsRow(imageName: UIImage(named: "health"), points: healthPoints, totalPoints: totalHealth))
            self.stats.append(StatsRow(imageName: UIImage(named: "SpellPoints"), points: spellPoints, totalPoints: totalSpellPoints))
            self.stats.append(StatsRow(imageName: UIImage(named: "lightningbolt"), points: staminaPoints, totalPoints: totalStamina))
            statsDisplay.reloadData()
            statsDisplay.endUpdates()
        }
    }
    
    func segueWhenTurn() {
        var first = true
        let docRef = Firestore.firestore().collection("orders").document(game)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let _ = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    
                    if !first {
                        self.updateLists()
                    } else {
                        first = false
                    }
                }
            }
        }
    }
    
    func checkGameOver() {
        let docRef = Firestore.firestore().collection("games").document(game)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.addSnapshotListener {
                    documentSnapshot, error in guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    if document.get("game_over") as! Bool {
                        print("DEBUG: game over")
                        if document.get("game_winner") as! String == team {
                            // you win!
                            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "BattleResultsVictoryViewController") as! BattleResultsVictoryViewController
                            
                            self.modalPresentationStyle = .fullScreen
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false)
                            
                        } else {
                            // you lose
                            let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "BattleResultsLossViewController") as! BattleResultsLossViewController
                            
                            self.modalPresentationStyle = .fullScreen
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: false)
                        }
                    } else {
                        print("DEBUG: game not over yet")
                    }
                }
            }
        }
    }
    
    @objc func pauseMusic() {
        backgroundMusic.pause()
    }
    
    @objc func playMusic() {
        backgroundMusic.play()
    }
}
