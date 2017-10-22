//
//  CommunicationManager.swift
//  ProtoChat
//
//  Created by Aleksander Evtuhov on 22/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class ChatMessage{
    init(text:String,date:Date,income:Bool) {
        self.text = text
        self.date = date
        self.income = income
        self.unRead = true
    }
    var text:String
    var date:Date
    var income:Bool
    var unRead:Bool
    
}

class ChatDialog{
    init(name:String,userID:String){
        self.name = name
        self.userID = userID
        self.online = false
        self.messages = [ChatMessage]()
    }
    
    var name: String?
    var userID: String?
    var online: Bool
    var messages:[ChatMessage]
}

class CommunicationManager: CommunicatorDelegate{
    
    var dialogs: Dictionary<String,ChatDialog> = Dictionary<String,ChatDialog>()
    
    func getDialogByUserID(userID:String)->ChatDialog{
        return getDialog(userID: userID, userName: "")
    }
    
    func getDialog(userID:String, userName:String)->ChatDialog{
        if let dialog = dialogs[userID]{
            return dialog
        }
        
        let dialog = ChatDialog(name:userName,userID:userID)
        dialogs[userID]=dialog
        return dialog
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let dialog = getDialog(userID: userID, userName: userName!)
        print(dialog)
    }
    
    func userDidBecome(userID:String,online:Bool){
        let dialog = getDialogByUserID(userID: userID)
        dialog.online = online
        
        //refresh notification
    }
    
    func didLostUser(userID: String) {
        return
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        return
    }
    
    func failedToStartAdvertising(error: Error) {
        return
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        let message = ChatMessage(text: text,date: Date(),income: false)
        
        let dialog:ChatDialog
        
        if(toUser == "me"){
            message.income = true
            dialog = getDialogByUserID(userID: fromUser)
        }else{
            message.income = false
            dialog = getDialogByUserID(userID: toUser)
        }
        
        dialog.messages.append(message)
        
        //send refresh notification
    }
    
    
    

    
}
