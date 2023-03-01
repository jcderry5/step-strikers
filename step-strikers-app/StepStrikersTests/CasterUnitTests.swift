//
//  CasterUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/28/23.
//

import XCTest
@testable import step_strikers_app

final class CasterUnitTests: XCTestCase {

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

    func testSplitObjAndUseCount() {
        // Arrange
        let conjoinedString1: String = "01Fists"
        let conjoinedString2: String = "14Battle Axe"
        let conjoinedString3: String = "00Long Sword"
        
        // Act
        let tuple1 = splitObjAndUseCount(objWithUseCount: conjoinedString1)
        let tuple2 = splitObjAndUseCount(objWithUseCount: conjoinedString2)
        let tuple3 = splitObjAndUseCount(objWithUseCount: conjoinedString3)
        
        // Assert
        XCTAssertTrue(tuple1.useCount == 1)
        XCTAssertTrue(tuple1.objectName == "Fists")
        XCTAssertTrue(tuple2.useCount == 14)
        XCTAssertTrue(tuple2.objectName == "Battle Axe")
        XCTAssertTrue(tuple3.useCount == 0)
        XCTAssertTrue(tuple3.objectName == "Long Sword")
    }
}
