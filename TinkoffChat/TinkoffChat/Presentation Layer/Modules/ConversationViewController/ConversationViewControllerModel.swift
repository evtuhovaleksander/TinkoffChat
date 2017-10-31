//
//  ConversationViewControllerModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

protocol ConversationViewControllerModelDelegate{
    func setupDialog(dialog:ChatDialog)
}

protocol IConversationViewControllerModel{
    var communicationManager:CommunicatorDelegate {get set}
    var userName:String {get set}
    var userID:String {get set}
    var delegate:ConversationViewControllerModelDelegate? {get set}
    
    func getDialog()
    func updateUnread()
    func sendMessage(string: String, to: String)
}

class ConversationViewControllerModel:IConversationViewControllerModel{
    
    var communicationManager:CommunicatorDelegate
    var userName:String
    var userID:String
    var delegate:ConversationViewControllerModelDelegate?
    
    init(userName:String,userID:String,communicationManager:CommunicatorDelegate) {
        self.userID=userID
        self.userName=userName
        self.communicationManager = communicationManager
    }
    
    func getDialog(){
        let dialog = communicationManager.getChatDialog(userID: userID)
        delegate?.setupDialog(dialog: dialog)
    }
    
    func updateUnread(){
        communicationManager.updateUnread(userID: userID)
    }
    
    func sendMessage(string: String, to: String){
        communicationManager.multipeerCommunicator.sendMessage(string: string, to: to, completionHandler: nil)
    }
    
    
}

