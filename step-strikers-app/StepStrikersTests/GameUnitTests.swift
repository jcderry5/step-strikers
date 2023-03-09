//
//  GameUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/25/23.
//

import XCTest
@testable import step_strikers_app

final class GameUnitTests: XCTestCase {

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
    
    func testRollDie() {
        // Act
        let rollValue = rollDie(sides: 20)
        
        // Assert
        XCTAssertTrue(rollValue > 0 && rollValue <= 20)
    }
}
