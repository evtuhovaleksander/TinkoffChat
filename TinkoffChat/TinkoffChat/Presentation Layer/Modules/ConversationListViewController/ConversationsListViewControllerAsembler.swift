//
//  ConversationListAsembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewControllerAsembler {
    static func createConversationsListViewController()->ConversationsListViewController{

        let viewController = ConversationsListViewController()
        let model = ConversationsListViewControllerModel(delegate:viewController)
        viewController.model = model


        return viewController
    }
}
