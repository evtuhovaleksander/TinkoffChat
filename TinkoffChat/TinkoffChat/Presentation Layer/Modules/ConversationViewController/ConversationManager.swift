//
//  ConversationManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 12/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

//
//  ConversationListManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 12/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationManager {
    var fetchedResultsController : NSFetchedResultsController<Message> {get set}
}

protocol ConversationManagerDelegate{
    
}

class ConversationManager : NSObject, IConversationManager{
    var fetchedResultsController : NSFetchedResultsController<Message>
    
    init(delegate:NSFetchedResultsControllerDelegate,conversation:Conversation) {
        let context = rootAssembly.coreDataService.mainContext
        
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        
        let predicate = NSPredicate(format: "conversation == %@", conversation)
        fetchRequest.predicate = predicate
        
        let descriptors = [NSSortDescriptor(key: "date",
                                            ascending: false)]
        fetchRequest.sortDescriptors = descriptors
        
        var fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil,
                          cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = delegate
    }
}


