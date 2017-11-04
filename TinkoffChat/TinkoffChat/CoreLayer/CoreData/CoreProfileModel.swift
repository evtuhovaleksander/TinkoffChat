//
//  CoreProfile.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 04/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

//class CoreProfileModel :  ProfileProtocol{
//    var hasModel:Bool
//    var model : CoreProfile?
//    
//    var newName: String{
//        didSet{
//            needSave = (newName != name)
//            model.name = newName
//            rootAssembly.coreDataService.doSave(completionHandler: nil)
//        }
//    }
//    
//    var name: String
//    
//    var newInfo: String{
//        didSet{
//            needSave = (newInfo != info)
//            model.info = newInfo
//            rootAssembly.coreDataService.doSave(completionHandler: nil)
//        }
//    }
//    var info: String
//    
//    var newAvatar: UIImage{
//        didSet{
//            needSave = (CoreProfileModel.imageToBase64ImageString(image: avatar) != CoreProfileModel.imageToBase64ImageString(image: newAvatar))
//            
//            model.avatar = CoreProfileModel.imageToBase64ImageString(image: newAvatar)
//            rootAssembly.coreDataService.doSave(completionHandler: nil)
//            //rootAssembly.coreDataService.performSave(context: , completionHandler: nil)
//        }
//    }
//    
//    var avatar: UIImage
//    
//    var needSave: Bool
//    
//
//    
//    init(model: CoreProfile?) {
//        self.model = model
//        self.name = model.name ?? ""
//        self.info = model.info ?? ""
//        
//        if let img = model.avatar{
//            self.avatar = self.base64ImageStringToUIImage(base64String: img)
//        }else{
//            self.avatar = UIImage.init(named: "EmptyAvatar") ?? UIImage()
//        }
//        rootAssembly.coreDataService.doSave(completionHandler: nil)
//    }
//    
//    
//    
//    func base64ImageStringToUIImage(base64String:String)->UIImage{
//        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
//        return UIImage(data: dataDecoded)!
//    }
//    
//    func imageToBase64ImageString(image:UIImage)->String{
//        let jpegCompressionQuality: CGFloat = 1
//        return (UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString())!
//    }
//    
//}

