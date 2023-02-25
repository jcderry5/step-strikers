//
//  RPGCharacterTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/24/23.
//

import XCTest
@testable import step_strikers_app

final class RPGCharacterTests: XCTestCase {

    var fistsForPlayerOne: Weapon!
    var fistsForPlayerTwo: Weapon!
    var noArmorForPlayerOne: Armor!
    var noArmorForPlayerTwo: Armor!
    var playerOne: RPGCharacter!
    var playerTwo: RPGCharacter!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fistsForPlayerOne = fists()
        fistsForPlayerTwo = fists()

        noArmorForPlayerOne = noArmor()
        noArmorForPlayerTwo = noArmor()
        
        playerOne = Fighter(characterName: "Roywyn", userName: "jazzyLinkage", health: 30, stamina: 30, currWeapon: fistsForPlayerOne, weaponsInInventory: [fistsForPlayerOne], currArmor: noArmorForPlayerOne, armorInInventory: [noArmorForPlayerOne], itemsInInventory: [])

        playerTwo = Wizard(characterName: "Althea", userName: "kellyTheKicker", health: 30, stamina: 30, spellPoints: 30, currWeapon: fistsForPlayerTwo, weaponsInInventory: [fistsForPlayerTwo], currArmor: noArmorForPlayerTwo, armorInInventory: [noArmorForPlayerTwo], itemsInInventory: [])
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
    
    // This tests to see if the character classes are accurately returned as strings
    func testsGetClass() throws {
        // Arrange
        let classOfPlayerOne = playerOne.getCharacterClass()
        let classOfPlayerTwo = playerTwo.getCharacterClass()
        
        // Assert
        XCTAssertTrue(classOfPlayerOne == "Fighter")
        XCTAssertTrue(classOfPlayerTwo == "Wizard")
    }
    
    // This tests to see if a weapon can be wielded by those not proficient in it as well as those who are
    func testsWield() throws {
        // Act
        let weaponNotSuitedForWizards: Weapon = handAxe()
        playerOne.addToInventory(weaponObject: weaponNotSuitedForWizards)
        playerTwo.addToInventory(weaponObject: weaponNotSuitedForWizards)
        
        // Arrange
        playerOne.wield(weaponObject: weaponNotSuitedForWizards)
        playerTwo.wield(weaponObject: weaponNotSuitedForWizards)
        
        // Assert
        XCTAssertTrue(playerOne.currWeapon.name == weaponNotSuitedForWizards.name)
        XCTAssertTrue(playerTwo.currWeapon.name == weaponNotSuitedForWizards.name)
    }
    
    // Tests to see if you can add/check/remove a weaponObject
    func testWeaponInventory() {
        // Arrange
        let weaponObject = dagger()
        
        // Act - Add
        playerOne.addToInventory(weaponObject: weaponObject)
        let check: Bool = playerOne.checkInventory(weaponName: weaponObject.name)
        let removeCheck: Bool = playerOne.removeFromInventory(weaponObject: weaponObject)
        
        // Assert
        XCTAssertTrue(check == true)
        XCTAssertTrue(removeCheck == true)
    }
    
    func testsArmorInventory() {
        // Arrange
        let armorObject = chainMail()
        
        // Act - Add
        playerOne.addToInventory(armorObject: armorObject)
        let check: Bool = playerOne.checkInventory(armorName: armorObject.name)
        let removeCheck: Bool = playerOne.removeFromInventory(armorObject: armorObject)
        
        // Assert
        XCTAssertTrue(check == true)
        XCTAssertTrue(removeCheck == true)
    }
    
    func testsItemInventory() {
        // Arrange
        let itemObject = fiveLeafClover(owner: playerOne)
        
        // Act - Add
        playerOne.addToInventory(itemObject: itemObject)
        let check: Bool = playerOne.checkInventory(itemObject: itemObject)
        let removeCheck: Bool = playerOne.removeFromInventory(itemObject: itemObject)
        
        // Assert
        XCTAssertTrue(check == true)
        XCTAssertTrue(removeCheck == true)
    }
    
    func testRemoveOnlyOneItem() {
        // Arrange
<<<<<<< HEAD
        var firstItem = potionOfHealing(owner: playerOne)
        var secondItem = potionOfHealing(owner: playerOne)
=======
        let firstItem = potionOfHealing(owner: playerOne)
        let secondItem = potionOfHealing(owner: playerOne)
>>>>>>> Adding all unit tests for the classes.
        playerOne.addToInventory(itemObject: firstItem)
        playerOne.addToInventory(itemObject: secondItem)
        
        // Pre-Check
        XCTAssertTrue(playerOne.itemsInInventory.count == 2)
        
        // Act - Remove one item (and hopefully not the other)
        _ = playerOne.removeFromInventory(itemObject: firstItem)
        
        // Assert
        XCTAssertTrue(playerOne.itemsInInventory.count == 1)
        XCTAssertTrue(playerOne.checkInventory(itemName: secondItem.name))
    }
    
    // This tests to see if armor can be worn by those not suited for it as well as those suited for it
    func testsWear() throws {
        // Act
        let armorNotSuitedForWizards: Armor = chainMail()
        
        // Arrange
        playerOne.wear(armorObject: armorNotSuitedForWizards)
        playerTwo.wear(armorObject: armorNotSuitedForWizards)
        
        // Assert
        XCTAssertTrue(playerOne.currArmor.name == armorNotSuitedForWizards.name)
        XCTAssertTrue(playerTwo.currArmor.name == armorNotSuitedForWizards.name)
    }
    
    func testDecreaseStamina(){
        // Arrange
        playerOne.decreaseStamina(staminaCost: 10)
        
        //Assert
        XCTAssertTrue(playerOne.maxStamina - 10 == playerOne.currStamina)
    }
    
