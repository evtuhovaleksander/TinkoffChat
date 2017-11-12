//
//  ConversationViewControllerAssembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ConversationViewControllerAsembler{
    static func createConversationsViewController(conversation:Conversation?)->ConversationViewController{
        
        let controller = ConversationViewController()
        if let conv = conversation{
            let model = ConversationViewControllerModel(delegate: controller,conversation:conv)
            controller.model = model
        }else{
           assert(false)
        }
            return controller
            
        }
}

