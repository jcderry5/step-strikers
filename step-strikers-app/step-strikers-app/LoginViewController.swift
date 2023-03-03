//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore
// CHANGE BEFORE PUSH TO MAIN
var LocalCharacter: RPGCharacter! = Fighter(characterName: "Roywyn the Ruthless", userName: "jazzyjalyn", health: 30, stamina: 30, currWeapon: fists(), weaponsInInventory: [fists()], currArmor: noArmor(), armorInInventory: [noArmor()], itemsInInventory: [])

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
            docRef.getDocument { (document, error) in if let document = document, document.exists {
                let characterName = document.get("character_name") as! String
                let characterClass = document.get("class") as! String
                let username = self.usernameTextField!.text!
                let currHealth = document.get("health") as! Int
                let currStamina = document.get("stamina") as! Int
                let currSpellPoints = document.get("spell_points") as! Int
                let attackModifier = document.get("attack_modifier") as! Int
                let defenseModifier = document.get("defense_modifier") as! Int
                let magicResistanceModifier = document.get("magic_resistance_modifier") as! Int
                
                // Rebuild weaponInventory and weapon to store
                let weaponInventory = document.get("weapon_inventory") as! [String]
                let weaponInventoryToStore: [Weapon] = rebuildWeaponInventory(weaponInventory: weaponInventory)
                let currWeapon = document.get("current_weapon") as! String
                let currWeaponToStore: Weapon = rebuildWeaponToStore(currWeapon: currWeapon)
                
                // Rebuild armorInventory and currArmor
                let armorInventory = document.get("armor_inventory") as! [String]
                var armorInventoryToStore: [Armor] = rebuildArmorInventory(armorInventory: armorInventory)
                let currArmor = document.get("current_armor") as! String
                let currArmorToStore: Armor = rebuildArmorToStore(armorToStore: currArmor)
                
                // Build the Global Character (Does not include item inventory yet)
                switch characterClass {
                    case "Fighter":
                        LocalCharacter = Fighter(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Wizard":
                        LocalCharacter = Wizard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Rogue":
                        LocalCharacter = Rogue(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    case "Bard":
                        LocalCharacter = Bard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [])
                    default:
                        print("Getting a characterClass not from the main 4... should not happen.")
                }
                
                let itemInventory = document.get("item_inventory") as! [String]
                var itemInventoryToStore: [Item] = []
                for item in itemInventory {
                    // Store rebuilt item in inventory
                    let currItemToStore: Item = rebuildItem(itemName: item, owner: LocalCharacter)
                    itemInventoryToStore += [currItemToStore]
                }
                
                LocalCharacter.itemsInInventory = itemInventoryToStore
                
                // Add modifiers
                LocalCharacter.attackModifier = attackModifier
                LocalCharacter.defenseModifier = defenseModifier
                LocalCharacter.magicResistanceModifier = magicResistanceModifier
                
                // For Testing:
                // LocalCharacter.printLocalCharacterDetailsToConsole()
                
                // TODO: @Nick transition to the right screen
                if username == "Player 1" {
                    print("set game and player!")
                    game = "zIuUhRjKte6oUcvdrP4D"
                    player = "Player 1"
                } else {
                    game = "zIuUhRjKte6oUcvdrP4D"
                    player = "Player 2"
                }
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
