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



class ChatUser{
    var userName:String
    var mcPeerID:MCPeerID
    var session:MCSession
    
    init(userName:String,mcPeerID:MCPeerID,myPeerID:MCPeerID,delegate:MultipeerCommunicator) {
        self.userName = userName
        self.mcPeerID = mcPeerID
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = delegate
    }
}

class MultipeerCommunicator:NSObject, Communicator{

    var chatUsers:Dictionary<String,ChatUser>
    var myName: String
    var myPeerID: MCPeerID
    var delegate: CommunicatorDelegate?
    var online: Bool//{
//        didSet{
//            if online{
//                serviceBrowser.startBrowsingForPeers()
//                serviceAdvertiser.startAdvertisingPeer()
//            }
//            else{
//                serviceBrowser.stopBrowsingForPeers()
//                serviceAdvertiser.stopAdvertisingPeer()
//
//                for item in chatUsers{
//                    item.value.session.disconnect()
//                }
//
//            }
//        }
//    }
    
    var serviceAdvertiser : MCNearbyServiceAdvertiser
    var serviceBrowser: MCNearbyServiceBrowser
    
    init(selfName: String) {
        
        
        online = true
        myName = selfName
        
     
        chatUsers = Dictionary<String,ChatUser>()
        
        myPeerID = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)
        
        let discoveryInfo = ["userName":self.myName]
        
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
                let data = jsonManager.makeMessage(string: string)
                try chatUser.session.send(data, toPeers: [chatUser.mcPeerID], with: .reliable)
            }catch {
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
            let chatUser = ChatUser(userName: userName, mcPeerID: userPeerID, myPeerID: myPeerID,delegate:self)
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
        if(!chatUser.session.connectedPeers.contains(peerID)){
            invitationHandler(true,chatUser.session)
        }else{
            invitationHandler(false,nil)
        }
        chatUsers[peerID.displayName]=chatUser
    }
    
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        let chatUser = getChatUser(userPeerID: peerID, userName: info!["userName"]!)
        if(!chatUser.session.connectedPeers.contains(peerID)){
            browser.invitePeer(peerID, to: chatUser.session, withContext: nil, timeout: 30)
            delegate?.didFoundUser(userID: peerID.displayName, userName: info!["userName"]!)
            delegate?.userDidBecome(userID: peerID.displayName, online: true)
        }
        chatUsers[peerID.displayName]=chatUser
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
        delegate?.userDidBecome(userID: peerID.displayName, online: false)
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
        delegate?.didRecieveMessage(text: jsonManager.readMessage(data: data), fromUser: peerID.displayName, toUser: "me")
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
