//
//  DialogCell.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var onlineMarker: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
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
                    messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
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
    
//    func configCell(cell : DialogCell)->DialogCell{
//        cell.nameLabel.text = name
//        
//        if let messageText = message{
//            if(hasUnreadMessage){
//                cell.messageLabel.font = UIFont.boldSystemFont(ofSize: 13)
//                cell.messageLabel.text = messageText
//            }else{
//                cell.messageLabel.font = UIFont.systemFont(ofSize: 13)
//                cell.messageLabel.text = messageText
//            }
//            
//        }
//        else{
//            cell.messageLabel.font = UIFont(name: "Kefa", size: 13)
//            cell.messageLabel.text = "No messages yet"
//        }
//        
//        
//        
//        
//        if(online){
//            cell.onlineMarker.backgroundColor = .green
//            cell.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.88, alpha:1.0)
//            
//        }
//        else{
//            cell.onlineMarker.backgroundColor = .red
//            cell.backgroundColor = .white
//        }
//        
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.YYYY"
//        if(dateFormatter.string(from: date!) != dateFormatter.string(from: Date())){
//            dateFormatter.dateFormat = "dd.MMM"
//            cell.dateLabel.text = dateFormatter.string(from: date!)
//        }
//        else{
//            dateFormatter.dateFormat = "HH:mm"
//            cell.dateLabel.text = dateFormatter.string(from: date!)
//        }
//        
//        cell.avatarImage.image = UIImage(named:"EmptyAvatar")
//        
//        let roundConstant = cell.onlineMarker.bounds.size.width / 2.0
//        cell.avatarImage.layer.cornerRadius = roundConstant
//        cell.avatarImage.clipsToBounds = true
//        cell.onlineMarker.layer.cornerRadius = roundConstant
//        cell.onlineMarker.clipsToBounds = true
//        
//        return cell
//    }
    
}
