//
//  CommunicationManager.swift
//  ProtoChat
//
//  Created by Aleksander Evtuhov on 22/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import MultipeerConnectivity





protocol CommunicationManagerConversationListDelegate{
    func update()
}

protocol CommunicationManagerConversationDelegate{
    func update()
}




class CommunicationManager: CommunicatorDelegate{
    
    var dialogs: Dictionary<String,ChatDialog> = Dictionary<String,ChatDialog>()
    
    
    var convListDelegate:CommunicationManagerConversationListDelegate?
    var convDelegate:CommunicationManagerConversationDelegate?
    
    var multipeerCommunicator:MultipeerCommunicator
    
    init(multipeerCommunicator:MultipeerCommunicator) {
        self.multipeerCommunicator = multipeerCommunicator
    }
    
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
        let dialog = getDialog(userID: userID, userName: userName ?? "userName")
        print(dialog)
    }
    
    func userDidBecome(userID:String,online:Bool){
        let dialog = getDialogByUserID(userID: userID)
        dialog.online = online
        dialogs[userID] = dialog
        convDelegate?.update()
        convListDelegate?.update()
        //NotificationCenter.default.post(name: .refreshDialog, object: nil)
        //NotificationCenter.default.post(name: .refreshDialogs, object: nil)
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
        
        var user = ""
        if(toUser == "me"){
            message.income = true
            dialog = getDialogByUserID(userID: fromUser)
            user = fromUser
        }else{
            message.income = false
            dialog = getDialogByUserID(userID: toUser)
            user = toUser
        }
        
        dialog.messages.append(message)
        dialog.messages.sort{ $0.date < $1.date }
        dialogs[user]=dialog
        convDelegate?.update()
        convListDelegate?.update()
        //NotificationCenter.default.post(name: .refreshDialog, object: nil)
        //NotificationCenter.default.post(name: .refreshDialogs, object: nil)
    }
    
    func getDialogMessages(userName:String)->[ChatMessage]{
        for item in dialogs{
           if item.value.name == userName{
                return item.value.messages
            }
        }
        
        return [ChatMessage]()
        
    }
    
    func getChatDialog(userName:String)->ChatDialog{
        
        for item in dialogs{
            if item.value.name == userName{
                return item.value
            }
        }
        
        return ChatDialog(name:"", userID: "")
        
    }
    
    func getChatDialog(userID:String)->ChatDialog{
        
        return dialogs[userID] ?? ChatDialog(name: "", userID: userID)
        
    }
    
    func getChatDialogs()->[ChatDialog]{
        var array = [ChatDialog]()
        for item in dialogs{
            array.append(item.value)
        }
        return array
    }
    
    func updateUnread(userID:String){
        let dialog = dialogs[userID]
        for message in (dialog ?? ChatDialog(name: "", userID: userID)).messages{
            message.unRead = false
        }
        dialogs[userID]=dialog
    }
    

    
}
