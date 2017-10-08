//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var messages:[Message]?
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var income30 = ""
        var outcome30 = ""
        var income300 = ""
        var outcome300 = ""
        
        for i in 0...300{
            if(i<30){
                income30+="i"
                outcome30+="o"
            }
            income300 += "i"
            outcome300 += "o"
        }
        
        messages = [Message]()
        messages?.append(Message(message: "i",incomeP: true))
        messages?.append(Message(message: "o",incomeP: false))
        messages?.append(Message(message: income30,incomeP: true))
        messages?.append(Message(message: outcome30,incomeP: false))
        messages?.append(Message(message: income300,incomeP: true))
        messages?.append(Message(message: outcome300,incomeP: false))
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages![indexPath.row]
        
        if(message.income){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.messageText
            return cell
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! MessageCell
            cell.messageText = message.messageText
            return cell
        }
        
    }

}

class Message : MessageCellConfiguration{
    var messageText: String?
    var income: Bool
    
    init(message:String?,incomeP:Bool){
        self.messageText = message
        self.income = incomeP
    }
}

protocol MessageCellConfiguration : class {
    var messageText : String? {get set}
}
