//
//  Armor.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//


enum RPGCharacterOrCaster {
    case RPGCharacter(RPGCharacter)
    case Caster(Caster)
}


protocol Armor {
   var name: String { get set}
   var wearers: <RPGCharacterOrCaster> {get set}
   var armorClass: Int {get set}
}


struct leather: Armor {
   var armorClass: Int
   var wearers: <RPGCharacterOrCaster> {get set}
    
   func init(){
       armorClass = 11
       wearers = {Rogue, Bard}
   }
}
