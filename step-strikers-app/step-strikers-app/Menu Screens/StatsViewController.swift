//
//  StatsViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 3/2/23.
//

import UIKit
import HealthKit
import Foundation

var steps:Double = 0.0

class StatsViewController: UIViewController {
    
    let cellId = "statsCell"
    var boostTotal = 3000
    var numTillBoost = 0
    
    // Audio
    let nonCombatBattleMusicFile: String = "Woodland Fantasy.mp3"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: Pull steps info from firebase and display it here
        if steps == 0 {
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
                            steps = sum
                            var trackBoost:Double = 0.0
                            trackBoost = steps.truncatingRemainder(dividingBy: Double(self.boostTotal))
                            _ = self.createLabel(x: 130, y: 624, w: 253, h: 41, font: "munro", size: 28, text: "\(Int(trackBoost)) steps until boost", align: .left)
                            _ = self.createLabel(x: 130, y: 653, w: 253, h: 41, font: "munro", size: 28, text: "\(Int(steps)) taken today", align: .left)
                        }
                    }
                    
                })
            }
        } else {
            var trackBoost:Double = 0.0
            trackBoost = steps.truncatingRemainder(dividingBy: Double(self.boostTotal))
            _ = self.createLabel(x: 130, y: 624, w: 253, h: 41, font: "munro", size: 28, text: "\(Int(trackBoost)) steps until boost", align: .left)
            _ = self.createLabel(x: 130, y: 653, w: 253, h: 41, font: "munro", size: 28, text: "\(Int(steps)) taken today", align: .left)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            HealthKitViewController().getSteps()
        }
        
        playBackgroundAudio(fileName: nonCombatBattleMusicFile)
        
        assignBackground()
        createSettingsButton(x: 325, y: 800, width: 40, height: 40)
        
        // Create menu title label
        _ = createImage(x:27, y:0, w:338, h:200, name:"Menu Title Board")
        _ = createLabel(x:53, y:91, w:286, h:89, font:"iso8", size:45, text:"STATS", align:.center)
        
        // Create the display board and its contents
        _ = createImage(x:0, y:219, w:393, h:374, name:"Display Board")
        
        // Pull stats data from LocalCharacter and use as label text
        let characterClass = localCharacter.getCharacterClass()
        
        // Health stats
        let currHealth = localCharacter.currHealth
        let maxHealth = localCharacter.maxHealth
        _ = createImage(x: 25, y: 251, w: 75, h: 75, name: "health")
        _ = createLabel(x: 116, y: 251, w: 150, h: 65, font: "munro", size: 33, text: "\(currHealth)/\(maxHealth)", align: .left)
        
        // Magic stats
        var currMagic = 0
        var maxMagic = 0
        if let caster = localCharacter as? Caster {
            currMagic = caster.currSpellPoints
            maxMagic = caster.maxSpellPoints
        }
        _ = createImage(x: 25, y: 326, w: 70, h: 70, name: "SpellPoints")
        _ = createLabel(x: 116, y: 326, w: 150, h: 65, font: "munro", size: 33, text: "\(currMagic)/\(maxMagic)", align: .left)
        
        // Stamina stats
        let currStamina = localCharacter.currStamina
        let maxStamina = localCharacter.maxStamina
        _ = createImage(x: 45, y: 411, w: 45, h: 65, name: "lightningbolt")
        _ = createLabel(x: 116, y: 411, w: 150, h: 65, font: "munro", size: 33, text: "\(localCharacter.currStamina)/\(localCharacter.maxStamina)", align: .left)
        
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
        
        // Swipe area
        _ = createImage(x: 140, y: 716, w: 112, h: 112, name: characterClass)
        _ = createLabel(x: 285, y: 690, w: 92, h: 67, font: "munro", size: 20, text: "SWIPE", align: .center)
        _ = createImage(x: 275, y: 739, w: 112, h: 62, name: "right arrow")
        
        // Swipe left handler
        let swipeView = UIView(frame: CGRect(x: 0, y: 650, width: 393, height: 142))
        view.addSubview(swipeView)
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        swipeView.addGestureRecognizer(swipeLeft)
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
        // Navigate to the INVENTORY screen
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InventoryViewController") as! InventoryViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
