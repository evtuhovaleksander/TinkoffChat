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
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages![indexPath.row]
        let maskPath : UIBezierPath?
        
        if(message.income){
            let cell = table.dequeueReusableCell(withIdentifier: "IncomeMessageCell", for: indexPath) as! IncomeMessageCell
            
            cell.messageLabel.text = message.text
            cell.messageLabel.backgroundColor = UIColor(red:0.95, green:1.00, blue:0.63, alpha:1.0)
            cell.messageLabel.layer.cornerRadius = 3
            cell.messageLabel.clipsToBounds = true
            return cell
            
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "OutcomeMessageCell", for: indexPath) as! OutcomeMessageCell
            cell.messageLabel.text = message.text
            cell.messageLabel.backgroundColor = UIColor(red:0.63, green:0.65, blue:1.00, alpha:1.0)
            cell.messageLabel.layer.cornerRadius = 3
            cell.messageLabel.clipsToBounds = true
            return cell
        }
        
    }

}

class Message : MessageCellConfiguration{
    var text: String?
    var income: Bool
    
    init(message:String?,incomeP:Bool){
        self.text = message
        self.income = incomeP
    }
    
    func configCell(cell:UITableViewCell)->UITableViewCell{
        if cell is IncomeMessageCell {
           (cell as! IncomeMessageCell).messageLabel.text = text
        }
        else{
            (cell as! OutcomeMessageCell).messageLabel.text = text
        }
        return cell
    }
}

protocol MessageCellConfiguration : class {
    var text : String? {get set}
}
