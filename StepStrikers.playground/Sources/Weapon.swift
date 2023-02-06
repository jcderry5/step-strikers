// This is a basic Weapon's class that holds the functionality of all weapons
// Initializations should only be of weapons contains in weaponInfo
public class Weapon {
    let weaponName: String
    let weaponDamage: Int
    let weaponInfo = [
        (nameOfWeapon: "dagger", assocDamage: 4),
        (nameOfWeapon: "axe", assocDamage: 6),
        (nameOfWeapon: "staff", assocDamage: 6),
        (nameOfWeapon: "sword", assocDamage: 10),
        (nameOfWeapon: "none", assocDamage: 1)
    ]
    
    public init(weaponType: String){
        weaponName = weaponType
        
        for currWeapon in weaponInfo {
            if currWeapon.nameOfWeapon == weaponType {
                weaponDamage = currWeapon.assocDamage
                return
            }
        }
        // if you get here, you tried to init a weapon not in inventory
        print("\(weaponType) is not a valid weapon. Giving default damange of 1.")
        weaponDamage = 1
    }
   
}
