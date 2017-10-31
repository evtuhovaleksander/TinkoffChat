//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

protocol IConversationsListViewControllerModel : class {
    var communicationManager : CommunicatorDelegate {get set}
    var delegate : ConversationsListViewControllerModelDelegate? {get set}
    func getDialogs()
}

protocol ConversationsListViewControllerModelDelegate : class {
    func setupDialogs(allDialogs: [ChatDialog])
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    var communicationManager : CommunicatorDelegate
    var delegate : ConversationsListViewControllerModelDelegate?
    
    init() {
        self.communicationManager = rootAssembly.communicationManager
    }
    
    func getDialogs() {
        delegate?.setupDialogs(allDialogs:communicationManager.getChatDialogs())
    }  
}



