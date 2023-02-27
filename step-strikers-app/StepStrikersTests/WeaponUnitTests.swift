//
//  WeaponUnitTests.swift
//  StepStrikersTests
//
//  Created by Jalyn Derry on 2/24/23.
//

import XCTest
@testable import step_strikers_app

final class WeaponUnitTests: XCTestCase {

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
        let battleAxe = battleAxe()
        
        let playerOneProficiency = battleAxe.checkIfProficient(wielderClass: playerOne.getCharacterClass())
        let playerTwoProficiency = battleAxe.checkIfProficient(wielderClass: playerTwo.getCharacterClass())
        
        XCTAssertTrue(playerOneProficiency == true)
        XCTAssertTrue(playerTwoProficiency == false)
    }
    
    func testInitialization() {
        // Arrange
        let newCrossBow = crossBow()
        let usedCrossBow = crossBow(useCount: 12)
        
        // Assert
        XCTAssertTrue(newCrossBow.useCount == 0)
        XCTAssertTrue(newCrossBow.condition == 4)
        XCTAssertTrue(usedCrossBow.useCount == 12)
        XCTAssertTrue(usedCrossBow.condition == 2)
    }
    
    func testAdjustWeaponConditionFists(){
        // Act - PlayerOne's current weapon is set to Fists
        let currWeapon = adjustWeaponCondition(ownerWeaponsInventory: &playerOne.weaponsInInventory, currWeaponPointer: &playerOne.currWeapon)
        
        // Assert
        XCTAssertTrue(currWeapon.name == playerOne.currWeapon.name)
    }

    func testAdjustingWeaponCondition() {
        // Arrange
        var battleAxe = battleAxe() as Weapon
        let fists = fists()
        var weaponInventory: [Weapon] = [fists, battleAxe]
        
        // Act - Get to Good Condition
        for _ in 1...5 {
            battleAxe = adjustWeaponCondition(ownerWeaponsInventory: &weaponInventory, currWeaponPointer: &battleAxe)
        }
        
        // Assert
        XCTAssertTrue(battleAxe.useCount == 5)
        XCTAssertTrue(battleAxe.condition == 3)
        
        // Act - Get to Fair Condition
        for _ in 1...5 {
            battleAxe = adjustWeaponCondition(ownerWeaponsInventory: &weaponInventory, currWeaponPointer: &battleAxe)
        }
        
        // Assert = Get to Poor Condition
        XCTAssertTrue(battleAxe.useCount == 10)
        XCTAssertTrue(battleAxe.condition == 2)
        
        // Act
        for _ in 1...5 {
            battleAxe = adjustWeaponCondition(ownerWeaponsInventory: &weaponInventory, currWeaponPointer: &battleAxe)
        }
        
        // Assert
        XCTAssertTrue(battleAxe.useCount == 15)
        XCTAssertTrue(battleAxe.condition == 1)
    }
    
    func testAdjustWeaponConditionMax() {
        // Arrange
        var myWeapon = battleAxe() as Weapon
        let fists = fists()
        var weaponInventory: [Weapon] = [fists, myWeapon]
        
        // Act
        for _ in 1...20 {
            myWeapon = adjustWeaponCondition(ownerWeaponsInventory: &weaponInventory, currWeaponPointer: &myWeapon)
        }
        
        // Assert
        XCTAssertTrue(myWeapon.name == fists.name)
    }
    
    func testDestroyWeapon() {
        // Arrange
        var battleAxe = battleAxe() as Weapon
        battleAxe.useCount = 20
        let fists = fists()
        var weaponInventory: [Weapon] = [fists, battleAxe]
        
        // Act
        let newCurrWeapon = destroyWeapon(ownerWeaponsInventory: &weaponInventory, weaponToDestroy: battleAxe)
        
        // Assert
        XCTAssertTrue(newCurrWeapon.name == fists.name)
        XCTAssertTrue(!weaponInventory.contains(where: { weapon in weapon.name == battleAxe.name }))
        XCTAssertTrue(weaponInventory.count == 1)
    }
    
    func testDestroyWeaponNoFists() {
        // Arrange
        var battleAxe = battleAxe() as Weapon
        battleAxe.useCount = 20
        var weaponInventory: [Weapon] = [battleAxe]
        
        // Act
        let newCurrWeapon = destroyWeapon(ownerWeaponsInventory: &weaponInventory, weaponToDestroy: battleAxe)
        
        // Assert
        XCTAssertTrue(newCurrWeapon.name == "Fists")
        XCTAssertTrue(!weaponInventory.contains(where: { weapon in weapon.name == battleAxe.name }))
        XCTAssertTrue(weaponInventory.count == 1)
        XCTAssertTrue(weaponInventory[0].name == newCurrWeapon.name)
    }
}
