
func rollDie(quant: Int, sides: Int) -> Int {
    var sum: Int = 0
    
    for _ in 1...quant {
        sum += Int.random(in: 1...sides)
    }
    
    return sum
}

//
//// top level code
//let plateMail = Armor(armorType: "plate")
//let chainMail = Armor(armorType: "chain")
//let sword = Weapon(weaponType: "sword")
//let staff = Weapon(weaponType: "staff")
//let axe = Weapon(weaponType: "axe")
//
//let gandalf = Wizard(name: "Gandalf the Grey")
//gandalf.wield(weaponObject: staff)
//
//let aragorn = Fighter(name: "Aragorn")
//aragorn.putOnArmor(armorObject: plateMail)
//aragorn.wield(weaponObject: axe)
//
//gandalf.show()
//aragorn.show()
//
//gandalf.castSpell(spellName: "Fireball", target: aragorn)
//aragorn.fight(opponent: gandalf)
//
//gandalf.show()
//aragorn.show()
//
//gandalf.castSpell(spellName: "Lightning Bolt", target: aragorn)
//aragorn.wield(weaponObject: sword)
//
//gandalf.show()
//aragorn.show()
//
//gandalf.castSpell(spellName: "Heal", target: gandalf)
//aragorn.fight(opponent: gandalf)
//
//gandalf.fight(opponent: aragorn)
//aragorn.fight(opponent: gandalf)
//
//gandalf.show()
//aragorn.show()

print("Starting!")
var player1 = Fighter(name: "Nick")
var player2 = Wizard(name: "Kelly")
var player3 = Fighter(name: "Jalyn")
var player4 = Wizard(name: "Alekhya")

print("Made players!")
var blueTeam = [player1, player2]
var redTeam = [player3, player4]

print("Made team")
var currGame = Game(blueTeam: blueTeam, redTeam: redTeam)

//print("Curr game was made")
//currGame.viewInitiativeOrder()

