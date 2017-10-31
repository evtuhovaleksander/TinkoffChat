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
       return ConversationViewController(userName:userName,userID:userID,communicationManager:communicationManager)
    }
}
