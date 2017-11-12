//
//  ConversationCellProtocol.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 12/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration : class{
    var name : String? {get set}
    var message : String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessage : Bool {get set}
}
