//
//  CharacterClasses.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/25/23.
//

import Foundation

class Fighter: RPGCharacter {
    override init(characterName: String, userName: String, health: Int,
                  stamina: Int, currWeapon: Weapon, weaponsInInventory: [Weapon], currArmor: Armor, armorInInventory: [Armor], itemsInInventory: [Item]){
        super.init(characterName: characterName, userName: userName, health: health, stamina: stamina, currWeapon: currWeapon, weaponsInInventory: weaponsInInventory, currArmor: currArmor, armorInInventory: armorInInventory, itemsInInventory: itemsInInventory)
    }
    
    // Second wind will give Fighter 10HP but cost 8 stamina
    func secondWind() {
        self.increaseHealth(amtIncrease: 10)
        self.decreaseStamina(staminaCost: 8)
    }
    
    // Action surge will give you double damage on your attack if you pass the check
    func actionSurge(target: inout RPGCharacter) {
        let damageDealt = self.calculateDamage(wielderAttackModifier: self.attackModifier, wielderCurrWeapon: self.currWeapon, wielderClass: self.getCharacterClass(), target: &target) * 2
        
        self.doConsequencesOfFight(target: &target, damageDealt: damageDealt)
        self.decreaseStamina(staminaCost: 10)
    }

    // Sharpen weapon will add 3 to your attack modifier for a cost of 7 stamina
    func sharpenWeapon() {
        self.attackModifier += 3
        self.decreaseStamina(staminaCost: 7)
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
    
    // Uncanny dodge will add three to your defense modifier but costs 5 stamina
    func uncannyDodge() {
        self.defenseModifier += 3
        self.decreaseStamina(staminaCost: 5)
    }
    
    // Hone Skill will add 5 to the attack modifier but it cost 3 stamina
    func honeSkill() {
        self.attackModifier += 5
        self.decreaseStamina(staminaCost: 3)
    }
    
    // Insight allows user to know the stats of one player, stamina cost is 6
    func insight(target: RPGCharacter) {
        // TODO: @Alekhya add code to display the stats of target
        // TODO: @kelly to add code to get the target's info for alekhya to display
        self.decreaseStamina(staminaCost: 6)
    }
    
    // Allsight will allow you to know all of your enemies' stats
    func allSight() {
        // TODO: @Alekhya + @Kelly add code to display the stats of all anemies
    }
}
