//
//  ConversationViewControllerModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

protocol IConversationViewControllerModel : class {
    var manager : IConversationManager {get set}
    var delegate: ConversationViewControllerModelDelegate {get set}
    
    func numberOfRowsInSection (section: Int) -> Int
    func messageForIndexPath (indexPath: IndexPath) -> Message?
    func startSync ()
    func updateUnRead()
    func sendMessage(string: String)
}

protocol ConversationViewControllerModelDelegate : NSFetchedResultsControllerDelegate {
}

class MessageModel{
    // visual side of message
}

class ConversationViewControllerModel:IConversationViewControllerModel{

    var manager: IConversationManager
    var delegate: ConversationViewControllerModelDelegate
    
    var fetchedResultsController : NSFetchedResultsController<Message>{
        get{
            return manager.fetchedResultsController
        }
    }
    
    init(delegate: ConversationViewControllerModelDelegate,conversation:Conversation) {
        self.delegate = delegate
        manager = ConversationManager(delegate:delegate,conversation:conversation)
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func messageForIndexPath (indexPath: IndexPath) -> Message? {
        return fetchedResultsController.object(at: indexPath)
    }
    
   
    func startSync() {
        do {
            try manager.fetchedResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func updateUnRead(){
        
    }
    
    func sendMessage(string: String){
        
    }
    
    
    
    
}
