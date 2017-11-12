//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ConversationsListViewControllerModelDelegate {
    
    @IBOutlet weak var table: UITableView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model?.startSync()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogCell
        if let conversation = model?.conversationForIndexPath(indexPath: indexPath){//let conversation = fetchedResultsController?.object(at: indexPath) {

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
        return model?.titleForHeaderInSection(section: section) ?? ""

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    @IBAction func toProfile(_ sender: Any) {
        self.present(ProfileViewControllerAssembler.createProfileViewControllerAssembler(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var conversation = model?.conversationForIndexPath(indexPath: indexPath)
       let controller = ConversationViewControllerAsembler.createConversationsViewController(conversation: conversation)
        
       self.navigationController?.pushViewController(controller, animated: true)
       tableView.deselectRow(at: indexPath, animated: true)
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
        var convs = rootAssembly.coreDataService.findConversations()
        for i in convs!{
            rootAssembly.coreDataService.mainContext?.delete(i)
        }

        do {
            try rootAssembly.coreDataService.doSave(completionHandler: nil)
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }
}


extension ConversationsListViewController:NSFetchedResultsControllerDelegate{
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        table.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
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
}





