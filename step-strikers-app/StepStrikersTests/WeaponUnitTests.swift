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
    
    func testGetWeaponStrings() {
        // Arrange
        let weaponObjectArray: [Weapon] = [fists(useCount: 0), dagger(useCount: 4), handAxe(useCount: 18)]
        
        // Act
        let weaponStringArray = getWeaponStrings(weapons: weaponObjectArray)
        
        // Assert - Use Counts Convert
        XCTAssertTrue(Int(weaponStringArray[0].prefix(2)) == weaponObjectArray[0].useCount)
        XCTAssertTrue(Int(weaponStringArray[1].prefix(2)) == weaponObjectArray[1].useCount)
        XCTAssertTrue(Int(weaponStringArray[2].prefix(2)) == weaponObjectArray[2].useCount)
        
        // Assert - Object Names Convert
        XCTAssertTrue(weaponStringArray[0].suffix(5) == weaponObjectArray[0].name)
        XCTAssertTrue(weaponStringArray[1].suffix(6) == weaponObjectArray[1].name)
        XCTAssertTrue(weaponStringArray[2].suffix(8) == weaponObjectArray[2].name)
    }
    
    func testGetConstructedName() {
        // Arrange
        let weapon1: Weapon = fists(useCount: 00)
        let weapon2: Weapon = dagger(useCount: 4)
        let weapon3: Weapon = handAxe(useCount: 18)
        
        // Act
        let weapon1Str: String = getConstructedName(weapon: weapon1)
        let weapon2Str: String = getConstructedName(weapon: weapon2)
        let weapon3Str: String = getConstructedName(weapon: weapon3)
        
        // Assert - Use Count
        XCTAssertTrue(Int(weapon1Str.prefix(2)) == weapon1.useCount)
        XCTAssertTrue(Int(weapon2Str.prefix(2)) == weapon2.useCount)
        XCTAssertTrue(Int(weapon3Str.prefix(2)) == weapon3.useCount)
        
        // Assert - Obj Name
        XCTAssertTrue(weapon1Str.suffix(5) == weapon1.name)
        XCTAssertTrue(weapon2Str.suffix(6) == weapon2.name)
        XCTAssertTrue(weapon3Str.suffix(8) == weapon3.name)
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
    
    func testRebuildWeapon() {
        // Act
        let weapon1 = rebuildWeapon(weaponName: "Fists", useCount: 0)
        let weapon2 = rebuildWeapon(weaponName: "Dagger", useCount: 5)
        let weapon3 = rebuildWeapon(weaponName: "Hand Axe", useCount: 18)
        
        // Assert
        XCTAssertTrue(weapon1.name == "Fists")
        XCTAssertTrue(weapon1.useCount == 0)
        XCTAssertTrue(weapon2.name == "Dagger")
        XCTAssertTrue(weapon2.useCount == 5)
        XCTAssertTrue(weapon3.name == "Hand Axe")
        XCTAssertTrue(weapon3.useCount == 18)
    }
    
    func testRebuildWeaponInventory() {
        // Arrange
        let weaponStringArray: [String] = ["00Fists", "05Dagger", "18Hand Axe"]
        
        // Act
        let weaponObjectArray = rebuildWeaponInventory(weaponInventory: weaponStringArray)
        
        // Assert
        XCTAssertTrue(weaponObjectArray[0].name == "Fists")
        XCTAssertTrue(weaponObjectArray[0].useCount == 0)
        XCTAssertTrue(weaponObjectArray[1].name == "Dagger")
        XCTAssertTrue(weaponObjectArray[1].useCount == 5)
        XCTAssertTrue(weaponObjectArray[2].name == "Hand Axe")
        XCTAssertTrue(weaponObjectArray[2].useCount == 18)
    }
    
    func testRebuildWeaponToStore() {
        // Arrange
        let weapon: String = "12Short Sword"
        
        // Act
        let weaponObj: Weapon = rebuildWeaponToStore(currWeapon: weapon)
        
        // Assert
        XCTAssertTrue(weaponObj.name == "Short Sword")
        XCTAssertTrue(weaponObj.useCount == 12)
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
    
    func testRemoveWeaponFromInventory() {
        // Arrange
        let weaponToRemove:Weapon = fists(useCount: 14)
        var weaponInventory: [Weapon] = [fists(useCount: 14), fists(useCount: 19), dagger(useCount: 14), shortSword(useCount: 0), fists(useCount: 14)]
        
        // Act
        removeWeaponFromInventory(weaponToRemove: weaponToRemove, weaponInventory: &weaponInventory)
        
        // Assert
        XCTAssertTrue(weaponInventory.count == 4)
        XCTAssertTrue(weaponInventory[0].name == "Fists")
        XCTAssertTrue(weaponInventory[0].useCount == 19)
        XCTAssertTrue(weaponInventory[1].name == "Dagger")
        XCTAssertTrue(weaponInventory[1].useCount == 14)
        XCTAssertTrue(weaponInventory[2].name == "Short Sword")
        XCTAssertTrue(weaponInventory[2].useCount == 0)
        XCTAssertTrue(weaponInventory[3].name == "Fists")
        XCTAssertTrue(weaponInventory[3].useCount == 14)
    }
}
