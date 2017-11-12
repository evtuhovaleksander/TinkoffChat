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
//        let context = rootAssembly.coreDataService.mainContext
//
//        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
//        let descriptors = [NSSortDescriptor(key: "user.online",
//                                            ascending: false)]
//        fetchRequest.sortDescriptors = descriptors
//        var fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
//            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: #keyPath(Conversation.user.online),
//                          cacheName: nil)
//        viewController.fetchedResultsController = fetchedResultsController
//        viewController.fetchedResultsController?.delegate = viewController

        return viewController
    }
}
