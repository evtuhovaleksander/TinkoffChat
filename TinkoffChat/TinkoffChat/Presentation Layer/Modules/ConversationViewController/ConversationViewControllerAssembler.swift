//
//  ConversationViewControllerAssembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ConversationViewControllerAsembler{
    static func createConversationsViewController(userName:String,userID:String)->ConversationViewController{
        let communicationManager = rootAssembly.communicationManager
        let model = ConversationViewControllerModel(userName:userName,userID:userID,communicationManager:communicationManager)
        let controller = ConversationViewController(model:model)
        model.delegate = controller
        communicationManager.convDelegate = controller
        return controller
    }
}
