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
    
    var service: CoreDataService
    
    var convListDelegate:CommunicationManagerConversationListDelegate?
    var convDelegate:CommunicationManagerConversationDelegate?
    
    var multipeerCommunicator:MultipeerCommunicator?
    
    init(multipeerCommunicator:MultipeerCommunicator,service:CoreDataService) {
        self.multipeerCommunicator = multipeerCommunicator
        self.service = service

    }
    

    
    func didFoundUser(userID: String, userName: String?) {
        
        if let conversation = service.findConversation(id: userID){
            
        }else{
            let _ = Conversation.insertConversation(in: service.saveContext!, id: userID, name: userName ?? "", online: false)
            service.doSave(completionHandler: nil)
        }
        
        
    }
    
    func userDidBecome(userID:String,online:Bool){
        if let conversation = service.findConversation(id: userID){
            conversation.user?.online = online
            service.doSave(completionHandler: nil)
        }
        convDelegate?.update()
        convListDelegate?.update()
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
        
        let conversation:Conversation?
        var income = false
        var user = ""
        if(toUser == "me"){
            income = true
            conversation = service.findConversation(id: fromUser)
            user = fromUser
        }else{
            income = false
            conversation = service.findConversation(id: toUser)
            user = toUser
        }
        
        let _ = Message.insertMessage(in: service.saveContext!, conversation: conversation!, text: text, income: income, id: jsonManager.generateMessageID(), date: Date(), unread: true)
        
        service.doSave(completionHandler: nil)
        convDelegate?.update()
        convListDelegate?.update()
    }


    

    
}
