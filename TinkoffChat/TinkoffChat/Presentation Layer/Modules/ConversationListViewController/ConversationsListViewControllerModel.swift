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
    var fetchedResultsController : NSFetchedResultsController<Conversation> {get set}
}

protocol ConversationsListViewControllerModelDelegate : NSFetchedResultsControllerDelegate {
    
}

class ConversationsListViewControllerModel:IConversationsListViewControllerModel{
    var fetchedResultsController : NSFetchedResultsController<Conversation>
    
    init(delegate:NSFetchedResultsControllerDelegate) {
        let context = rootAssembly.coreDataService.mainContext
        
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let descriptors = [NSSortDescriptor(key: "user.online",
                                            ascending: false)]
        fetchRequest.sortDescriptors = descriptors
        var fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: #keyPath(Conversation.user.online),
                          cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = delegate
    }

   
}





