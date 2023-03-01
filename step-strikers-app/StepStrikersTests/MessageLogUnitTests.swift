//
//  MessageLogUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/28/23.
//

import XCTest
@testable import step_strikers_app

final class MessageLogUnitTests: XCTestCase {

    var fistsForPlayerOne: Weapon!
    var fistsForPlayerTwo: Weapon!
    var fistsForPlayerThree: Weapon!
    var noArmorForPlayerOne: Armor!
    var noArmorForPlayerTwo: Armor!
    var noArmorForPlayerThree: Armor!
    var playerOne: Fighter!
    var playerTwo: Wizard!
    var playerThree: Rogue!
    
    override func setUpWithError() throws {
        fistsForPlayerOne = fists()
        fistsForPlayerTwo = fists()
        fistsForPlayerThree = fists()

        noArmorForPlayerOne = noArmor()
        noArmorForPlayerTwo = noArmor()
        noArmorForPlayerThree = noArmor()
        
        playerOne = Fighter(characterName: "Roywyn", userName: "jazzyLinkage", health: 30, stamina: 30, currWeapon: fistsForPlayerOne, weaponsInInventory: [fistsForPlayerOne], currArmor: noArmorForPlayerOne, armorInInventory: [noArmorForPlayerOne], itemsInInventory: [])

        playerTwo = Wizard(characterName: "Althea", userName: "kellyTheKicker", health: 30, stamina: 30, spellPoints: 30, currWeapon: fistsForPlayerTwo, weaponsInInventory: [fistsForPlayerTwo], currArmor: noArmorForPlayerTwo, armorInInventory: [noArmorForPlayerTwo], itemsInInventory: [])
        
        playerThree = Rogue(characterName: "Inigo Montoya", userName: "amazingAlekhya", health: 30, stamina: 30, currWeapon: fistsForPlayerThree, weaponsInInventory: [fistsForPlayerThree], currArmor: noArmorForPlayerThree, armorInInventory: [noArmorForPlayerThree], itemsInInventory: [])
        
        messageLog = MessageLog()
    }

    override func tearDownWithError() throws {
        fistsForPlayerOne = nil
        fistsForPlayerTwo = nil
        fistsForPlayerThree = nil

        noArmorForPlayerOne = nil
        noArmorForPlayerTwo = nil
        noArmorForPlayerThree = nil
        
        playerOne = nil
        playerTwo = nil
        playerThree = nil
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

    func testAddMessage() {
        // Act
        playerOne.wield(weaponObject: fistsForPlayerOne)
        
        // Assert
        let expectedMessageLog: [String] = ["\(playerOne.characterName) is now wielding \(fistsForPlayerOne.name)"]
        // print("This is message log: \(messageLog.getMessageLog())")
        XCTAssertTrue(messageLog.getMessageLog() == expectedMessageLog)
    }
    
    func testMessageLogLength() {
        // Act
        for _ in 1...12 {
            playerOne.wield(weaponObject: fistsForPlayerOne)
        }
        
        // Assert
        XCTAssertTrue(messageLog.getCount() == messageLog.MAX_MESSAGES)
    }
    
    func testMessageLogOrder() {
        // Act
        playerOne.wield(weaponObject: fistsForPlayerOne)
        playerTwo.wear(armorObject: noArmorForPlayerTwo)
        
        // Assert
        let expectedMessageLog = ["\(playerOne.characterName) is now wielding \(fistsForPlayerOne.name)", "\(playerTwo.characterName) is now wearing \(noArmorForPlayerTwo.name)"]
        print("This is messageLog!!: \(messageLog.getMessageLog())")
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    // MARK: - Spells message logging Tests
        
    // TODO: @Kelly add tests for spell casting
    
    // MARK: - Abilities message logging tests
    
    func testSecondWindMessageLog() {
        // Act
        playerOne.secondWind()
        
        // Assert
        let expectedMessageLog = ["\(playerOne.characterName) has gotten a second wind"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
        
    func testActionSurgeMessageLog() {
        // Arrange
        var playerTwoAsRPGCharacter: RPGCharacter = playerTwo!
        
        // Act
        playerOne.actionSurge(target: &playerTwoAsRPGCharacter)
        
        //Assert
        let expectedMessageLog = ["\(playerOne.characterName) has action surged to do double damage against \(playerTwo.characterName)"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    func testSharpenWeaponMessageLog() {
        // Act
        playerOne.sharpenWeapon()
        
        // Assert
        let expectedMessageLog = ["\(playerOne.characterName) is sharpening their weapon"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    func testHoneSkillMessageLog() {
        // Act
        playerThree.honeSkill()
        
        // Assert
        let expectedMessageLog = ["\(playerThree.characterName) is honing their skill"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    func testInsightMessageLog() {
        // Act
        playerThree.insight(target: playerTwo as RPGCharacter)
        
        // Assert
        let expectedMessageLog = ["\(playerThree.characterName) has now gained insight into \(playerTwo.characterName)"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    func testAllSightMessageLog() {
        // Act
        playerThree.allSight()
        
        // Assert
        let expectedMessageLog = ["\(playerThree.characterName) now knows all the opposing team's stats through All Sight"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    // TODO: @Me Add String of all actions
}
