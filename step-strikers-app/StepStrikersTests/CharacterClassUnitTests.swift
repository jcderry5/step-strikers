//
//  CharacterClassUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/25/23.
//

import XCTest
@testable import step_strikers_app

final class CharacterClassUnitTests: XCTestCase {

    var fistsForPlayerOne: Weapon!
    var fistsForPlayerTwo: Weapon!
    var noArmorForPlayerOne: Armor!
    var noArmorForPlayerTwo: Armor!
    var playerOne: Fighter!
    var playerTwo: Rogue!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fistsForPlayerOne = fists()
        fistsForPlayerTwo = fists()

        noArmorForPlayerOne = noArmor()
        noArmorForPlayerTwo = noArmor()
        
        playerOne = Fighter(characterName: "Roywyn", userName: "jazzyLinkage", health: 30, stamina: 30, currWeapon: fistsForPlayerOne, weaponsInInventory: [fistsForPlayerOne], currArmor: noArmorForPlayerOne, armorInInventory: [noArmorForPlayerOne], itemsInInventory: []) as Fighter
        
        playerTwo = Rogue(characterName: "Inigo Montoya", userName: "amazingAlekhya", health: 30, stamina: 30, currWeapon: fistsForPlayerTwo, weaponsInInventory: [fistsForPlayerTwo], currArmor: noArmorForPlayerTwo, armorInInventory: [noArmorForPlayerTwo], itemsInInventory: []) as Rogue
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
    
    func testSecondWind() {
        // Arrange
        playerOne.decreaseHealth(amtDamage: 10)
        
        // Act
        playerOne.secondWind()
        
        // Assert
        XCTAssertTrue(playerOne.currHealth == playerOne.maxHealth)
        XCTAssertTrue(playerOne.currStamina == playerTwo.maxStamina - 8)
    }
    
    func testActionSurge() {
        // Arrange
        playerOne.attackModifier += 20
        
        // Act
        var playerTwoAsRPGCharacter: RPGCharacter = playerTwo!
        playerOne.actionSurge(target: &playerTwoAsRPGCharacter)
        let expectedDamageDealt = playerOne.currWeapon.damage * 2
        let expectedStaminaCost = playerOne.currWeapon.staminaCost + 10
        
        // Assert
        XCTAssertTrue(playerTwo.currHealth == playerTwo.maxHealth - expectedDamageDealt)
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina - expectedStaminaCost)
    }
    
    func testSharpenWeapon() {
        // Act
        playerOne.sharpenWeapon()
        
        // Assert
        XCTAssertTrue(playerOne.attackModifier == 3)
        XCTAssertTrue(playerOne.currStamina == playerOne.maxStamina - 7)
    }

    func testUncannyDodge() {
        // Act
        playerTwo.uncannyDodge()
        
        // Assert
        XCTAssertTrue(playerTwo.defenseModifier == 3)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina - 5)
    }
    
    func testHoneSkill() {
        // Act
        playerTwo.honeSkill()
        
        // Assert
        XCTAssertTrue(playerTwo.attackModifier == 5)
        XCTAssertTrue(playerTwo.currStamina == playerTwo.maxStamina - 3)
    }
    
    func testInsight() {
        // TODO: @Alekhya add tests for insight
    }
    
    func testAllSight() {
        // TODO: @Alekhya add tests for allSight
    }
}
