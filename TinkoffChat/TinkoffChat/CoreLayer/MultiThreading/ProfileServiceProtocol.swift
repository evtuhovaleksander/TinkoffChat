//
//  ProtocolOperator.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol ProfileService {
    func getProfileService()->Profile
    func getEmptyProfileService()->Profile
    func saveProfileService(profile:Profile)->String?
}

extension ProfileService{
    func getProfileService()->Profile{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
        if let simpleData:Data = try? Data(contentsOf: fileURL) {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: simpleData)
            if let profile = decodedData as? Profile{
                return profile
            }
        }
        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
    }
    
    func getEmptyProfileService()->Profile{
        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
    }
    
    func saveProfileService(profile:Profile)->String?{
        
        if( Int(arc4random_uniform(2))==1){
            
            
        }else{
            return "generated error"
            
        }
        
        profile.needSave = false
        
        profile.avatar = profile.newAvatar
        profile.name = profile.newName
        profile.info = profile.newInfo
        
        
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf"){
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: profile)
                try data.write(to: fileURL)
                return nil
            } catch let error {
                print(error.localizedDescription)
                return error.localizedDescription
            }
        }
        return "can't get path"
    }
    
    
    
    
}



//extension ProfileOperator{
//    func getProfile()->Profile{
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
//        if let simpleData:Data = try? Data(contentsOf: fileURL) {
//            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: simpleData)
//            if let profile = decodedData as? Profile{
//                return profile
//            }
//        }
//        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
//    }
//
//    func getEmptyProfile()->Profile{
//        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
//    }
//}

