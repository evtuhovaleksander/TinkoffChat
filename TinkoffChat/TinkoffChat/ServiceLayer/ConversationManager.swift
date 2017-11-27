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
    var communicationManager : CommunicatorDelegate {get set}
    var delegate:ConversationManagerDelegate? {get set}
    func sendMessage(string: String)
    func updateUnRead()
}

protocol ConversationManagerDelegate{
    func update()
}

class ConversationManager : NSObject, IConversationManager, CommunicationManagerConversationDelegate{
    var fetchedResultsController : NSFetchedResultsController<Message>
    var service : CoreDataService
    var conversation:Conversation
    var communicationManager : CommunicatorDelegate
    var delegate:ConversationManagerDelegate?
    
    
    init(delegate:NSFetchedResultsControllerDelegate,conversation:Conversation) {
        self.service = rootAssembly.coreDataService
        let context = self.service.mainContext
        self.conversation = conversation
        
        let fetchRequest = Message.fetchRequestMessages(context: service.mainContext!, conversation: conversation)
        
        let fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest:
            fetchRequest!, managedObjectContext: context!, sectionNameKeyPath: nil,
                          cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController.delegate = delegate
        
        self.communicationManager = rootAssembly.communicationManager
        
    }
    
    
    
    
    func updateUnRead(){
        guard let messages = self.conversation.messages else{return}
        for item in messages{
            (item as! Message).unread = false;
        }
        
   
       service.doSave(completionHandler: nil)
      
    }
    
    func sendMessage(string: String){
        communicationManager.multipeerCommunicator?.sendMessage(string: string, to: conversation.user?.id ?? "", completionHandler: nil)
    }
    
    func update(){
        delegate?.update()
    }

}


