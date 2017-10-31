//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

//import UIKit
//
//class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//
//    
//    
//    var messages:[ChatMessage] = [ChatMessage]()
//    var communicationManager:CommunicationManager?
//    var multipeerCommunicator:MultipeerCommunicator?
//    var userName:String?
//    var userID:String?
//    
//    @IBOutlet weak var table: UITableView!
//    
//    @IBOutlet weak var sendButton: UIButton!
//    
//    @IBOutlet weak var messageText: UITextField!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.table.delegate = self
//        self.table.dataSource = self
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogNot), name: .refreshDialog, object: nil)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //self.messages = communicationManager!.getDialogMessages(userName: userName!)
//        refreshDialog()
//    }
//    
//    func refreshDialog(){
//        DispatchQueue.main.async {
//            let dialog = self.communicationManager!.getChatDialog(userName: self.userName!)
//            self.messages = dialog.messages
//            self.sendButton.isEnabled = dialog.online
//            self.table.reloadData()
//        }
//    }
//    
//    @objc func refreshDialogNot(_ notification: NSNotification){
//        refreshDialog()
//        
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        communicationManager?.updateUnread(userID: userID!)
//        //NotificationCenter.default.post(name: .refreshDialog, object: nil)
//        NotificationCenter.default.post(name: .refreshDialogs, object: nil)
//        
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let message = messages[indexPath.row]
//        
//        if(message.income){
//            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
//            cell.messageText = message.text
//            return cell
//            
//        }else{
//            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! MessageCell
//            cell.messageText = message.text
//            return cell
//        }
//        
//    }
//    
//    @IBAction func send(_ sender: Any) {
//        multipeerCommunicator?.sendMessage(string: messageText.text!, to: userID!, completionHandler: nil)
//    }
//    
//
//}
//
//
//
//protocol MessageCellConfiguration : class {
//    var messageText : String? {get set}
//}
//
