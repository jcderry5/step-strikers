//
//  RPGCharacter.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/7/23.
//

import FirebaseFirestore

class RPGCharacter {
    var characterName: String
    var userName: String
    
    // Character Stats Variables
    var maxHealth: Int
    var currHealth: Int
    var maxStamina: Int
    var currStamina: Int
    
    // Inventory Variables
    var weaponsInInventory: [Weapon]
    var currWeapon: Weapon
    var armorInInventory: [Armor]
    var currArmor: Armor
    var itemsInInventory: [Item]
    
    // Rolling modifiers
    var attackModifier = 0
    var defenseModifier = 0
    var magicResistanceModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]){
        self.characterName = characterName
        self.userName = userName
        self.maxHealth = health
        self.currHealth = health
        self.maxStamina = stamina
        self.currStamina = stamina
        
        // Initialize Starter Inventory
        self.weaponsInInventory = weaponsInInventory
        self.currWeapon = currWeapon
        self.armorInInventory = armorInInventory
        self.currArmor = currArmor
        self.itemsInInventory = itemsInInventory
        print(self is Fighter)
    }
    
    // Returns a string of the class of the current character
    func getCharacterClass() -> String {
        switch self {
        case is Fighter:
            return "Fighter"
        case is Wizard:
            return "Wizard"
        case is Bard:
            return "Bard"
        case is Rogue:
            return "Rogue"
        default:
            return "Does not have a class?"
        }
    }
    
    // Universal Functions
    func wield(weaponObject: Weapon){
        if(weaponObject.checkIfProficient(wearer: self)){
            self.currWeapon = weaponObject
        } else {
            print("\(self.characterName) is not proficient with \(weaponObject.name).\n They will use this weapon at a disadvantage")
            self.currWeapon = weaponObject
        }
    }

    func wear(armorObject: Armor){
        if(armorObject.checkIfSuited(potentialWearer: self)){
            self.currArmor = armorObject
        } else {
            print("\(armorObject.name) is not properly suited for \(self.characterName). Their armor class will be at a disadvantage")
        }
    }

    func fight(target: inout RPGCharacter){
        let damageDealt = calculateDamage(wielder: self, target: target, damage: self.currWeapon.damage)
        decreaseHealth(amtDamage: damageDealt)
        decreaseStamina()
    }

    func decreaseStamina(){
        self.currStamina -= self.currWeapon.staminaCost
        // TODO: Do something when exhausted
        if self.currStamina < 0 {
            self.currStamina = 0
        }
    }

    func decreaseHealth(amtDamage: Int){
        self.currHealth -= amtDamage
        if self.currHealth < 0 {
            self.currHealth = 0
            // TODO: Add functionality for when a person dies
        }
    }

    func increaseStamina(amtIncrease: Int){
        self.currStamina += amtIncrease
        if(amtIncrease > self.maxStamina){
            self.currStamina = self.maxStamina
        }
    }

    func increaseHealth(amtIncrease: Int){
        self.currHealth += amtIncrease
        if(amtIncrease > self.maxHealth){
            self.currHealth = self.maxHealth
        }
    }
    
    func damageOpponent(target: String, damage: Int) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentHealth = document.get("health") as! Int
                let newHealth = max(0, currentHealth - damage)
                
                Firestore.firestore().collection("players").document(target).setData(["health": newHealth], merge: true)
            }
        }
    }
}


class Caster: RPGCharacter {
    var currSpellPoints: Int
    var maxSpellPoints: Int
    
    // Rolling modifier
    var spellModifier = 0
    
