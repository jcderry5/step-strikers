//
//  ArmorUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/24/23.
//

import XCTest
@testable import step_strikers_app

final class ArmorUnitTests: XCTestCase {

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

    func testCheckIfProficient() {
        // Assert
        let chainMail = chainMail()
        
        let playerOneProficiency = chainMail.checkIfSuited(potentialWearer: playerOne)
        let playerTwoProficiency = chainMail.checkIfSuited(potentialWearer: playerTwo)
        
        XCTAssertTrue(playerOneProficiency == true)
        XCTAssertTrue(playerTwoProficiency == false)
    }
    
    func testInitialization() {
        // Arrange
        let newChainMail = chainMail()
        let usedChainMail = chainMail(useCount: 12)
        
        // Assert
        XCTAssertTrue(newChainMail.useCount == 0)
        XCTAssertTrue(newChainMail.condition == 4)
        XCTAssertTrue(usedChainMail.useCount == 12)
        XCTAssertTrue(usedChainMail.condition == 2)
    }
    
    func testAdjustWeaponConditionNoArmor(){
        // Act - PlayerOne's current weapon is set to Fists
        let currArmor = adjustArmorCondition(owner: &playerOne, armorUsed: &playerOne.currArmor)
        
        // Assert
        XCTAssertTrue(currArmor.name == playerOne.currArmor.name)
    }
    
    func testAdjustingArmorCondition() {
        // Arrange
        var leather = leather() as Armor
        let noArmor = noArmor()
        var armorInventory: [Armor] = [noArmor, leather]
        
        playerOne.wear(armorObject: leather)
        playerOne.armorInInventory = armorInventory
        
        // Act - Get to Good Condition
        for _ in 1...5 {
            leather = adjustArmorCondition(owner: &playerOne, armorUsed: &playerOne.currArmor)
        }
        
        // Assert
        XCTAssertTrue(leather.useCount == 5)
        XCTAssertTrue(leather.condition == 3)
        
        // Act - Get to Fair Condition
        for _ in 1...5 {
            leather = adjustArmorCondition(owner: &playerOne, armorUsed: &playerOne.currArmor)
        }
        
        // Assert
        XCTAssertTrue(leather.useCount == 10)
        XCTAssertTrue(leather.condition == 2)
        
        // Act - Get to Poor Condition
        for _ in 1...5 {
            leather = adjustArmorCondition(owner: &playerOne, armorUsed: &playerOne.currArmor)
        }
        
        // Assert
        XCTAssertTrue(leather.useCount == 15)
        XCTAssertTrue(leather.condition == 1)
    }
    
    func testAdjustArmorConditionMax() {
        // Arrange
        var myArmor = leather() as Armor
        let noArmor = noArmor()
        var armorInventory: [Armor] = [noArmor, myArmor]
        playerOne.wear(armorObject: myArmor)
        playerOne.armorInInventory = armorInventory
        
        // Act
        for _ in 1...20 {
            myArmor = adjustArmorCondition(owner: &playerOne, armorUsed: &myArmor)
        }
        
        // Assert
        XCTAssertTrue(myArmor.name == noArmor.name)
    }
    
    func testDestroyArmor() {
        // Arrange
        var myArmor = leather() as Armor
        myArmor.useCount = 20
        let noArmor = noArmor()
        var armorInventory: [Armor] = [noArmor, myArmor]
        playerOne.wear(armorObject: myArmor)
        playerOne.armorInInventory = armorInventory
        
        // Act
        let newCurrArmor = destroyArmor(owner: &playerOne, armorToDestroy: myArmor)
        
        // Assert
        XCTAssertTrue(newCurrArmor.name == noArmor.name)
        XCTAssertTrue(!playerOne.armorInInventory.contains(where: {armor in armor.name == myArmor.name}))
        XCTAssertTrue(playerOne.armorInInventory.count == 1)
    }
}
