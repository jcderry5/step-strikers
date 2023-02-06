public class Game {

    var order: [(playerName: RPGCharacter, initiativeOrder: Int)]
    var blueTeam: [RPGCharacter]
    var redTeam: [RPGCharacter]
    var areBlind: [RPGCharacter]
    var areInvisisble: [RPGCharacter]
    var areSleep : [RPGCharacter]

                    
    public init(blueTeam: [RPGCharacter], redTeam: [RPGCharacter]){
        print("Setting teams")
        setTeams(blueTeam: blueTeam, redTeam: redTeam)
        print("Setting order")
        setOrder(blueTeam: blueTeam, redTeam: redTeam)
    }
    
    
    private func setTeams(blueTeam: [RPGCharacter], redTeam: [RPGCharacter]) {
        self.blueTeam = blueTeam
        self.redTeam = redTeam
    }
    
    private func setOrder(blueTeam: [RPGCharacter], redTeam: [RPGCharacter]){
        // everyone roll die
        // blue team rolls first
        for character in blueTeam {
            var initiative = rollDie(quant: 1, sides: 20)
            print("\(character.name) rolles a \(initiative) in the initiative order")
            order.append((playerName: character, initiativeOrder: initiative))
        }
        order = order.sorted(by: {$0.initiativeOrder > $1.initiativeOrder} -> Bool)
    }
    
    public func peekNextInInitiative() -> RPGCharacter {
        var curr:Int = 0
        // skip over them when seeing next player in initiative order
        while(areSleep.contains(order[curr].playerName)){
            curr += 1
        }
        return order[curr].playerName
    }
    
    public func viewInitiativeOrder() {
        print(order)
    }
    
    public func nextInInitiative() -> RPGCharacter {
        let nextPlayer = peekNextInInitiative()
        var currPlayer = order.removeFirst()
        // this will skip over all players that are sleep, put them in back of list, and remove them from sleep list
        while (currPlayer.playerName.name != nextPlayer.playerName.name){
            order.append(currPlayer)
            areSleep.remove(areSleep.index(of: currPlayer.playerName))
            currPlayer = order.removeFirst()
        }
        order.append(currPlayer) // add them to the end of the order
    }
    
    
    
}
