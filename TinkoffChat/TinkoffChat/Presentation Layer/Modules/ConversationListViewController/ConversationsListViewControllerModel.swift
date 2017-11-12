//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationsListViewControllerModel : class {

}

protocol ConversationsListViewControllerModelDelegate : class {
    func setupDialogs(allDialogs: [ChatDialog])
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    var controller : ConversationsListViewController
    var manager : ConversationListManager?
    init(controller:ConversationsListViewController) {
        self.controller = controller
        //self.manager = ConversationListManager(model: self)
    }
   
}