    init(characterName: String, userName: String, health: Int,
         stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        self.currSpellPoints = spellPoints
        self.maxSpellPoints = spellPoints
        super.init(characterName: characterName, userName: userName, health: health,
                   stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
    
    func increaseSpellPoints(amtIncrease: Int){
        self.currSpellPoints += amtIncrease
        if(self.currSpellPoints > maxSpellPoints){
            self.currSpellPoints = maxSpellPoints
        }
    }
    
    func decreaseSpellPoints(amtDecrease: Int){
        self.currSpellPoints -= amtDecrease
    }
    
    func castFrostbite(caster: String, target: String) {
        damageOpponent(target: target, damage: 1)
        decreaseSpellPoints(amtDecrease: 3)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast frosbite on \(target)")
    }
    
    func castMageHand(caster: String, target: String) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // get info about target's current weapon
                let weaponName = document.get("current_weapon") as! String
                let weaponMap = document.get("weapon_inventory") as! [String:[String:Int]]
                let condition = weaponMap[weaponName]!["condition"]
                let useCount = weaponMap[weaponName]!["use_count"]
                
                // update target info on firebase
                Firestore.firestore().collection("players").document(target).updateData([
                    "weapon_inventory": FieldValue.arrayRemove([weaponName])])
                Firestore.firestore().collection("players").document(target).setData(["current_weapon": "fists"], merge: true)
                
                // update own info locally
                    // TODO: @Jalyn when you figure out Weapon/RPGCharacter init
                    // initialize new weapon
                    // set self.currWeapon to that
                    // put weapon in their inventory
                
            }
        }
        decreaseSpellPoints(amtDecrease: 20)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast mage hand on \(target)")
        
    }
    
    func castShield(caster: String, target: String) {
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentModifier = document.get("defense_modifier") as! Int
                Firestore.firestore().collection("players").document(target).setData(["defense_modifier": currentModifier + 5], merge: true)
            }
        }
        
        decreaseSpellPoints(amtDecrease: 4)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast shield on \(target)")
    }
    
    func castBardicInspiration(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["has_advantage": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 7)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast bardic inspiration on \(target)")
    }
    
    func castViciousMockery(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["has_disadvantage": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 7)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast vicious mockery on \(target)")
    }
    
    func castBlindness(caster: String, target: String, game: String) {
        Firestore.firestore().collection("players").document(target).setData(["is_blind": true], merge: true)
        Firestore.firestore().collection("games").document(game).updateData([
            "blind": FieldValue.arrayUnion([target])])
        
        decreaseSpellPoints(amtDecrease: 8)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast blindness on \(target)")
    }
    
    func castInvisibility(caster: String, target: String, game: String) {
        Firestore.firestore().collection("games").document(game).updateData([
            "invisible": FieldValue.arrayUnion([target])])
     
        decreaseSpellPoints(amtDecrease: 10)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast invisibility on \(target)")
    }
    
    func castMotivationalSpeech(caster: String, team: String) {
        let teamRef = Firestore.firestore().collection("teams").document(team)
        teamRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let teammates = document.get("players") as! [String]
                
                for teammate in teammates {
                    Firestore.firestore().collection("players").document(teammate).setData(["has_advantage": true], merge: true)
                }
            }
        }
        
        decreaseSpellPoints(amtDecrease: 15)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast motivational speech on their team")
    }
    
    func castAnimateDead(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["health": 1], merge: true)
        
        decreaseSpellPoints(amtDecrease: 17)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast animate dead on \(target)")
    }
    
    func heal(caster: String, target: String) {
        let amtToHeal = rollDie(quant: 1, sides: 8)
        
        let targetRef = Firestore.firestore().collection("players").document(target)
        targetRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let currentHealth = document.get("health") as! Int
                let maxHealth = document.get("max_health") as! Int
                let newHealth = min(maxHealth, currentHealth + amtToHeal)
                
                Firestore.firestore().collection("players").document(target).setData(["health": newHealth], merge: true)
            }
        }
        
        decreaseSpellPoints(amtDecrease: 5)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast heal on \(target)")
    }
    
    func sleep(caster: String, target: String) {
        Firestore.firestore().collection("players").document(target).setData(["is_asleep": true], merge: true)
        
        decreaseSpellPoints(amtDecrease: 12)
        
        // @Jalyn probably replace this with the logging strings you were talking about?
        print("\(caster) cast sleep on \(target)")
    }

}
    
class Fighter: RPGCharacter {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}

class Wizard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}


class Bard: Caster {
    override init(characterName: String, userName: String, health: Int, stamina: Int, spellPoints: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, spellPoints: spellPoints, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}


class Rogue: RPGCharacter {
    override init(characterName: String, userName: String, health: Int, stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]) {
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
}
