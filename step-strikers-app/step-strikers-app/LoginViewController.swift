//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore
var localCharacter: RPGCharacter!

class LoginViewController: UIViewController {
    let munro = "munro"
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?
    
    let buttonImg = UIImage(named:"Menu Button")
    let selectedImg = UIImage(named:"Selected Menu Button")

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        
        // Create title image
        _ = createImage(x:6, y:75, w:380, h:200, name:"Title")
        
        // Username
        _ = createLabel(x:9, y:333, w:137, h:25, font:munro, size:22, text:"Username:", align:.right)
        let username = createTextField(x:154, y:333, w:202, h:34, secured:false)
        self.usernameTextField = username!
        username?.text = ""
        // Password
        _ = createLabel(x:9, y:403, w:137, h:25, font:munro, size:22, text:"Password:", align:.right)
        let password = createTextField(x:154, y:403, w:202, h:34, secured:true)
        self.passwordTextField = password!
        password?.text = ""
        
        // Register button design
        let loginButton = createButton(x:116, y:560, w:160, h:100, text:"LOG IN", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        loginButton.addTarget(self, action:#selector(loginPressed), for:.touchUpInside)
        
        // Signin button design
        let signupButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN UP", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        signupButton.addTarget(self, action:#selector(signupPressed), for:.touchUpInside)
    }

    // when testing this use username: jazzyjalyn, password: doesn't matter yet but can't be empty
    @objc func loginPressed(_ sender: Any) {
        if self.usernameTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("username not entered")
        } else if passwordTextField!.text == "" {
            // TODO: @Nick don't print this, display it on the screen
            print("password not entered")
        } else {
            // TODO: @Kelly validate password
            let docRef = Firestore.firestore().collection("players").document(self.usernameTextField!.text!)
            docRef.getDocument { (document, error) in if let document = document, document.exists, self.passwordTextField!.text == document.get("password") as! String {
                let characterName = document.get("character_name") as! String
                let characterClass = document.get("class") as! String
                let username = self.usernameTextField!.text!
                let currHealth = document.get("health") as! Int
                let currStamina = document.get("stamina") as! Int
                let currSpellPoints = document.get("spell_points") as! Int
                let attackModifier = document.get("attack_modifier") as! Int
                let defenseModifier = document.get("defense_modifier") as! Int
                let magicResistanceModifier = document.get("magic_resistance_modifier") as! Int
                
                let weaponInventory = document.get("weapon_inventory") as! [String]
                var weaponInventoryToStore: [Weapon] = []
                // Rebuild all weapons and add them to inventory
                for weapon in weaponInventory {
                    // Splitting Weapon + UseCount from a single string
                    let weaponUseCountTuple = splitObjAndUseCount(objWithUseCount: weapon)
                    let weaponName = weaponUseCountTuple.objectName
                    let weaponUseCount: Int = weaponUseCountTuple.useCount
                    
                    // Store rebuilt weapon in inventory
                    let weaponToStore: Weapon = rebuildWeapon(weaponName: weaponName, useCount: weaponUseCount)
                    weaponInventoryToStore += [weaponToStore]
                }
                
                let currWeapon = document.get("current_weapon") as! String
                
                // Splitting currWeapon + UseCount from a single string
                let currWeaponUseCountTuple = splitObjAndUseCount(objWithUseCount: currWeapon)
                let currWeaponName = currWeaponUseCountTuple.objectName
                let currWeaponUseCount: Int = currWeaponUseCountTuple.useCount
                
                // Store rebuilt currWeapon in inventory
                let currWeaponToStore: Weapon = rebuildWeapon(weaponName: currWeaponName, useCount: currWeaponUseCount)
                
                // Rebuild all armor and add them to inventory
                let armorInventory = document.get("armor_inventory") as! [String]
                var armorInventoryToStore: [Armor] = []
                for armor in armorInventory {
                    // Splitting Armor + UseCount from a single string
                    let armorUseCountTuple = splitObjAndUseCount(objWithUseCount: armor)
                    let armorName = armorUseCountTuple.objectName
                    let armorUseCount: Int = armorUseCountTuple.useCount
                    
                    // Store rebuilt weapon in inventory
                    let armorToStore: Armor = rebuildArmor(armorName: armorName, useCount: armorUseCount)
                    armorInventoryToStore += [armorToStore]
                }
                let currArmor = document.get("current_armor") as! String
                
                // Splitting currArmor + UseCount from a single string
                let currArmorUseCountTuple = splitObjAndUseCount(objWithUseCount: currArmor)
                let currArmorName = currArmorUseCountTuple.objectName
                let currArmorUseCount: Int = currArmorUseCountTuple.useCount
                
                // Store rebuilt currWeapon in inventory
                let currArmorToStore: Armor = rebuildArmor(armorName: currArmorName, useCount: currArmorUseCount)
                
                // Build the Global Character (Does not include item inventory yet)
                switch characterClass {
                    case "Fighter":
                        localCharacter = Fighter(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Wizard":
                        localCharacter = Wizard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Rogue":
                        localCharacter = Rogue(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Bard":
                        localCharacter = Bard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    default:
                        print("Getting a characterClass not from the main 4... should not happen.")
                }
                
                let itemInventory = document.get("item_inventory") as! [String]
                var itemInventoryToStore: [Item] = []
                for item in itemInventory {
                    // Store rebuilt item in inventory
                    let currItemToStore: Item = rebuildItem(itemName: item, owner: localCharacter)
                    itemInventoryToStore += [currItemToStore]
                }
                
                localCharacter.itemsInInventory = itemInventoryToStore
                
                // Add modifiers
                localCharacter.attackModifier = attackModifier
                localCharacter.defenseModifier = defenseModifier
                localCharacter.magicResistanceModifier = magicResistanceModifier
                
                // For Testing:
                // LocalCharacter.printLocalCharacterDetailsToConsole()

                game = "zIuUhRjKte6oUcvdrP4D"
                player = localCharacter.userName
                let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "RollInitiativeViewController") as! RollInitiativeViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            } else {
                // TODO: @Nick display this on screen instead of printing
                print("Incorrect username or password")
            }
            
        }
        
        
        }
    }
    
    @objc func signupPressed(_ sender: Any) {
        let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "signupVC") as! RegistrationViewController
        
        self.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
