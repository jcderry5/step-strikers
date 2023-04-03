//
//  LoginViewController.swift
//  step-strikers-app
//
//  Created by Nicholas Huang on 2/23/23.
//

import UIKit
import FirebaseFirestore
var localCharacter: RPGCharacter!

class LoginViewController: UIViewController, UITextFieldDelegate {
    let munro = "munro"
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?
    var message:UILabel = UILabel()
    
    let buttonImg = UIImage(named:"Menu Button")
    let selectedImg = UIImage(named:"Selected Menu Button")

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        usernameTextField?.delegate = self
        
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
        
        // Invalid credentials label
        self.message = createLabel(x: 55, y: 482, w: 297, h: 20, font:munro, size:18, text:"", align:.center)
        self.message.textColor = .red
        
        // Register button design
        let loginButton = createButton(x:116, y:560, w:160, h:100, text:"LOG IN", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        loginButton.addTarget(self, action:#selector(loginPressed), for:.touchUpInside)
        
        // Signin button design
        let signupButton = createButton(x:116, y:668, w:160, h:100, text:"SIGN UP", fontSize:24, normalImage:buttonImg!, highlightedImage:selectedImg!)
        signupButton.addTarget(self, action:#selector(signupPressed), for:.touchUpInside)
        
        DispatchQueue.main.async {
            HealthKitViewController().getSteps()
        }
    }

    // Called when 'return' key pressed

    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func loginPressed(_ sender: Any) {
        if self.usernameTextField!.text == "" {
            self.message.text = "Username not entered"
        } else if passwordTextField!.text == "" {
            self.message.text = "Password not entered"
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
                
                let currDead = document.get("is_dead") as! Bool
                let currAsleep = document.get("is_asleep") as! Bool
                let currBlind = document.get("is_blind") as! Bool
                let currInvisible = document.get("is_invisible") as! Bool
                
                // Keep track of item names
                var itemNames = [String]()
                
                // Rebuild weaponInventory and weapon to store
                let weaponInventory = document.get("weapon_inventory") as! [String]
                let weaponInventoryToStore: [Weapon] = rebuildWeaponInventory(weaponInventory: weaponInventory)
                let currWeapon = document.get("current_weapon") as! String
                let currWeaponToStore: Weapon = rebuildWeaponToStore(currWeapon: currWeapon)
                
                // Add weapons to quantity array
                for weapon in weaponInventoryToStore {
                    itemNames.append(weapon.name)
                }
                
                // Rebuild armorInventory and currArmor
                let armorInventory = document.get("armor_inventory") as! [String]
                var armorInventoryToStore: [Armor] = rebuildArmorInventory(armorInventory: armorInventory)
                let currArmor = document.get("current_armor") as! String
                let currArmorToStore: Armor = rebuildArmorToStore(armorToStore: currArmor)
                
                // Add armor to quantity array
                for armor in armorInventoryToStore {
                    itemNames.append(armor.name)
                }
                
                // Build the Global Character (Does not include item inventory yet)
                switch characterClass {
                    case "Fighter":
                    localCharacter = Fighter(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, dead: currDead, asleep: currAsleep, blind: currBlind, invisible: currInvisible, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [], inventoryQuantities: [:])
                    case "Wizard":
                    localCharacter = Wizard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, dead: currDead, asleep: currAsleep, blind: currBlind, invisible: currInvisible, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [], inventoryQuantities: [:])
                    case "Rogue":
                    localCharacter = Rogue(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, dead: currDead, asleep: currAsleep, blind: currBlind, invisible: currInvisible, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [], inventoryQuantities: [:])
                    case "Bard":
                    localCharacter = Bard(characterName: characterName, userName: username, health: currHealth, stamina: currStamina, spellPoints: currSpellPoints, dead: currDead, asleep: currAsleep, blind: currBlind, invisible: currInvisible, currWeapon: currWeaponToStore, weaponsInInventory: weaponInventoryToStore, currArmor: currArmorToStore, armorInInventory: armorInventoryToStore, itemsInInventory: [], inventoryQuantities: [:])
                    default:
                        print("Getting a characterClass not from the main 4... should not happen.")
                }
                
                let itemInventory = document.get("item_inventory") as! [String]
                var itemInventoryToStore: [Item] = []
                for item in itemInventory {
                    // Store rebuilt item in inventory
                    let currItemToStore: Item = rebuildItem(itemName: item, owner: localCharacter)
                    itemInventoryToStore += [currItemToStore]
                    // Add items to quantity array
                    itemNames.append(currItemToStore.name)
                }
                
                localCharacter.itemsInInventory = itemInventoryToStore
                
                // Create quantity dictionary and send it to global character
                var itemQuantities:[String:Int] = [:]
                for name in itemNames {
                    itemQuantities[name] = (itemQuantities[name] ?? 0)+1
                }
                
                localCharacter.inventoryQuantities = itemQuantities

                // Add modifiers
                localCharacter.attackModifier = attackModifier
                localCharacter.defenseModifier = defenseModifier
                localCharacter.magicResistanceModifier = magicResistanceModifier
                
                // Apply the user's settings
                let darkMode = document.get("darkmode") as! Bool
                localCharacter.darkMode = darkMode
                
                // For Testing:
                // localCharacter.printlocalCharacterDetailsToConsole()
                game = "zIuUhRjKte6oUcvdrP4D"
                let sb:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "StatsViewController") as! StatsViewController
                self.modalPresentationStyle = .fullScreen
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            } else {
                self.message.text = "Incorrect username or password"
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
