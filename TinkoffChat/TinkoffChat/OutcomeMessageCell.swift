//
//  OutcomeMessageCell.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 08/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class OutcomeMessageCell: UITableViewCell {
    
    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftSpace.constant = self.bounds.size.width/4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
