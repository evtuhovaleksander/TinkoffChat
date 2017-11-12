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
    
    func numberOfSections() -> Int
    func numberOfRowsInSection (section: Int) -> Int
    func conversationForIndexPath (indexPath: IndexPath) -> Conversation?
    func titleForHeaderInSection (section: Int) -> String?
    func startSync ()
}

protocol ConversationsListViewControllerModelDelegate : NSFetchedResultsControllerDelegate {
}

class Dialog{
    // visual side of conversation
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    
    
    
    var manager: IConversationListManager
    var delegate: ConversationsListViewControllerModelDelegate
    
    var fetchedResultsController : NSFetchedResultsController<Conversation>{
        get{
            return manager.fetchedResultsController
            
        }
    }
    
    init(delegate: ConversationsListViewControllerModelDelegate) {
        self.delegate = delegate
        manager = ConversationListManager(delegate:delegate)
    }
    
    func numberOfSections() -> Int {
        guard  let sectionsCount =
            fetchedResultsController.sections?.count else {
                return 0
        }
        return sectionsCount
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func conversationForIndexPath (indexPath: IndexPath) -> Conversation? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func titleForHeaderInSection (section: Int) -> String? {
        guard  let sections =
            fetchedResultsController.sections else {
                return ""
        }
        
        if (sections[section].name == "1")
        {
            return "online"
        }else{
            return "offline"
        }
    }
    
    func startSync() {
        do {
            try manager.fetchedResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    

   
}





