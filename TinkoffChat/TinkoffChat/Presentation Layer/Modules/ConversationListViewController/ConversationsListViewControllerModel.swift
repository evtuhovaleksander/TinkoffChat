//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

protocol IConversationsListViewControllerModel : class {
    var communicationManager : CommunicationManager {get set}
    var delegate : IConversationsListViewControllerModelDelegate? {get set}
    func getDialogs()
}

protocol IConversationsListViewControllerModelDelegate : class {
    func setupDialogs(allDialogs: [ChatDialog])
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    var communicationManager : CommunicationManager
    var delegate : IConversationsListViewControllerModelDelegate?
    
    init() {
        self.communicationManager = rootAssembly.communicationManager
    }
    
    func getDialogs() {
        delegate?.setupDialogs(allDialogs:communicationManager.getChatDialogs())
    }  
}



