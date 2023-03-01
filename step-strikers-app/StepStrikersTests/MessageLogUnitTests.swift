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
    var noArmorForPlayerOne: Armor!
    var noArmorForPlayerTwo: Armor!
    var playerOne: Fighter!
    var playerTwo: Wizard!
    
    override func setUpWithError() throws {
        fistsForPlayerOne = fists()
        fistsForPlayerTwo = fists()

        noArmorForPlayerOne = noArmor()
        noArmorForPlayerTwo = noArmor()
        
        playerOne = Fighter(characterName: "Roywyn", userName: "jazzyLinkage", health: 30, stamina: 30, currWeapon: fistsForPlayerOne, weaponsInInventory: [fistsForPlayerOne], currArmor: noArmorForPlayerOne, armorInInventory: [noArmorForPlayerOne], itemsInInventory: [])

        playerTwo = Wizard(characterName: "Althea", userName: "kellyTheKicker", health: 30, stamina: 30, spellPoints: 30, currWeapon: fistsForPlayerTwo, weaponsInInventory: [fistsForPlayerTwo], currArmor: noArmorForPlayerTwo, armorInInventory: [noArmorForPlayerTwo], itemsInInventory: [])
    }

    override func tearDownWithError() throws {
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
    
    // MARK: - Testing functionality of MessageList class
    func testAddMessage() {
        // Act
        playerOne.wield(weaponObject: fistsForPlayerOne)
        
        // Assert
        let expectedMessageLog: [String] = ["Roywyn is now wielding Fists"]
        XCTAssertTrue(messageLog.getMessageLog() == expectedMessageLog)
    }

    func messageLogLengthCheck() {
        // Act
        for _ in 1...12 {
            playerOne.wield(weaponObject: fistsForPlayerOne)
        }
        
        // Assert
        XCTAssertTrue(messageLog.getCount() == messageLog.MAX_MESSAGES)
    }
    
    func checkMessageLogOrder() {
        // Act
        playerOne.wield(weaponObject: fistsForPlayerOne)
        playerTwo.wear(armorObject: noArmorForPlayerTwo)
        
        // Assert
        let expectedMessageLog = ["\(playerOne.characterName) is now wielding \(fistsForPlayerOne.name)", "\(playerTwo.characterName) is now wearing \(noArmorForPlayerTwo.name)"]
        XCTAssertTrue(expectedMessageLog == messageLog.getMessageLog())
    }
    
    // MARK: - Spells message logging Tests
    
    // TODO: @Kelly add tests for spell casting
    
    // MARK: - Abilities message logging tests
    
}
