//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    
    var messages:[ChatMessage] = [ChatMessage]()
    var communicationManager:CommunicationManager?
    var multipeerCommunicator:MultipeerCommunicator?
    var userName:String?
    var userID:String?
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messages = communicationManager!.getDialogMessages(userName: userName!)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDialog), name: .refreshDialog, object: nil)


    }
    @objc func refreshDialog(_ notification: NSNotification){
        let dialog = communicationManager!.getChatDialog(userName: userName!)
        self.messages = dialog.messages
        sendButton.isEnabled = dialog.online
        self.table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if(message.income){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.text
            return cell
        }
        
    }
    
    @IBAction func send(_ sender: Any) {
    }
    

}

//class Message : MessageCellConfiguration{
//    var messageText: String?
//    var income: Bool
//    
//    init(message:String?,incomeP:Bool){
//        self.messageText = message
//        self.income = incomeP
//    }
//}
//
//protocol MessageCellConfiguration : class {
//    var messageText : String? {get set}
//}

