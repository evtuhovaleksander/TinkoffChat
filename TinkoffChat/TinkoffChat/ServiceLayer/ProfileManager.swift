//
//  ProfileManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 30/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol ProfileManagerDelegate {
    //func recievedProfile(model:CoreProfileModel)
}

protocol ProfileManagerProtocol  {
    var service:CoreDataService {get set}
    func loadProfile()->CoreProfile?
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



class ProfileManager:ProfileManagerProtocol{

    
    var service: CoreDataService
    
    init(){
        self.service = rootAssembly.coreDataService
    }
    
    func save(){
        self.service.doSave(completionHandler: nil)
    }
    
    func loadProfile() -> CoreProfile? {
        if let appUser = self.service.findOrInsertAppUser(){
            if let profile = appUser.profile{
                return profile
            }
        }
        return nil
    }
}



