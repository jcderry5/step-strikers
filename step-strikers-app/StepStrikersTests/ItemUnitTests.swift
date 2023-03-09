//
//  ItemUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/24/23.
//

import XCTest
@testable import step_strikers_app

final class ItemUnitTests: XCTestCase {

    var fistsForPlayerOne: Weapon!
    var fistsForPlayerTwo: Weapon!
    var noArmorForPlayerOne: Armor!
    var noArmorForPlayerTwo: Armor!
    var playerOne: Fighter!
    var playerTwo: Wizard!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fistsForPlayerOne = fists()
        fistsForPlayerTwo = fists()

        noArmorForPlayerOne = noArmor()
        noArmorForPlayerTwo = noArmor()
        
        playerOne = Fighter(characterName: "Roywyn", userName: "jazzyLinkage", health: 30, stamina: 30, currWeapon: fistsForPlayerOne, weaponsInInventory: [fistsForPlayerOne], currArmor: noArmorForPlayerOne, armorInInventory: [noArmorForPlayerOne], itemsInInventory: [], inventoryQuantities: [:])

        playerTwo = Wizard(characterName: "Althea", userName: "kellyTheKicker", health: 30, stamina: 30, spellPoints: 30, currWeapon: fistsForPlayerTwo, weaponsInInventory: [fistsForPlayerTwo], currArmor: noArmorForPlayerTwo, armorInInventory: [noArmorForPlayerTwo], itemsInInventory: [], inventoryQuantities: [:])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        fistsForPlayerOne = nil
        fistsForPlayerTwo = nil

        noArmorForPlayerOne = nil
        noArmorForPlayerTwo = nil
        
        playerOne = nil
        playerTwo = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testPotionOfHealing() {
        // Arrange - Create 2 potions and add them to inventory
        let potion = potionOfHealing(owner: playerOne)
        playerOne.decreaseHealth(amtDamage: smallAmountOfRestoration)
        playerOne.addToInventory(itemObject: potion)
        let potionForOther = potionOfHealing(owner: playerOne)
        playerTwo.decreaseHealth(amtDamage: smallAmountOfRestoration)
        playerOne.addToInventory(itemObject: potionForOther)
        
        // Pre-Check - Make sure they are in inventory and needing of potions
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth - smallAmountOfRestoration)
        XCTAssertTrue(playerTwo.currHealth == playerTwo.maxHealth - smallAmountOfRestoration)
        XCTAssertTrue(playerOne.checkInventory(itemObject: potion))
        XCTAssertTrue(playerOne.checkInventory(itemObject: potionForOther))
        
        // Act - Use potion on playerOne and potionForOther on playerTwo
        potion.use()
        potionForOther.use(target: playerTwo)
        
