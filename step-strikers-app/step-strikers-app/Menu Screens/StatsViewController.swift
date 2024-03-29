//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit
import HealthKit
var steps:Int = 0

class StatsViewController: UIViewController {
    
    let cellId = "statsCell"
    var boostTotal = 3000
    var numTillBoost = 0
    
    var background:UIImageView?
    var notificationCenter = NotificationCenter.default
    var timer:Timer!
    
    var stepsLabel:UILabel!
    var boostLabel:UILabel!
    
    var player:UIImageView!
    var count = 28

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Track whenever app moves to the background
        self.notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // TODO: Pull steps info from firebase and display it here
        getStepsData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            HealthKitViewController().getSteps()
        }
        
        playBackgroundAudio(fileName: nonCombatBattleMusicFile)
        checkDarkMode()
        self.background = assignSwitchableBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        
        // Pull stats data from LocalCharacter and use as label text
        let characterClass = localCharacter.getCharacterClass()
        
        // animations
        player = createImage(x: 140, y: 716, w: 112, h: 112, name: "\(characterClass)WalkWithSword_28")
        timer = Timer.scheduledTimer(
            timeInterval: 0.3, target: self, selector: #selector(changeWalk),
            userInfo: nil, repeats: true)
        
        // Create menu title label
        _ = createImage(x:27, y:0, w:338, h:200, name:"Menu Title Board")
        _ = createLabel(x:53, y:91, w:286, h:89, font:"iso8", size:45, text:"STATS", align:.center)
        
        // Create the display board and its contents
        _ = createImage(x:0, y:219, w:393, h:374, name:"Display Board")
        
        // Health stats

        let currHealth = localCharacter.currHealth
        let maxHealth = getMaxHealth(characterClass: localCharacter.getCharacterClass())
        _ = createImage(x: 25, y: 251, w: 75, h: 75, name: "health")
        _ = createLabel(x: 116, y: 251, w: 150, h: 65, font: "munro", size: 33, text: "\(currHealth)/\(maxHealth)", align: .left)
        
        // Magic stats
        var currMagic = 0
        let maxMagic = getMaxSpellPoints(characterClass: localCharacter.getCharacterClass())
        if let caster = localCharacter as? Caster {
            currMagic = caster.currSpellPoints
        }
        _ = createImage(x: 25, y: 326, w: 70, h: 70, name: "SpellPoints")
        _ = createLabel(x: 116, y: 326, w: 150, h: 65, font: "munro", size: 33, text: "\(currMagic)/\(maxMagic)", align: .left)
        
        // Stamina stats
        let currStamina = localCharacter.currStamina
        let maxStamina = getMaxStamina(characterClass: localCharacter.getCharacterClass())
        _ = createImage(x: 45, y: 411, w: 45, h: 65, name: "lightningbolt")
        _ = createLabel(x: 116, y: 411, w: 150, h: 65, font: "munro", size: 33, text: "\(localCharacter.currStamina)/\(maxStamina)", align: .left)
        
        // Armor class
        let ac = localCharacter.currArmor.armorClass
        _ = createImage(x: 35, y: 486, w: 65, h: 75, name: "Shield")
        _ = createLabel(x: 116, y: 496, w: 150, h: 65, font: "munro", size: 33, text: "\(ac)", align: .left)

        // Health refill
        let healthTime = (maxHealth - currHealth) * 10
        if healthTime != 0 {
            _ = createImage(x: 227, y: 261, w: 35, h: 45, name: "Hourglass")
            _ = createLabel(x: 265, y: 251, w: 150, h: 75, font: "munro", size: 33, text: "\(healthTime) min", align: .left)
        }
        
        // Magic refill
        let magicTime = maxMagic > 0 ? (maxMagic - currMagic) * 10 : 0
        if magicTime != 0 {
            _ = createImage(x: 227, y: 336, w: 35, h: 45, name: "Hourglass")
            _ = createLabel(x: 265, y: 326, w: 150, h: 75, font: "munro", size: 33, text: "\(magicTime) min", align: .left)
        }
        
        // Stamina refill
        let staminaTime = (maxStamina - currStamina) * 10
        if staminaTime != 0 {
            _ = createImage(x: 227, y: 421, w: 35, h: 45, name: "Hourglass")
            _ = createLabel(x: 265, y: 411, w: 150, h: 75, font: "munro", size: 33, text: "\(staminaTime) min", align: .left)
        }
        
        // Display steps info
        _ = createImage(x: 25, y: 618, w: 75, h: 75, name: "brown boots")
        self.stepsLabel = self.createLabel(x: 130, y: 624, w: 253, h: 41, font: "munro", size: 28, text: "", align: .left)
        self.boostLabel = self.createLabel(x: 130, y: 653, w: 253, h: 41, font: "munro", size: 28, text: "", align: .left)
        
        // Swipe area
        _ = createLabel(x: 285, y: 690, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 275, y: 739, w: 112, h: 62, name: "right arrow")
        
        // Swipe left handler
        let swipeView = UIView(frame: CGRect(x: 0, y: 650, width: 393, height: 142))
        view.addSubview(swipeView)
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if localCharacter.darkMode {
            self.background?.image = UIImage(named: "Background-darkmode")
        } else {
            self.background?.image = UIImage(named: "Background")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.notificationCenter.removeObserver(self)
        timer.invalidate()
    }
    
    func dataTypesToWrite() -> NSSet{
        let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        let returnSet = NSSet(objects: stepsCount!)
        return returnSet
    }
    
    func dataTypesToRead() -> NSSet{
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let returnSet = NSSet(objects: stepsCount!)

        return returnSet
    }

    @objc func swipeLeft() {
        playSoundEffect(fileName: menuSelectEffect)
        // Navigate to the INVENTORY screen
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InventoryViewController") as! InventoryViewController

        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    @objc func appMovedToBackground() {
        backgroundMusic.pause()
        // Allow timers to fire when in background mode
        var bgTask:UIBackgroundTaskIdentifier!
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
            let healthStore = HKHealthStore()
            if HKHealthStore.isHealthDataAvailable(){
                let writeDataTypes = self.dataTypesToWrite()
                let readDataTypes = self.dataTypesToWrite()
                 
                healthStore.requestAuthorization(toShare: writeDataTypes as? Set<HKSampleType>, read: readDataTypes as? Set<HKObjectType>, completion: { (success, error) in
                    if(!success){
                        print("error")
                        return
                    }
                    DispatchQueue.main.async {
                        HealthKitViewController().getTodaysSteps() { sum in
                            steps = Int(sum)
                            let milestone = localCharacter.currMilestone!
                            if steps >= milestone && localCharacter.notifications {
                                if milestoneItemDrop() != "" {
                                    // Send a notification
                                    let content = UNMutableNotificationContent()
                                    content.title = "You found a new item!"
                                    content.sound = UNNotificationSound.default
                                    
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                    let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
                                    
                                    UNUserNotificationCenter.current().add(request)
                                    
                                    localCharacter.currMilestone += 3000
                                }
                            }
                        }
                    }
                })
            }
        })
    }
    
    @objc func appMovedToForeground() {
        self.timer.invalidate()
        backgroundMusic.play()
        getStepsData()
    }
    
    @objc func changeWalk() {
            UIView.animate(withDuration: 0, animations: {
                self.player.image = UIImage(named: "\(localCharacter.getCharacterClass())WalkWithSword_\(self.count)")
            })
            count += 1
            if count > 35 {
                count = 28
            }
//        }
    }
    
    func getStepsData() {
        let healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable(){
            let writeDataTypes = dataTypesToWrite()
            let readDataTypes = dataTypesToWrite()
            
            healthStore.requestAuthorization(toShare: writeDataTypes as? Set<HKSampleType>, read: readDataTypes as? Set<HKObjectType>, completion: { (success, error) in
                if(!success){
                    print("error")
                    return
                }
                DispatchQueue.main.async {
                    HealthKitViewController().getTodaysSteps() { sum in
                        steps = Int(sum)
                        var trackBoost:Int = 0
                        let boostMod = steps / self.boostTotal + 1
                        trackBoost = self.boostTotal * boostMod - steps
                        
                        self.stepsLabel.text = "\(Int(steps)) steps taken"
                        
                        if localCharacter.currMilestone <= 12000 {
                            self.boostLabel.text = "\(Int(trackBoost)) steps until drop"
                            
                            if steps >= localCharacter.currMilestone {
                                // Create popup notifying in-game users
                                let itemName = milestoneItemDrop()
                                if itemName != "" {
                                    DispatchQueue.main.async {
                                        self.createNotification(itemName: itemName)
                                    }
                                    localCharacter.currMilestone += 3000
                                }
                            }
                        } else {
                            self.boostLabel.text = "No drops remaining"
                        }
                    }
                }
            })
        }
    }
}
