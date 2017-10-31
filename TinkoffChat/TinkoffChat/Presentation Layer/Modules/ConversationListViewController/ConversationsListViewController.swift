//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ConversationsListViewControllerModelDelegate,CommunicationManagerConversationListDelegate {
    
    func update() {
        DispatchQueue.main.async {
            self.model.getDialogs()
            self.table.reloadData()
        }
    }
    
    @IBOutlet weak var table: UITableView!
    
    var onlineDialogs : [ChatDialog] = [ChatDialog]()
    var offlineDialogs : [ChatDialog] = [ChatDialog]()
    var model : IConversationsListViewControllerModel

    init(model: IConversationsListViewControllerModel) {
        self.model = model
        self.onlineDialogs = [ChatDialog]()
        self.offlineDialogs = [ChatDialog]()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        self.table.register(UINib.init(nibName: "ConversationsListCell", bundle: nil), forCellReuseIdentifier:"DialogCell" )
        super.viewDidLoad()
        self.title = "Tinkoff Chat"
        table.dataSource = self
        table.delegate = self
        table.reloadData()
        model.getDialogs()
        //NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogs), name: .refreshDialogs, object: nil)

    }
    
    func setupDialogs(allDialogs: [ChatDialog]){
        var onWith = [ChatDialog]()
        var onWithout = [ChatDialog]()
        var offWith = [ChatDialog]()
        var offWithout = [ChatDialog]()
        
        for dialog in allDialogs{
            if(dialog.online){
                if(dialog.messages.count>0){
                    onWith.append(dialog)
                }else{
                    onWithout.append(dialog)
                }
            }else{
                if(dialog.messages.count>0){
                    offWith.append(dialog)
                }else{
                    offWithout.append(dialog)
                }
            }
        }
        
        
        onWith.sort{$0.messages.last!.date < $1.messages.last!.date}
        offWith.sort{$0.messages.last!.date < $1.messages.last!.date}
        
        onWithout.sort{$0.name!<$1.name!}
        offWithout.sort{$0.name!<$1.name!}
        
        self.onlineDialogs = onWith
        self.onlineDialogs.append(contentsOf: onWithout)
        
        self.offlineDialogs = offWith
        self.offlineDialogs.append(contentsOf: offWithout)
        
        self.table.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return onlineDialogs.count
        }
        else{
            return offlineDialogs.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogCell
        let dialog:ChatDialog
        if(indexPath.section == 0){
            dialog = onlineDialogs[indexPath.row]
        }
        else{
            dialog = offlineDialogs[indexPath.row]
        }
        
        cell.name = dialog.name
        
        if(dialog.messages.count>0){
            cell.message = dialog.messages.last?.text
            cell.date = dialog.messages.last?.date
        }else{
            cell.message = nil
            cell.date = nil
        }
        
       var hasUnread = false
        
        for message in dialog.messages{
            if message.unRead{
                hasUnread = true
                break
            }
        }
        
        cell.hasUnreadMessage = hasUnread
        cell.online = dialog.online
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Online"
        }
        else{
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dialog:ChatDialog
        if(indexPath.section == 0){
            dialog = onlineDialogs[indexPath.row]
        }else{
            dialog = offlineDialogs[indexPath.row]
        }
        
        //performSegue(withIdentifier: "ToMessages", sender: dialog)
        let controller = ConversationViewControllerAsembler.createConversationsViewController(userName: dialog.name!, userID: dialog.userID!)
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func toProfile(_ sender: Any) {
        self.present(ProfileViewControllerAssembler.createProfileViewControllerAssembler(), animated: true, completion: nil)
    }
    
}

protocol ConversationCellConfiguration : class{
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessage : Bool {get set}
}


//    func getDialogs1(){
//        var allDialogs = communicationManager.getChatDialogs()
//
//        var onWith = [ChatDialog]()
//        var onWithout = [ChatDialog]()
//        var offWith = [ChatDialog]()
//        var offWithout = [ChatDialog]()
//
//        for dialog in allDialogs{
//            if(dialog.online){
//                if(dialog.messages.count>0){
//                    onWith.append(dialog)
//                }else{
//                    onWithout.append(dialog)
//                }
//            }else{
//                if(dialog.messages.count>0){
//                    offWith.append(dialog)
//                }else{
//                    offWithout.append(dialog)
//                }
//            }
//        }
//
//
//        onWith.sort{$0.messages.last!.date < $1.messages.last!.date}
//        offWith.sort{$0.messages.last!.date < $1.messages.last!.date}
//
//        onWithout.sort{$0.name!<$1.name!}
//        offWithout.sort{$0.name!<$1.name!}
//
//        self.onlineDialogs = onWith
//        self.onlineDialogs.append(contentsOf: onWithout)
//
//        self.offlineDialogs = offWith
//        self.offlineDialogs.append(contentsOf: offWithout)
//
//    }


