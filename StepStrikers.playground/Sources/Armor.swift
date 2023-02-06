// This is a basic Armor class. All functionality that
// pertains to all armors are stored here. Initializations should
// be of armors already in armorInfo or else you get default armorAC
public class Armor {
    let armorName: String
    let armorAC: Int
    let armorInfo = [
        (nameOfArmor: "plate", assocAC: 2),
        (nameOfArmor: "chain", assocAC: 5),
        (nameOfArmor: "leather", assocAC: 8),
        (nameOfArmor: "none", assocAC: 10)
    ]
    
    public init(armorType: String){
        armorName = armorType
        
        // setting AC of this armor
        for currArmor in armorInfo {
            if currArmor.nameOfArmor == armorType {
                armorAC = currArmor.assocAC
                return
            }
        }
        // if you reach here, you inputted an invalid armorType
        print("\(armorType) is not a valid armor. Giving default AC of 10")
        armorAC = 10
    }
}
