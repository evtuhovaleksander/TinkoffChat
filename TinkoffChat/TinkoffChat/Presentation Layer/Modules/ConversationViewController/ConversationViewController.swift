//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ConversationViewControllerModelDelegate{

    var model:IConversationViewControllerModel?
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = model?.userName
        self.table.register(UINib.init(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib.init(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model?.startSync()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model?.updateUnRead()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let message = model?.messageForIndexPath(indexPath: indexPath){
        
        if(message.income){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
            }
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            return cell
        }
        
    }
    
    @IBAction func send(_ sender: Any) {
        model?.sendMessage(string: messageText.text ?? "")
    }
    
    var i = 0
    @IBAction func add(_ sender: Any) {
        let cont = rootAssembly.coreDataService.saveContext
        i+=1
        let str = String(i)
        
        var income = false
        
        if(Int(arc4random_uniform(10))>5){
            income = true
        }
        
        let _ = Message.insertMessage(in: cont!, conversation: (model?.conversation)!, text: str, income: income, id: jsonManager.generateMessageID(), date: Date(),unread: true)
        
        rootAssembly.coreDataService.doSave(completionHandler: nil)
    }
    
    
    @IBAction func del(_ sender: Any) {
        var convs = rootAssembly.coreDataService.findMessages()
        for i in convs!{
            rootAssembly.coreDataService.mainContext?.delete(i)
        }
        
        do {
            try rootAssembly.coreDataService.doSave(completionHandler: nil)
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
        
    }
    
    func updateOnline(){
       sendButton.isEnabled = model?.conversation.user?.online ?? false
    }
    

    
}

extension ConversationViewController:NSFetchedResultsControllerDelegate{
    
    
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





