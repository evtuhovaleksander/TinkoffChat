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
    
    var onlineDialogs : [Dialog]?
    var offlineDialogs : [Dialog]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tinkoff Chat"
        getTestData()
        table.dataSource = self
        table.delegate = self
        table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return onlineDialogs!.count
        }
        else{
            return offlineDialogs!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: "DialogCell", for: indexPath) as! DialogCell
        let dialog:Dialog
        if(indexPath.section == 0){
            dialog = onlineDialogs![indexPath.row]
        }
        else{
            dialog = offlineDialogs![indexPath.row]
        }
        return dialog.configCell(cell: cell)
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
    
    func getTestData(){
        var online = [Dialog]()
        var offline = [Dialog]()
        
        var date = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 - 99999)
        
        
        offline.append(Dialog(nameP: "Name1",messageP: "Message from 1",dateP: Date.init(),onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name2",messageP: "Message from 2",dateP: Date.init(),onlineP: false,hasUnread: true))
        online.append(Dialog(nameP: "Name3",messageP: nil ,dateP: Date.init(),onlineP: true,hasUnread: false))
        online.append(Dialog(nameP: "Name4",messageP: "Message from 4",dateP: Date.init(),onlineP: true,hasUnread: true))
        online.append(Dialog(nameP: "Name5",messageP: "Message from 5"             ,dateP: Date.init(),onlineP:  true,hasUnread: false))
        
        offline.append(Dialog(nameP: "Name6",messageP: "Message from 6",dateP: date,onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name7",messageP: "Message from 7",dateP: date,onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name8",messageP: "Message from 8",dateP: Date.init(),onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name9",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
        
        
        offline.append(Dialog(nameP: "Name10",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
        online.append(Dialog(nameP: "Name11",messageP: "Message from 11",dateP: Date.init(),onlineP: true,hasUnread: false))
        offline.append(Dialog(nameP: "Name12",messageP: "Message from 12",dateP: Date.init(),onlineP: false,hasUnread: true))
        online.append(Dialog(nameP: "Name13",messageP: "Message from 13",dateP: Date.init(),onlineP: true,hasUnread: true))
        online.append(Dialog(nameP: "Name14",messageP: "Message from 14",dateP: Date.init(),onlineP: true,hasUnread: false))
        
        offline.append(Dialog(nameP: "Name15",messageP: "Message from 15",dateP: date,onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name16",messageP: "Message from 16",dateP: date,onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name17",messageP: "Message from 17",dateP: Date.init(),onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name18",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name19",messageP: nil,dateP: Date.init(),onlineP: false,hasUnread: false))
        offline.append(Dialog(nameP: "Name20",messageP: "Message from 20",dateP: Date.init(),onlineP: false,hasUnread: false))
        
        onlineDialogs = online
        offlineDialogs = offline
    }
}


class Dialog:ConversationCellConfiguration{
    init(nameP:String, messageP:String?,dateP:Date,onlineP:Bool,hasUnread:Bool){
        self.name = nameP
        self.message = messageP
        self.date = dateP
        self.online = onlineP
        self.hasUnreadMessage = hasUnread
    }
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool
    
    func configCell(cell : DialogCell)->DialogCell{
        cell.nameLabel.text = name
        
        if let messageText = message{
            if(hasUnreadMessage){
                cell.messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
                cell.messageLabel.text = messageText
            }else{
                cell.messageLabel.font = UIFont.systemFont(ofSize: 13)
                cell.messageLabel.text = messageText
            }

        }
        else{
            cell.messageLabel.font = UIFont(name: "Kefa", size: 13)
            cell.messageLabel.text = "No messages yet"
        }
        
        
        
        
        if(online){
            cell.onlineMarker.backgroundColor = .green
            cell.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.88, alpha:1.0)
            
        }
        else{
            cell.onlineMarker.backgroundColor = .red
            cell.backgroundColor = .white
        }
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        if(dateFormatter.string(from: date!) != dateFormatter.string(from: Date())){
            dateFormatter.dateFormat = "dd.MMM"
            cell.dateLabel.text = dateFormatter.string(from: date!)
        }
        else{
            dateFormatter.dateFormat = "HH:mm"
            cell.dateLabel.text = dateFormatter.string(from: date!)
        }
        
        cell.avatarImage.image = UIImage(named:"EmptyAvatar")
        
        let roundConstant = cell.onlineMarker.bounds.size.width / 2.0
        cell.avatarImage.layer.cornerRadius = roundConstant
        cell.avatarImage.clipsToBounds = true
        cell.onlineMarker.layer.cornerRadius = roundConstant
        cell.onlineMarker.clipsToBounds = true

        return cell
    }
    
    
}

protocol ConversationCellConfiguration : class{
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessage : Bool {get set}
}


