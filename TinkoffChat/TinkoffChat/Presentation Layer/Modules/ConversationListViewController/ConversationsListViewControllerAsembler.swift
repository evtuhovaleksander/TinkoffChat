//
//  ConversationListAsembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ConversationsListViewControllerAsembler {
    static func createConversationsListViewController()->ConversationsListViewController{
        let manager = rootAssembly.communicationManager
        let model = ConversationsListViewControllerModel()
        
        
        
        let viewController = ConversationsListViewController(model: model)
        viewController.model = model as ConversationsListViewControllerModel
        model.delegate = viewController
        
        manager.convListDelegate=viewController
        
        return viewController
    }
}
