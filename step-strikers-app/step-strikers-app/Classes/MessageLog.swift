//
//  MessageLog.swift
//  step-strikers-app
//
//  Created by Jalyn Derry on 2/28/23.
//

import Foundation

class MessageLog {
    var messageLogs: [String] = []
    let MAX_MESSAGES: Int = 10
    
    func addToMessageLog(message: String) {
        if(messageLogs.count >= MAX_MESSAGES){
            messageLogs.remove(at: 0)
        }
        messageLogs.append(message)
    }
    
    func printMessageLog() {
        print(messageLogs)
    }
    
    func getMessageLog() -> [String] {
        let dummyMessageLog = messageLogs
        return dummyMessageLog
    }
    
    func putMessagesOnFirebase() {
        // TODO: @Kelly Complete this function
    }
}
