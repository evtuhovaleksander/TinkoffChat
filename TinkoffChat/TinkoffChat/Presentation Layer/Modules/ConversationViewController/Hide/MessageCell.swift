//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017MessageCell Aleksander Evtuhov. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell,MessageCellConfiguration {

    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var messageText : String?{
        didSet{
            messageLabel.text = messageText
        }
        
    }

    

}
