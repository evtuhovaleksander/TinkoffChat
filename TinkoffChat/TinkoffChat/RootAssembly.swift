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
    
    init(name:String) {
        let multiPeerCommunicator = MultipeerCommunicator(selfName: name)
        self.communicationManager = CommunicationManager(multipeerCommunicator:multiPeerCommunicator)
        multiPeerCommunicator.delegate=self.communicationManager
        self.coreDataService = CoreDataService()
    }
}