        // Assert - make sure both are back to full health and that both are no longer in inventory
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
        XCTAssertTrue(playerTwo.currHealth == playerTwo.maxHealth)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: potion))
        XCTAssertTrue(!playerOne.checkInventory(itemObject: potionForOther))
    }
    
    func testElixirOfMagic() {
        // Arrange - Create 2 elixirs and add them to inventory
        let elixir = elixirOfMagic(owner: playerTwo)
        playerTwo.decreaseSpellPoints(amtDecrease: smallAmountOfRestoration * 2)
        playerTwo.addToInventory(itemObject: elixir)
        let elixirForOther = elixirOfMagic(owner: playerOne)
        playerOne.addToInventory(itemObject: elixirForOther)
        
        // Pre-Check - Make sure player2 is needing of 2 elixirs
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints - (smallAmountOfRestoration * 2))
        XCTAssertTrue(playerOne.checkInventory(itemObject: elixirForOther))
        XCTAssertTrue(playerTwo.checkInventory(itemObject: elixir))
        
        // Act - Use elixir and elixirForOther on playerTwo
        elixir.use()
        elixirForOther.use(target: playerTwo)
        
        // Assert - make sure both are back to full health and that both are no longer in inventory
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: elixirForOther))
        XCTAssertTrue(!playerTwo.checkInventory(itemObject: elixir))
    }
    
    func testEnergyPill() {
        // Arrange - Create 2 elixirs and add them to inventory
        let pill = energyPill(owner: playerOne)
        playerOne.decreaseStamina(staminaCost: smallAmountOfRestoration)
        playerOne.addToInventory(itemObject: pill)
        let pillForOther = energyPill(owner: playerOne)
        playerTwo.decreaseStamina(staminaCost: smallAmountOfRestoration)
        playerOne.addToInventory(itemObject: pillForOther)
        
        // Pre-check to make sure both are in need of a pill
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina - smallAmountOfRestoration)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina - smallAmountOfRestoration)
        XCTAssertTrue(playerOne.checkInventory(itemName: pill.name))
        XCTAssertTrue(playerOne.checkInventory(itemName: pillForOther.name))
        
        // Act
        pill.use()
        pillForOther.use(target: playerTwo)
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: pill))
        XCTAssertTrue(!playerOne.checkInventory(itemObject: pillForOther))
    }
    
    func testForAntidote() {
        // TODO: @Kelly add tests for antidote
    }
    
    func testForAwakening() {
        // TODO: @Kelly add tests for awakening
    }
    
    func testPotionOfGreaterHealing() {
        // Arrange - Create 2 potions and add them to inventory
        let potion = potionOfGreaterHealing(owner: playerOne)
        playerOne.decreaseHealth(amtDamage: moderateAmountOfRestoration)
        playerOne.addToInventory(itemObject: potion)
        let potionForOther = potionOfGreaterHealing(owner: playerOne)
        playerTwo.decreaseHealth(amtDamage: moderateAmountOfRestoration)
        playerOne.addToInventory(itemObject: potionForOther)
        
        // Pre-Check - Make sure they are in inventory and needing of potions
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth - moderateAmountOfRestoration)
        XCTAssertTrue(playerTwo.currHealth == playerTwo.maxHealth - moderateAmountOfRestoration)
        XCTAssertTrue(playerOne.checkInventory(itemObject: potion))
        XCTAssertTrue(playerOne.checkInventory(itemObject: potionForOther))
        
        // Act - Use potion on playerOne and potionForOther on playerTwo
        potion.use()
        potionForOther.use(target: playerTwo)
        
        // Assert - make sure both are back to full health and that both are no longer in inventory
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
        XCTAssertTrue(playerTwo.currHealth == playerTwo.maxHealth)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: potion))
        XCTAssertTrue(!playerOne.checkInventory(itemObject: potionForOther))
    }
    
    func testElixirOfGreaterMagic() {
        // Arrange - Create 2 elixirs and add them to inventory
        let elixir = elixirOfGreaterMagic(owner: playerTwo)
        playerTwo.decreaseSpellPoints(amtDecrease: moderateAmountOfRestoration * 2)
        playerTwo.addToInventory(itemObject: elixir)
        let elixirForOther = elixirOfGreaterMagic(owner: playerOne)
        playerOne.addToInventory(itemObject: elixirForOther)
        
        // Pre-Check - Make sure player2 is needing of 2 elixirs
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints - (moderateAmountOfRestoration * 2))
        XCTAssertTrue(playerOne.checkInventory(itemObject: elixirForOther))
        XCTAssertTrue(playerTwo.checkInventory(itemObject: elixir))
        
        // Act - Use elixir and elixirForOther on playerTwo
        elixir.use()
        elixirForOther.use(target: playerTwo)
        
        // Assert - make sure both are back to full health and that both are no longer in inventory
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: elixirForOther))
        XCTAssertTrue(!playerTwo.checkInventory(itemObject: elixir))
    }
    
    func testEnergyPowder() {
        // Arrange - Create 2 elixirs and add them to inventory
        let powder = energyPowder(owner: playerOne)
        playerOne.decreaseStamina(staminaCost: moderateAmountOfRestoration)
        playerOne.addToInventory(itemObject: powder)
        let powderForOther = energyPowder(owner: playerOne)
        playerTwo.decreaseStamina(staminaCost: moderateAmountOfRestoration)
        playerOne.addToInventory(itemObject: powderForOther)
        
        // Pre-check to make sure both are in need of a pill
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina - moderateAmountOfRestoration)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina - moderateAmountOfRestoration)
        XCTAssertTrue(playerOne.checkInventory(itemName: powder.name))
        XCTAssertTrue(playerOne.checkInventory(itemName: powderForOther.name))
        
        // Act
        powder.use()
        powderForOther.use(target: playerTwo)
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina)
        XCTAssertTrue(!playerOne.checkInventory(itemObject: powder))
        XCTAssertTrue(!playerOne.checkInventory(itemObject: powderForOther))
    }
    
    func testResurrectionStone() {
        // TODO: @Kelly add tests for resurrection stone
    }
    
    func testFourLeafClover() {
        // Arrange
        let item = fourLeafClover(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == 2)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testLeatherArmor() {
        // Arrange
        let item = leatherArmorPad(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.defenseModifier == smallAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testFeatherOfVigor() {
        // Arrange
        let item = featherOfVigor(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == smallAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testScrollOfResistance() {
        // Arrange
        let item = scrollOfResistance(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.magicResistanceModifier == smallAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testPotionOfSuperiorHealing() {
        // Arrange
        let item = potionOfSuperiorHealing(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        playerOne.decreaseHealth(amtDamage: largeAmountOfRestoration)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testElixirOfSuperiorMagic() {
        // Arrange
        let item = elixirOfSuperiorMagic(owner: playerTwo)
        playerTwo.addToInventory(itemObject: item)
        playerTwo.decreaseSpellPoints(amtDecrease: largeAmountOfRestoration)
        
        // Pre-Check
        XCTAssertTrue(playerTwo.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testEnergyRoot() {
        // Arrange
        let item = energyRoot(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        playerOne.decreaseStamina(staminaCost: largeAmountOfRestoration)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testRevivalCrystal() {
        // TODO: @Kelly Add tests for revival crystal
    }
    
    func testFiveLeafClover() {
        // Arrange
        let item = fiveLeafClover(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == 5)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testMetalArmorPad() {
        // Arrange
        let item = metalArmorPad(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.defenseModifier == moderateAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testVialOfVigor() {
        // Arrange
        let item = vialOfVigor(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == moderateAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testScrollOfGreaterResistance() {
        // Arrange
        let item = scrollOfGreaterResistance(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.magicResistanceModifier == moderateAmountOfModification)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testPotionOfVitality() {
        // Arrange
        let item = potionOfVitality(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        playerOne.decreaseHealth(amtDamage: playerOne.maxHealth - 1)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        XCTAssertTrue(playerOne.currHealth == 1)
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testElixirOfSorcery() {
        // Arrange
        let item = elixirOfSorcery(owner: playerTwo)
        playerTwo.addToInventory(itemObject: item)
        playerTwo.decreaseHealth(amtDamage: playerTwo.maxSpellPoints - 1)
        
        // Pre-Check
        XCTAssertTrue(playerTwo.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerTwo.currSpellPoints == playerTwo.maxSpellPoints)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testEnergySap() {
        // Arrange
        let item = energySap(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        playerOne.decreaseStamina(staminaCost: playerOne.maxStamina - 1)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testMiracleOfLife() {
        // TODO: @Kelly Add tests for miracle of life
    }
    
    func testSevenLeafClover() {
        // Arrange
        let item = sevenLeafClover(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == 20)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
    
    func testHeartOfIron() {
        // Arrange
        let item = heartOfIron(owner: playerOne)
        playerOne.addToInventory(itemObject: item)
        
        // Pre-Check
        XCTAssertTrue(playerOne.checkInventory(itemName: item.name))
        
        // Act
        item.use()
        
        // Assert
        XCTAssertTrue(playerOne.defenseModifier == 20)
        XCTAssertTrue(!playerOne.checkInventory(itemName: item.name))
    }
}
