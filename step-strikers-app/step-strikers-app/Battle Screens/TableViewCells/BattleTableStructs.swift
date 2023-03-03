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

// TODO: @Jalyn edit this struct to add the variables you need
struct enemyData {
    var userName:String
    var name:String
    var character_class:String
    var health:Int
    var isBlind:Bool
    var isInvisible:Bool
    var imageView:UIImageView
    
    // New attributes
    var armor: Armor
    var defenseModifier: Int
    var armorInInventory: [Armor] // For potentially destroying poor armor
}

struct teamData {
    let userName:String
    let name:String
    let character_class:String
    let health:Int
    let isBlind:Bool
    let isInvisible:Bool
}
