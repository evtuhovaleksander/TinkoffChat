//
//  MultipeerSingletonManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

let rootAssembly : RootAssembly = RootAssembly(name: "name")

class RootAssembly{
    let communicationManager: CommunicatorDelegate
    let coreDataService: CoreDataService
    let requestSender:RequestSender
    
    init(name:String) {
        self.coreDataService = CoreDataService()
        let multiPeerCommunicator = MultipeerCommunicator(selfName: name)
        self.communicationManager = CommunicationManager(multipeerCommunicator:multiPeerCommunicator,service:self.coreDataService)
        multiPeerCommunicator.delegate=self.communicationManager
        self.requestSender = RequestSender()
    }
}


class Tester{
    static func recieve_message(conversation:Conversation){
        rootAssembly.communicationManager.didRecieveMessage(text: "edededed", fromUser: (conversation.user?.id!)!, toUser: "me")
    }
}

