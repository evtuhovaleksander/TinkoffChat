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
    var service : CoreDataService {get set}
    var conversation:Conversation {get set}
    
    func updateUnRead()
}

protocol ConversationManagerDelegate{
    
}

class ConversationManager : NSObject, IConversationManager{
    var fetchedResultsController : NSFetchedResultsController<Message>
    var service : CoreDataService
    var conversation:Conversation
    
    init(delegate:NSFetchedResultsControllerDelegate,conversation:Conversation) {
        self.service = rootAssembly.coreDataService
        let context = self.service.mainContext
        self.conversation = conversation
        
        let fetchRequest = Message.fetchRequestMessages(context: service.mainContext!, conversation: conversation)
        
        var fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest:
            fetchRequest!, managedObjectContext: context!, sectionNameKeyPath: nil,
                          cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = delegate
    }
    
    
    
    
    func updateUnRead(){
        guard let messages = self.conversation.messages else{return}
        for item in messages{
            (item as! Message).unread = false;
        }
        
        do {
            try service.doSave(completionHandler: nil)
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }

}


