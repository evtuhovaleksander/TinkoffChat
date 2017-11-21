//
//  ConversationListManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 12/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationListManager {
    var fetchedResultsController : NSFetchedResultsController<Conversation> {get set}
}

protocol ConversationListManagerDelegate{
    
}

class ConversationListManager : NSObject, IConversationListManager{
    var fetchedResultsController : NSFetchedResultsController<Conversation>
    
    init(delegate:NSFetchedResultsControllerDelegate) {
        let context = rootAssembly.coreDataService.mainContext
        
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let descriptors = [NSSortDescriptor(key: "user.online",
                                            ascending: false)]
        fetchRequest.sortDescriptors = descriptors
        let fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: #keyPath(Conversation.user.online),
                          cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = delegate
    }
}


