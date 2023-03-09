//
//  BattleTableStructs.swift
//  step-strikers-app
//
//  Created by Alekhya Kuchimanchi on 2/23/23.
//

import UIKit

// struct that will hold the name and quantity of an item a player has
struct Items {
    let name:String?
    let quantity:String?
}

// struct that holds the name and the stamina or magic cost of the action
struct Action {
    let name:String?
    let staminaCost:String?
}

// struct that holds the name of a weapon or armor and the quanity of it a player has
struct Equip {
    let name:String?
    let quantity:String?
}

struct StatsRow {
    let imageName:UIImage?
    let points:[Int]
    let totalPoints:[Int]
}

struct StatsHeaderRow {
    let names:[String]
}

struct enemyData {
    var userName:String
    var name:String
    var character_class:String
    var health:Int
    var isBlind:Bool
    var isInvisible:Bool
    var imageView:UIImageView
    
    // Data needed about the enemies for fighting them
    var armor: Armor
    var defenseModifier: Int
    var armorInInventory: [Armor]
    
    // New attributes for spells:
    var magicResistanceModifier: Int
    var isDead: Bool
    var isSleep: Bool
    // Have not implemented advantage and disadvantage on rollDie
    var hasAdvantage: Bool
    var hasDisadvantage: Bool
}

struct currTargetData {
    var name:String
    var userName:String
    var character_class:String
    var health:Int
    var armor: Armor
    var modifiedArmorClass: Int
    var defenseModifier: Int
    var armorInInventory: [Armor] // For potentially destroying poor armor
    
    // Added values for spells
    // TODO: Need to add this to updateCurrTarget or this will be nil
    var isBlind:Bool
    var isDead: Bool
    var isSleep: Bool
    var magicResistanceModifier: Int
    var currWeapon: Weapon
    var weaponInventory: [Weapon]
    // Have not implemented advantage and disadvantage on rollDie
    var hasAdvantage: Bool
    var hasDisadvantage: Bool
    
    func printEnemyData() {
        print("currTarget name is: \(name)")
        print("currTarget character class is: \(character_class)")
        print("currTarget health is: \(health)")
        print("currTarget armor name is: \(armor.name)")
        print("currTarget defense modifier is: \(defenseModifier)")
        print("currTarget armor inventory count is: \(armorInInventory.count)")
    }
}

struct teamData {
    let userName:String
    let name:String
    let character_class:String
    let health:Int
    let isBlind:Bool
    let isInvisible:Bool
    // Added for spells
    let hasAdvantage:Bool
    let defenseModifier:Int
}

struct currTeamMemberData {
    var name: String
    var characterClass:String
    var health: Int
    var isInvisible:Bool
    var hasAdvantage: Bool
    var defenseModifier: Int
}
