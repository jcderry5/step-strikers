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

struct EnemyData {
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
    var isDead: Bool
    var isSleep: Bool
    var magicResistanceModifier: Int
    var currWeapon: Weapon
    var weaponInventory: [Weapon]
    // Have not implemented advantage and disadvantage on rollDie
    var hasAdvantage: Bool
    var hasDisadvantage: Bool
}

struct CurrTargetData {
    var name:String
    var userName:String
    var character_class:String
    var health:Int
    var armor: Armor
    var modifiedArmorClass: Int
    var attackModifier: Int
    var defenseModifier: Int
    var armorInInventory: [Armor]
    var isBlind:Bool
    var isDead: Bool
    var isSleep: Bool
    var isInvisible: Bool
    var magicResistanceModifier: Int
    var currWeapon: Weapon
    var weaponInventory: [Weapon]
    var hasAdvantage: Bool
    var hasDisadvantage: Bool
    var spellPoints: Int!
    var currStamina: Int
}

struct TeamData {
    let userName:String
    let name:String
    let character_class:String
    let health:Int
    let isBlind:Bool
    let isInvisible:Bool
    let hasAdvantage:Bool
    let defenseModifier:Int
    let spellPoints: Int
    let stamina: Int
}
