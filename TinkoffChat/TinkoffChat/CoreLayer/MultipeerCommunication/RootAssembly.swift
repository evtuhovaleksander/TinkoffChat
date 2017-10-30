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
    let communicationManager: CommunicationManager
    let multiPeerCommunicator : MultipeerCommunicator
    
    init(name:String) {
        self.communicationManager = CommunicationManager()
        self.multiPeerCommunicator = MultipeerCommunicator(selfName: name)
        self.multiPeerCommunicator.delegate=self.communicationManager
    }
}

