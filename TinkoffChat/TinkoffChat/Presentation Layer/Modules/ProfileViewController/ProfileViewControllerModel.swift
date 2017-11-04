//
//  ProfileViewControllerModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol CoreProfileViewControllerModelDelegate {
    func startAnimate()
    func stopAnimate()
    func update()
}

protocol ICoreProfileViewControllerModel{
    var coreProfile:CoreProfile? {get set}
    var delegate:CoreProfileViewControllerModelDelegate? {get set}
    func startAnimate()
    func stopAnimate()
    func getModel()
    func saveModel()
    var name:String {get set}
    var info:String {get set}
    var avatar:UIImage {get set}
}

class ProfileViewControllerModel : ICoreProfileViewControllerModel,ProfileManagerDelegate{
    func saveModel() {
        profileManager.save()
    }
    
    
    func recievedProfile(model: CoreProfile?) {
        self.coreProfile = model
        delegate?.update()
    }
    
    
    
    
    func getModel() {
        self.profileManager.loadProfile()
    }
    
    
    var name:String{
        get{
            if let profile = coreProfile{
                return profile.name ?? ""
            }
            return ""
        }
        
        set{
            if let profile = coreProfile{
                profile.name = newValue
                profileManager.save()
            }
        }
    }
    
    var info:String{
        get{
            if let profile = coreProfile{
                return profile.info ?? ""
            }
            return ""
        }
        
        set{
            if let profile = coreProfile{
                profile.info = newValue
                profileManager.save()
            }
        }
    }
    
    var avatar:UIImage{
        get{
            let av = UIImage.init(named: "EmptyAvatar") ?? UIImage()
            if let profile = coreProfile{
                if let avString = profile.avatar{
                    return ImageEnCoder.base64ImageStringToUIImage(base64String: avString)
                }else{
                    return av
                }
            }
            return av
        }
        
        set{
            if let profile = coreProfile{
                profile.avatar = ImageEnCoder.imageToBase64ImageString(image: newValue)
                profileManager.save()
            }
        }
    }

    func startAnimate() {
        delegate?.startAnimate()
    }

    func stopAnimate() {
        delegate?.stopAnimate()
    }
    
    
    var coreProfile:CoreProfile?
    
    var delegate:CoreProfileViewControllerModelDelegate?
    
    var profileManager:ProfileManagerProtocol
    
    init() {
        //let appUser  = rootAssembly.coreDataService.findOrInsertAppUser()
        //self.coreProfile = appUser?.profile
        
        
        profileManager = ProfileManager()
        profileManager.delegate = self
        
    }
}
