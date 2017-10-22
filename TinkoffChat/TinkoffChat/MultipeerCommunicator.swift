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
        
        
        online = false
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
        
        let chatUser = getChatUser(userPeerID: userID, userName: "")
        
        chatUser.se
        
        delegate?.didRecieveMessage(text: "message", fromUser: peerID.displayName, toUser: "me")
    }
    
//    func getChatSessionForPeer(peer:MCPeerID)->ChatSession{
//        var chatSession:ChatSession? = nil
//
//        for item in chatSessions{
//            if(item.mcPeerID == peer){
//                chatSession = item
//                break
//            }
//        }
//        if chatSession == nil{
//            chatSession = ChatSession()
//        }
//        if chatSession.session == nil {
//            chatSession.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//            chatSession.session.delegate = self
//        }
//        return chatSession
//    }
    
//    func getChatSession(userName:String,peerID:MCPeerID)->ChatSession{
//
//        var chatSession:ChatSession?
//
//        for item in chatSessions{
//            if(item.userName == userName&&item.mcPeerID==peerID){
//                chatSession = item
//                break
//            }
//        }
//
//        if chatSession == nil{
//            chatSession = ChatSession(userName:userName,mcPeerID:peerID, session: nil)
//        }
//
//        var guardedChatSession = chatSession!
//
//        if guardedChatSession.session == nil {
//            guardedChatSession.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//            guardedChatSession.session!.delegate = self
//        }
//        return guardedChatSession
//    }
    
//    func getChatSessionForUserName(userName:String)->ChatSession{
//
//        var chatSession:ChatSession = ChatSession(userName: "",mcPeerID: MCPeerID(),session: nil)
//
//        for item in chatSessions{
//            if(item.userName == userName){
//                chatSession = item
//                break
//            }
//        }
//
//        if chatSession.session == nil {
//            chatSession.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//            chatSession.session!.delegate = self
//        }
//        return chatSession
//    }
    
    
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
        // send to delegate
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
