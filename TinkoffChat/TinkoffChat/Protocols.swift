//
//  Protocols.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 22/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//


import Foundation

//protocol Communicator {
//    func sendMessage(string: String, to userID: String, completionHandler: ((_ sucsess:Bool, _ error: Error?)->())?)
//    weak var delegate : CommunicatorDelegate? {get set}
//    var online: Bool {get set}
//}

protocol CommunicatorDelegate : class{
    
    func didFoundUser(userID: String, userName:String?)
    func didLostUser(userID: String)
    func userDidBecome(userID:String,online:Bool)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error:Error)
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}


