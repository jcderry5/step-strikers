// All possible Spells

public class Spell {
    var casters: [Caster]
    var hpEffect: Int
    var staminaEffect: Int
    var armorEffect: Int
    
    init() {
        casters = [Wizard.self, Bard.self]
        hpEffect = 0
        staminaEffect = 0
        armorEffect = 0
    }
}

public class Frostbite: Spell {
    public override init() {
        super.init()
        
        casters = [Wizard.self]
        hpEffect = 6 // ROLL D6
        staminaEffect = 1;
    }
    
    public func cast(caster: Wizard, target: RPGCharacter) {
        // Give target d6 damage
        target.adjustHealth(adjustment: rollDie(quant: 1, sides: 6))
        caster.adjustStamina(staminaEffect)
    }
}

// TODO: Implment once inventory is implemented
public class MageHand: Spell {
    public override init() {
        super.init()
        
        casters = [Caster.self]
        staminaEffect = 5
    }
    
//    public override cast(caster: RPGCharacter, target: RPGCharacter, recipient: RPGCharacter){
//        // TODO: display targets
//        // let desiredWeapon =
//        recipient.armor
    
    // caster.adjustStamina(staminaEffect)
//    }
}

public class Shield: Spell {
    public override init() {
        super.init()
        
        casters = [Wizard.self]
        staminaEffect = 5
        armorEffect = 5
    }
    
    public func cast(caster: Wizard, target: RPGCharacter){
        // TODO: add to armor && adjust stamina
    }
}

public class BardicInspiration: Spell {
    public override init() {
        super.init()
        
        casters = [Bard.self]
        staminaEffect = 5
    }
    
    public func cast (caster: Bard, target: RPGCharacter){
        target.hasAdvantage = true // TODO: make this a function or smth
        caster.adjustStamina(5)
    }
}

public class ViciousMockery: Spell {
    public override init() {
        super.init()
        
        casters = [Bard.self]
        staminaEffect = 5
    }
    
    
    public func cast(caster: Bard, target: RPGCharacter){
        if target is Fighter {
            print("You can't sway the confidence of a fighter.")
        } else {
            target.hasDisadvantage = true
        }
        
        caster.adjustStamina(adjustment: staminaEffect)
    }
    
    
}

public class Blindness: Spell {
    public override init() {
        super.init()
        
        casters = [Bard.self]
        staminaEffect = 10
    }
}