    func testMinStamina() {
        // Arrange
        playerOne.decreaseStamina(staminaCost: playerOne.maxStamina + 10)
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == 0)
    }
    
    func testDecreaseHealth() {
        // Arrange
        playerOne.decreaseHealth(amtDamage: 10)
        
        //Assert
        XCTAssertTrue(playerOne.maxHealth - 10 == playerOne.currHealth)
    }
    
    func testMinHealth() {
        // Arrange
        playerOne.decreaseHealth(amtDamage: playerOne.maxHealth + 10)
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == 0)
    }
    
    func testIncreaseStamina() {
        // Arrange
        playerOne.decreaseStamina(staminaCost: 10)
        playerOne.increaseStamina(amtIncrease: 5)
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxHealth - 5)
    }
    
    func testMaxStamina() {
        // Arrange
        playerOne.increaseStamina(amtIncrease: 20)
        
        // Assert
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina)
    }
    
    func testIncreaseHealth() {
        // Arrange
        playerOne.decreaseHealth(amtDamage: 10)
        playerOne.increaseHealth(amtIncrease: 5)
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth - 5)
    }
    
    func testMaxHealth() {
        // Arrange
        playerOne.increaseHealth(amtIncrease: 20)
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
    }
    
    func testsFightDamageDealt() throws {
        // Act
        // This is adjusting to ensure that damage will be taken
        playerOne.attackModifier = 20
        
        // Arrange
        playerOne.fight(target: &playerTwo)
        
        // Assert
        XCTAssertTrue(playerTwo.currHealth < playerTwo.maxHealth)
    }
    
    func testsFightAdjustCondition() {
        // Arrange
        playerOne.fight(target: &playerTwo)
        
        // Assert
        XCTAssertTrue(playerOne.currWeapon.useCount == 1)
        XCTAssertTrue(playerTwo.currArmor.useCount == 1)
    }
    
    func testsFightAdjustedStats() {
        // Arrange
        // This is adjusting to ensure that damage will be taken
        playerOne.attackModifier = 20
        
        // Act
        playerOne.fight(target: &playerTwo)
        
        // Assert: Make sure
        XCTAssertTrue(playerTwo.currHealth < playerTwo.maxHealth)
        XCTAssertTrue(playerOne.currStamina < playerTwo.maxStamina)
    }
    
    func testModifierChanges() {
        // Arrange
        playerOne.attackModifier = 5
        playerTwo.defenseModifier = 5
        
        // Act
        playerOne.fight(target: &playerTwo)
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == 0)
        XCTAssertTrue(playerTwo.defenseModifier == 0)
    }
    
    func testConditionChange() {
        // Arrange
        var handAxe = handAxe()
        handAxe.useCount = 19
        var studdedLeather = studdedLeather()
        studdedLeather.useCount = 19
        
        playerOne.wield(weaponObject: handAxe)
        playerTwo.wear(armorObject: studdedLeather)
        
        // Act
        playerOne.fight(target: &playerTwo)
        
        // Assert
        XCTAssertTrue(playerOne.currWeapon.name == "Fists")
        XCTAssertTrue(playerTwo.currArmor.name == "No Armor")
    }
    
    func testCalculateCertainDamage() {
        // Act - Setting wielderAttackModifier to 20 for certain damage
        let damage = playerOne.calculateDamage(wielderAttackModifier: 20, wielderCurrWeapon: playerOne.currWeapon, wielderClass: playerOne.getCharacterClass(), target: &playerTwo)
        
        // Assert
        XCTAssertTrue(damage > 0)
    }
    
    func testCalculateNoDamage() {
        // Arrange
        playerTwo.defenseModifier = 20
        
        let damage = playerOne.calculateDamage(wielderAttackModifier: playerOne.attackModifier, wielderCurrWeapon: playerOne.currWeapon, wielderClass: playerOne.getCharacterClass(), target: &playerTwo)
        
        // Assert
        XCTAssertTrue(damage == 0)
    }
    
    func testCalculateModifiedDamage() {
        // Arrange
        let battleAxe = battleAxe()
        playerOne.addToInventory(weaponObject: battleAxe)
        playerTwo.addToInventory(weaponObject: battleAxe)
        playerOne.wield(weaponObject: battleAxe)
        playerTwo.wield(weaponObject: battleAxe)
        
        // Act
        let p1ModifiedDamage = playerOne.calculateModifiedDamage()
        let p2ModifiedDamage = playerTwo.calculateModifiedDamage()
        
        // Assert - Because Fighters are proficient in battleaxes, this should be fine
        XCTAssertTrue(p1ModifiedDamage == battleAxe.damage)
        // Assert - Because Wizards are not proficient in battleaxes, this should be a random amount of damage between [1,battleAxe.damage)
        XCTAssertTrue(p2ModifiedDamage < battleAxe.damage)
    }
    
    func testCalculateModifiedAC() {
        let chainMail = chainMail()
        
        playerOne.wear(armorObject: chainMail)
        playerTwo.wear(armorObject: chainMail)
        
        // Act
        let p1ModifiedAC = playerOne.calculateModifiedArmorClass()
        let p2ModifiedAC = playerTwo.calculateModifiedArmorClass()
        
        // Assert - Because Fighters are suited for chainmail, this should be fine
        XCTAssertTrue(p1ModifiedAC == chainMail.armorClass)
        // Assert - Because Wizards are not suited for chain mail, this should be a random amount of damage between [1,chainMail.armorClass)
        XCTAssertTrue(p2ModifiedAC < chainMail.armorClass)
    }
    
    // TODO: @Kelly Add test for damageOpponent
}


