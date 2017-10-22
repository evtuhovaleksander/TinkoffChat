//
//  MultipeerCommunicator.swift
//  ProtoChat
//
//  Created by Aleksander Evtuhov on 22/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

//var myPeerID: MCPeerID = MCPeerID(displayName:"lol")

struct ChatSession{
    let userName:String
    let mcPeerID:MCPeerID
    var session:MCSession?
}

class ChatUser{
    var userName:String
    var mcPeerID:MCPeerID
    var session:MCSession
    
    init(userName:String,mcPeerID:MCPeerID,myPeerID:MCPeerID) {
        self.userName = userName
        self.mcPeerID = mcPeerID
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
    }
}

class MultipeerCommunicator:NSObject, Communicator{
    
  
    
    //var sessions : Dictionary<MCPeerID,MCSession>
    //var users : Dictionary<MCPeerID,User>
    
    var chatSessions:[ChatSession]
    var chatUsers:Dictionary<String,ChatUser>
    var myName: String
    var myPeerID: MCPeerID
    var delegate: CommunicatorDelegate?
    var online: Bool{
        didSet{
            if online{
                serviceBrowser.startBrowsingForPeers()
                serviceAdvertiser.startAdvertisingPeer()
            }
            else{
                serviceBrowser.stopBrowsingForPeers()
                serviceAdvertiser.stopAdvertisingPeer()
                
                for item in chatUsers{
                    item.value.session.disconnect()
                }
                
            }
        }
    }
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser
    var serviceBrowser: MCNearbyServiceBrowser
    
    init(selfName: String) {
        
        
        online = true
        myName = selfName
        
        chatSessions = [ChatSession]()
        chatUsers = Dictionary<String,ChatUser>()
        
        myPeerID = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)

        
        //sessions = Dictionary<MCPeerID,MCSession>()
        
        
        //self.myPeerID = MCPeerID(displayName: myName)
        
        var discoveryInfo = ["userName":self.myName]
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: "tinkoff-chat")
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType:"tinkoff-chat")
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        
        if let chatUser = chatUsers[userID]{
            do{
                try chatUser.session.send(Data(), toPeers: [chatUser.mcPeerID], with: .reliable)
                
            }catch is Error {
               return
            }
            
            delegate?.didRecieveMessage(text: "message", fromUser: "me", toUser: chatUser.mcPeerID.displayName)
        }
    }

  
    func getChatUser(userPeerID:MCPeerID,userName:String)->ChatUser{
        if let chatUser = chatUsers[userPeerID.displayName]{
            if chatUser.userName == "" && userName != ""{
                chatUser.userName = userName
            }
            return chatUser
        }
        else{
           let chatUser = ChatUser(userName: userName, mcPeerID: userPeerID, myPeerID: myPeerID)
            return chatUser
        }
    }
}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print( "didNotStartAdvertisingPeer: \(error)")
        delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print( "didReceiveInvitationFromPeer \(peerID)")
        let chatUser = getChatUser(userPeerID: peerID, userName: "")
        invitationHandler(true,chatUser.session)
    }
    
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let chatUser = getChatUser(userPeerID: peerID, userName: info!["userName"]!)
        
        browser.invitePeer(peerID, to: chatUser.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

extension MultipeerCommunicator : MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case .connected:
            delegate?.userDidBecome(userID: peerID.displayName, online: true)
            break
        
        case .connecting:
            
            break
            
        case .notConnected:
            delegate?.userDidBecome(userID: peerID.displayName, online: false)
            break
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.didRecieveMessage(text: "message", fromUser: peerID.displayName, toUser: "me")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        return
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        return
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        return
    }
}
