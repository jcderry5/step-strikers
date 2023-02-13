//
//  Game.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/9/23.
//

func rollDie(quant: Int, sides: Int) -> Int {
    var sum = 0
    for _ in 1...quant {
        sum += Int.random(in: 1...sides)
    }
    
    return sum
}

func rollDieDisadvantage(sides: Int) -> Int {
    var firstRoll = rollDie(quant: 1, sides: sides)
    var secondRoll = rollDie(quant: 1, sides: sides)
    return (firstRoll <= secondRoll) ? firstRoll : secondRoll
}
