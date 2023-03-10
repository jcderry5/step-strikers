//
//  MessageLog.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/28/23.
//

import Foundation
import FirebaseFirestore

// Order of MessageLog: [index 0: oldest message, ... , index 9: most recent message]
class MessageLog {
    // This is file private so that classes are only messing with global version of their messageLog
    fileprivate var messageLogs: [String] = []
    let MAX_MESSAGES: Int = 10
    
    func addToMessageLog(message: String) {
        if(messageLogs.count >= MAX_MESSAGES){
            messageLogs.remove(at: 0)
        }
        print("Added to messageLog")
        messageLogs.append(message)
        
        // write messages to firebase
        Firestore.firestore().collection("games").document(game).setData(["messages": messageLogs], merge: true)
    }
    
    func getCount() -> Int{
        return messageLogs.count
    }
    
    func getMessageLog() -> [String] {
        // So this way they aren't manipulating messageLogs on their side in any way
        let dummyMessageLog = messageLogs
        return dummyMessageLog
    }
    
    func replaceMessageLog(newMessages:[String]) {
        messageLogs = newMessages
    }
}
