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
}

struct currTargetData {
    var name:String
    var userName:String
    var character_class:String
    var health:Int
    var armor: Armor
    var defenseModifier: Int
    var armorInInventory: [Armor] // For potentially destroying poor armor
    
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
}
