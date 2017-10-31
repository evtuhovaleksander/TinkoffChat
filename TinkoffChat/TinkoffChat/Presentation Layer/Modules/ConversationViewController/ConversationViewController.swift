//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, ConversationViewControllerModelDelegate,CommunicationManagerConversationDelegate{
    
    func update() {
        model.getDialog()
    }
    
    
    
   
    
    var messages:[ChatMessage] = [ChatMessage]()
    
    //var communicationManager:CommunicationManager
    //var multipeerCommunicator:MultipeerCommunicator?
    
    
    //var userName:String
    //var userID:String
    var model:IConversationViewControllerModel
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    init(model:IConversationViewControllerModel) {
        self.model=model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model.userName
        self.table.register(UINib.init(nibName: "IncomeMessageCell", bundle: nil), forCellReuseIdentifier: "IncomeMessageCell")
        self.table.register(UINib.init(nibName: "OutcomeMessageCell", bundle: nil), forCellReuseIdentifier: "OutcomeMessageCell")
        self.table.delegate = self
        self.table.dataSource = self
        //NotificationCenter.default.addObserver(self, selector: #selector(refreshDialogNot), name: .refreshDialog, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.getDialog()
    }
    
    func setupDialog(dialog:ChatDialog){
                DispatchQueue.main.async {
                    self.messages = dialog.messages
                    self.sendButton.isEnabled = dialog.online
                    self.table.reloadData()
                }
    }
    
    
//    func refreshDialog(){
//        DispatchQueue.main.async {
//            let dialog = self.communicationManager.getChatDialog(userName: self.userName)
//            self.messages = dialog.messages
//            self.sendButton.isEnabled = dialog.online
//            self.table.reloadData()
//        }
//    }
    
//    @objc func refreshDialogNot(_ notification: NSNotification){
//        model.getDialog()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.updateUnread()
        model.communicationManager.convListDelegate?.update()
        //NotificationCenter.default.post(name: .refreshDialogs, object: nil)
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
        model.sendMessage(string: messageText.text!, to: model.userID)
        //multipeerCommunicator.sendMessage(string: messageText.text!, to: userID!, completionHandler: nil)
    }
    
    
}


protocol MessageCellConfiguration : class {
    var messageText : String? {get set}
}


