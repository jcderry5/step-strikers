// TODO: Add checks at the beginning of each cast to ensure than the caster has the spell points and the stamina to acheive the spell

public class Caster: RPGCharacter {
    
    static func adjustSpellCost(caster: Caster, spellPointAdjustment: Int, staminaAdjustment: Int){
        adjustStamina(caster: caster, adjustment: staminaAdjustment)
        adjustSpellPoints(caster: caster, adjustment: spellPointAdjustment)
    }
    
    static func adjustSpellPoints(caster: Caster, adjustment: Int){
        currSpellPoints -= adjustment
    }
    
    static func adjustStamina(caster: Caster, adjustment: Int){
        currStamina -= adjustment
    }
    
    // Only Wizards can cast Frost Bite
    static func castFrostBite(caster: Wizard, target: RPGCharacter){
        let damage = rollDie(quant: 1,sides: 6)
        
        target.adjustHealth(adjustment: damage)
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 1) // adjustment dependent on what I read from database
    }
    
    // Bost Bard and Wizard can cast magehand
    static func castmageHand(caster: RPGCharacter, target: RPGCharacter, recipient: RPGCharacter) {
        /*
         This would need a call to the inventory of the target character and the recipient character.
         You would display the inventory of target
         You would take in which one they choose
         You would remove this from target inventory and add this to recipient inventory
         */
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 1) // adjustment dependent on what I read from database
    }
    
    // Only Wizards can cast Shield
    static func castShield(caster: Wizard, target: RPGCharacter){
        let addedArmor = rollDie(quant: 1, sides: 6)
        /* Add armor to target which can go over max*/
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 5) // adjustment dependent on what I read from database
    }
    
    // Only bards can cast Bardic Inspiration
    static func castBardicInspiration(caster: Bard, target: RPGCharacter){
        target.hasAdvantage = true
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 5) // adjustment dependent on what I read from database
    }
    
    static func castViciousMockery(caster: Bard, target: RPGCharacter){
        // check to ensure it's not a fighter.
        
        target.hasDisadvantage = true
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 5) // adjustment dependent on what I read from database
    }
    
    static func castBlindness(caster: Bard, target: RPGCharacter){
        // Add the target to the gameStats in areBlind list
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 10) // adjustment dependent on what I read from database
    }
    
    static func castInvisibility(caster: Bard, target: RPGCharacter){
        // add target to the gameStats in areInvisible list
        
        // the effect on the caster
        adjustSpellCost(caster: caster, spellPointAdjustment: <#T##Int#>, staminaAdjustment: 10) // adjustment dependent on what I read from database
    }
}



// subclass of RPGCharacter called Wizard
public class Wizard: Caster {
    let spellInfo = [
        (spellName: "Fireball", cost: 3, effect: 5),
        (spellName: "Lightning Bolt", cost: 10, effect: 10),
        (spellName: "Heal", cost: 6, effect: -6)
    ]
    
    // initializing it as an RPGCharacter
    public override init(name: String){
        super.init(name: name)
        
        //overriding generic character stats with those specific for Wizard
        maxHealth = 16
        currHealth = 16
        maxSpellPoints = 20
        currSpellPoints = 20
        validWeapons = ["dagger", "staff", "none"]
        validArmors = []
    }
    
    // functions specific for spell-casting. Only possible for Wizards
    public func castSpell(spellName: String, target: RPGCharacter){
        // check if valid spell
        for currSpell in spellInfo {
            // within this if-statement, valid spell was called
            if(currSpell.spellName == spellName){
                
                // once a valid spell was confirmed,
                // need to check if caster have sufficient spell points
                if(currSpellPoints < currSpell.cost){
                    print("Insufficient spell points")
                    return
                } else {
                    print("\(name) casts \(spellName) at \(target.name)")
                }
                
                // adjust targets health
                target.adjustHealth(adjustment: currSpell.effect)
                
                // adjust casters spell points
                adjustSpellPoints(adjustment: currSpell.cost)
                
                // Specific output based on if it was heal or damaging spelling
                if(currSpell.spellName == "Heal"){
                    print("\(name) heals \(target.name) for \(abs(currSpell.effect)) health points")
                    print("\(target.name) is now at \(target.currHealth) health.")
                } else {
                    print("\(name) does \(currSpell.effect) damage to \(target.name)")
                    print("\(target.name) is now down to \(target.currHealth) health")
                    checkForDefeat(character: target) // defeat only possible for damage spells
                }
                return
            }
        }
        // if you have gotten here, we did not find the casted spell within spellInfo
        print("Unknown spell name. Spell failed.")
    }
    
    // lowers spell points but cannot go sub-zero
    public func adjustSpellPoints(adjustment: Int){
        currSpellPoints -= adjustment
        currSpellPoints = (currSpellPoints < 0) ? 0 : currSpellPoints
    }
}

public class Bard: Caster {
    // TODO: Fill out class specs
}
