//
//  ProfileManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol ProfileManagerDelegate {
    func recievedProfile(model:CoreProfile?)
}

protocol ProfileManagerProtocol  {
    var service:ProfileManagerCoreServiceProtocol {get set}
    var delegate:ProfileManagerDelegate? {get set}
    func loadProfile()
    func save()
}



class ImageEnCoder{
    static func base64ImageStringToUIImage(base64String:String)->UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    static func imageToBase64ImageString(image:UIImage)->String{
        let jpegCompressionQuality: CGFloat = 1
        return (UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString())!
    }
}



class ProfileManager:ProfileManagerProtocol,ProfileManagerCoreServiceProtocolDelegate{
    var delegate: ProfileManagerDelegate?
    

    var service: ProfileManagerCoreServiceProtocol
    
    
    init(){
        self.service = CoreDataService()//rootAssembly.coreDataService
        self.service.profileManagerDelegate = self
    }
    
    func save(){
        self.service.saveProfile()
    }
    
    
    func loadProfile(){
        service.getProfile()
    }
    
    func recievedProfile(profile:CoreProfile?){
        delegate?.recievedProfile(model: profile)
    }
}

protocol ProfileManagerCoreServiceProtocol {
    var profileManagerDelegate: ProfileManagerCoreServiceProtocolDelegate? {get set}
    func getProfile()
    func saveProfile()
}
protocol ProfileManagerCoreServiceProtocolDelegate {
    func recievedProfile(profile:CoreProfile?)
}


