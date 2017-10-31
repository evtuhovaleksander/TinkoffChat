//
//  ChatMessage.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation


class ChatMessage{
    init(text:String,date:Date,income:Bool) {
        self.text = text
        self.date = date
        self.income = income
        self.unRead = true
    }
    var text:String
    var date:Date
    var income:Bool
    var unRead:Bool
    
}
