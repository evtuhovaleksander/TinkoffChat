//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CommunicationManagerConversationListDelegate {
    
    func update() {
        DispatchQueue.main.async {
            //self.model.getDialogs()
            //self.table.reloadData()
        }
    }
    
    @IBOutlet weak var table: UITableView!
    var fetchedResultsController:NSFetchedResultsController<Conversation>?
    //var onlineDialogs : [ChatDialog] = [ChatDialog]()
    //var offlineDialogs : [ChatDialog] = [ChatDialog]()
    var model : IConversationsListViewControllerModel?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        self.table.register(UINib.init(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier:"DialogCell" )
        super.viewDidLoad()
        self.title = "Tinkoff Chat"
        table.dataSource = self
        table.delegate = self
        table.reloadData()
        //model.getDialogs()
        //NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogs), name: .refreshDialogs, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
        //table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let frc = fetchedResultsController, let sectionsCount =
            frc.sections?.count else {
                return 0
        }
        return sectionsCount
//        if sectionsCount>0{
//            var a = frc.sections?[0].indexTitle
//            var b = frc.sections?[0].name
//            print(b)
//        }
//        if sectionsCount>1{
//            var c = frc.sections?[1].indexTitle
//            var d = frc.sections?[1].name
//       print(d)
//        }
//
//        return sectionsCount
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = fetchedResultsController, let sections = frc.sections else {
            return 0
        }
        if sections.count == 0 {return 0}
        
        var online = 0
        var offline = 0
        
        for section in sections{
            if section.name == "1" {
                online = section.numberOfObjects
                
            }else{
                offline = section.numberOfObjects
            }
        }
        
        if section == 0{
            return online
        }else{
            return offline
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogCell
        if let conversation = fetchedResultsController?.object(at: indexPath) {

            cell.name = conversation.user?.name ?? ""
            if let messages = conversation.messages{
                cell.message = (messages.array.last as? Message)?.text
                cell.date = (messages.array.last as? Message)?.date
            }else{
                cell.message = nil
                cell.date = nil
            }

            
            var hasUnread = false
            if let messages = conversation.messages?.array{
                for message in messages{
                    if (message as? Message)?.unread ?? false{
                        hasUnread = true
                        break
                    }
                }
            }

                    cell.hasUnreadMessage = hasUnread
                    cell.online = conversation.user?.online ?? false
                    cell.setupUI()
                    return cell
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "online"
        }else{
            return "offline"
        }
    }


    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

  
    
    @IBAction func toProfile(_ sender: Any) {
        self.present(ProfileViewControllerAssembler.createProfileViewControllerAssembler(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        var dialog:ChatDialog
        //        if(indexPath.section == 0){
        //            dialog = onlineDialogs[indexPath.row]
        //        }else{
        //            dialog = offlineDialogs[indexPath.row]
        //        }
        //
        //        let controller = ConversationViewControllerAsembler.createConversationsViewController(userName: dialog.name!, userID: dialog.userID!)
        //
        //        self.navigationController?.pushViewController(controller, animated: true)
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func act(_ sender: Any) {
        let cont = rootAssembly.coreDataService.mainContext
        let str = String(Int(arc4random_uniform(9999)))
        
        var online = false
        
        if(Int(arc4random_uniform(10))>5){
            online = true
        }
        
        let _ = Conversation.insertConversation(in: cont!, id: str, name: str, online: online)
        rootAssembly.coreDataService.doSave(completionHandler: nil)
    }
    
    @IBAction func del(_ sender: Any) {
        
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
        
        var convs = rootAssembly.coreDataService.findConversations()
        for i in convs!{
            rootAssembly.coreDataService.mainContext?.delete(i)
        }
        
//        managedContext.delete(note)
//
        do {
            try rootAssembly.coreDataService.doSave(completionHandler: nil)
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }

}


extension ConversationsListViewController:NSFetchedResultsControllerDelegate{
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //table.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //table.beginUpdates()
    }
    

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                table.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                table.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                table.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch (type) {
        case .insert:
            table.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            table.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
        
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .delete:
//            table.deleteSections(IndexSet(integer: (sectionIndex)), with: .automatic)
//
//            
//        case .insert:
//            table.insertSections(IndexSet(integer: (sectionIndex)), with: .automatic)
//            
//        case .update:
//            break
//            
//        case .move:
//            break
//        }
//    }
    
//    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                            didChange sectionInfo: NSFetchedResultsSectionInfo,
//                            atSectionIndex sectionIndex: IndexPath?,
//                            for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .delete:
//            table.deleteSections(IndexSet(integer: (sectionIndex?.section)!),
//                                     with: .automatic)
//
//
//        case .insert:
//            table.insertSections(IndexSet(integer: (sectionIndex?.section)!),
//                                     with: .automatic)
//
//        case .update:
//            break
//
//        case .move:
//           break
//    }
}
}





