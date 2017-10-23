//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    //var onlineDialogs : [Dialog]?
    //var offlineDialogs : [Dialog]?
    
    
    var onlineDialogs : [ChatDialog] = [ChatDialog]()
    var offlineDialogs : [ChatDialog] = [ChatDialog]()
    
    
    
    var multiPeerCommunicator : MultipeerCommunicator = MultipeerCommunicator(selfName: "name")
    var communicationManager : CommunicationManager = CommunicationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tinkoff Chat"
        
        multiPeerCommunicator.delegate = communicationManager
        
        getDialogs()
        table.dataSource = self
        table.delegate = self
        table.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogs), name: .refreshDialog, object: nil)
    }
    
    @objc func refreshDialogs(_ notification: NSNotification){
        DispatchQueue.main.async {
            self.getDialogs()
            self.table.reloadData()
        }
    }
    
    func getDialogs(){
        var allDialogs = communicationManager.getChatDialogs()
        
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
        
        performSegue(withIdentifier: "ToMessages", sender: dialog)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToMessages"){
            let navVC = segue.destination as? ConversationViewController
            navVC?.title = (sender as! ChatDialog).name
            navVC?.communicationManager = communicationManager
            navVC?.multipeerCommunicator = multiPeerCommunicator
            navVC?.userName = (sender as! ChatDialog).name
            navVC?.userID = (sender as! ChatDialog).userID
        }
    }
    
//    func getTestData(){
//        var online = [Dialog]()
//        var offline = [Dialog]()
//
//        let date = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 - 99999)
//
//
//        offline.append(Dialog(nameP: "Name1",messageP: "Message from 1",dateP: Date.init(),onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name2",messageP: "Message from 2",dateP: Date.init(),onlineP: false,hasUnread: true))
//        online.append(Dialog(nameP: "Name3",messageP: nil ,dateP: Date.init(),onlineP: true,hasUnread: false))
//        online.append(Dialog(nameP: "Name4",messageP: "Message from 4",dateP: Date.init(),onlineP: true,hasUnread: true))
//        online.append(Dialog(nameP: "Name5",messageP: "Message from 5"             ,dateP: Date.init(),onlineP:  true,hasUnread: false))
//
//        offline.append(Dialog(nameP: "Name6",messageP: "Message from 6",dateP: date,onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name7",messageP: "Message from 7",dateP: date,onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name8",messageP: "Message from 8",dateP: Date.init(),onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name9",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
//
//
//        offline.append(Dialog(nameP: "Name10",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
//        online.append(Dialog(nameP: "Name11",messageP: "Message from 11",dateP: Date.init(),onlineP: true,hasUnread: false))
//        offline.append(Dialog(nameP: "Name12",messageP: "Message from 12",dateP: Date.init(),onlineP: false,hasUnread: true))
//        online.append(Dialog(nameP: "Name13",messageP: "Message from 13",dateP: Date.init(),onlineP: true,hasUnread: true))
//        online.append(Dialog(nameP: "Name14",messageP: "Message from 14",dateP: Date.init(),onlineP: true,hasUnread: false))
//
//        offline.append(Dialog(nameP: "Name15",messageP: "Message from 15",dateP: date,onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name16",messageP: "Message from 16",dateP: date,onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name17",messageP: "Message from 17",dateP: Date.init(),onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name18",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name19",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
//        offline.append(Dialog(nameP: "Name20",messageP: "Message from 20",dateP: Date.init(),onlineP: false,hasUnread: false))
//
//        onlineDialogs = online
//        offlineDialogs = offline
//    }
    
    
}


//class Dialog:ConversationCellConfiguration{
//    init(nameP:String, messageP:String?,dateP:Date,onlineP:Bool,hasUnread:Bool){
//        self.name = nameP
//        self.message = messageP
//        self.date = dateP
//        self.online = onlineP
//        self.hasUnreadMessage = hasUnread
//    }
//
//    var name: String?
//    var message: String?
//    var date: Date?
//    var online: Bool
//    var hasUnreadMessage: Bool
//}

protocol ConversationCellConfiguration : class{
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessage : Bool {get set}
}


