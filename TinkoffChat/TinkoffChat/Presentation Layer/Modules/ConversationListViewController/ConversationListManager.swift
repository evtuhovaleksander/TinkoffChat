//
//  ConversationListManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 12/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData


class ConversationListManager : NSObject{
    let fetchedResultsController: NSFetchedResultsController<Conversation>
    let model: ConversationsListViewControllerModel
    let service = rootAssembly.coreDataService
    
    var tableView:UITableView{
        get{
            return model.controller.table
        }
    }
    
    init(model: ConversationsListViewControllerModel) {
        self.model = model
        let context = service.mainContext
        
        //вынести
        
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let descriptors = [NSSortDescriptor(key: "id",
                             ascending: false)]
        fetchRequest.sortDescriptors = descriptors
        fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: context!, sectionNameKeyPath: #keyPath(Conversation.user.online),
                          cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        
    }
}

extension ConversationListManager:NSFetchedResultsControllerDelegate{
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
  
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: IndexPath?,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: (sectionIndex?.section)!),
                                     with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: (sectionIndex?.section)!),
                                     with: .automatic)
        case .move, .update: break
        }
    }
}


