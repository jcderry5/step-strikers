// general RPGCharacter in which all roles will fall under
public class RPGCharacter {
    // stats that is universal for every character
    var name: String
    var armor: Armor
    var weapon: Weapon
    var hasAdvantage: Bool
    var hasDisadvantage: Bool
    
    // default stats that will change dependent on their subclass
    var maxHealth = 0
    var currHealth = 0
    var maxSpellPoints = 0
    var currSpellPoints = 0
    var maxStamina = 0 // TODO: Set the max for each class
    var currStamina = 0
    var validWeapons = [String]()
    var validArmors = [String]()
    
    
    //basic initialization for any RPGCharacter without a specific class
    public init (name: String) {
        self.name = name
        self.armor = Armor(armorType: "none")
        self.weapon = Weapon(weaponType: "none")
        self.hasAdvantage = false
        self.hasDisadvantage = false
    }
    
    // functions for manipulating your current weapon,
    // wielding weapons is possible by all characters
    public func wield(weaponObject: Weapon){
        if(validWeapons.contains(weaponObject.weaponName)){
            weapon = weaponObject
            print("\(name) is now wielding a(n) \(weaponObject.weaponName)")
        } else {
            print("Weapon not allowed for this character class.")
        }
    }
    
    // Changes whatever weapon you were weilding to none
    public func unwield(){
        weapon = Weapon(weaponType: "none")
        print("\(name) is no longer wielding anything.")
    }
    
    // functions for manipulating your current armor
    public func putOnArmor(armorObject: Armor) {
        if(validArmors.contains(armorObject.armorName)){
            armor = armorObject
            print("\(name) is now wearing \(armorObject.armorName)")
        }
    }
    
    public func takeOfArmor(){
        armor = Armor(armorType: "none")
        print("\(name) is no longer wearing anything.")
    }
    
    // functions for battle
    
    // fighting will adjust the health of your opponent after
    // attacking with your current weapon
    public func fight(opponent: RPGCharacter){
        print( "\(name) attacks \(opponent.name) with a(n) \(weapon.weaponName)")
        // the opponent will deduct from their health using the amt of damage MY weapon wields
        opponent.adjustHealth(adjustment: weapon.weaponDamage)
        print("\(name) does \(weapon.weaponDamage) damage to \(opponent.name)")
        print("\(opponent.name) is now down to \(opponent.currHealth) health")
        checkForDefeat(character: opponent)
    }
    
    // Adjusts health. Your health can go sub-zero but not above maxHealth
    public func adjustHealth(adjustment: Int) {
        currHealth -= adjustment
        
        // if over max, make max. else, keep same
        currHealth = (currHealth > maxHealth) ? maxHealth : currHealth
    }
    
    public func adjustStamina(adjustment: Int) {
        currStamina -= adjustment
        
        // they can be over max and under max
    }
    
    // general check methods, prints stats of curr character
    public func show(){
        print(name)
        print("\tCurrent Health: \(currHealth)")
        print("\tCurrent Spell Points: \(currSpellPoints)")
        print("\tWielding: \(weapon.weaponName)")
        print("\tWearing: \(armor.armorName)")
        print("\tArmor Class: \(armor.armorAC)")
    }
    
    // Called after every fight move. Defeated if you have <= 0 currHealth
    // NOTE: This does not end the fight nor the program.
    public func checkForDefeat(character: RPGCharacter) {
        if(character.currHealth <= 0){
            print("\(character.name) has been defeated!")
        }
    }
    
}



// subclass of RPGCharacter called Fighter
public class Fighter: RPGCharacter {
    // initializing it as an RPGCharacter
    public override init(name: String){
        super.init(name: name)
        
        //overriding generic character stats with those specific for Fighter
        maxHealth = 40
        currHealth = 40
        maxSpellPoints = 0
        currSpellPoints = 0
        validWeapons = ["dagger", "axe", "staff", "sword", "none"]
        validArmors = ["plate", "chain", "leather", "none"]
    }
}

