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
    var manager : IConversationListManager {get set}
    var delegate: ConversationsListViewControllerModelDelegate {get set}
}

protocol ConversationsListViewControllerModelDelegate : NSFetchedResultsControllerDelegate {
    //
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    var manager: IConversationListManager
    var delegate: ConversationsListViewControllerModelDelegate
    init(delegate: ConversationsListViewControllerModelDelegate) {
        self.delegate = delegate
        manager = ConversationListManager(delegate:delegate)
    }
    

   
}





