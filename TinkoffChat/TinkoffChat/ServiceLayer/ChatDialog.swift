//
//  ChatDialog.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ChatDialog{
    init(name:String,userID:String){
        self.name = name
        self.userID = userID
        self.online = false
        self.messages = [ChatMessage]()
    }
    
    var name: String?
    var userID: String?
    var online: Bool
    var messages:[ChatMessage]
}
