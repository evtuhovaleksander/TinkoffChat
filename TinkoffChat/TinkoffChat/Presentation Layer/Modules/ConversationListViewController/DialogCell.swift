//
//  DialogCell.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell, ConversationCellConfiguration {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var onlineMarker: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
        func setupUI(){
            avatarImage.image = UIImage(named:"EmptyAvatar")
            let roundConstant = onlineMarker.bounds.size.width / 2.0
            avatarImage.layer.cornerRadius = roundConstant
            avatarImage.clipsToBounds = true
            onlineMarker.layer.cornerRadius = roundConstant
            onlineMarker.clipsToBounds = true
        }
        
        var name: String?{
            didSet{
                nameLabel.text = name
            }
        }
        
        var message: String?{
            didSet{
                if let messageText = message{
                    if(hasUnreadMessage){
                        messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
                        messageLabel.text = messageText
                    }else{
                        messageLabel.font = UIFont.systemFont(ofSize: 13)
                        messageLabel.text = messageText
                    }
                    
                }
                else{
                    messageLabel.font = UIFont(name: "Kefa", size: 13)
                    messageLabel.text = "No messages yet"
                }
            }
        }
        
        var date: Date?{
            didSet{
                if date == nil {
                    dateLabel.text = ""
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.YYYY"
                if(dateFormatter.string(from: date!) != dateFormatter.string(from: Date())){
                    dateFormatter.dateFormat = "dd.MMM"
                    dateLabel.text = dateFormatter.string(from: date!)
                }
                else{
                    dateFormatter.dateFormat = "HH:mm"
                    dateLabel.text = dateFormatter.string(from: date!)
                }
            }
        }
        
        var hasUnreadMessage: Bool = false{
            didSet{
                if(message != nil){
                    if(hasUnreadMessage){
                        messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
                    }else{
                        messageLabel.font = UIFont.systemFont(ofSize: 13)
                    }
                }
            }
        }
        
        var online: Bool = false{
            didSet{
                if(online){
                    onlineMarker.backgroundColor = .green
                    backgroundColor = UIColor(red:1.00, green:1.00, blue:0.88, alpha:1.0)
                    
                }
                else{
                    onlineMarker.backgroundColor = .red
                    backgroundColor = .white
                }
            }
        }
        

    
}
