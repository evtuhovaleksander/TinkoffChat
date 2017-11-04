//
//  CoreProfile.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 04/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class CoreProfileModel :  ProfileProtocol{
    
    var model : CoreProfile
    
    var newName: String{
        didSet{
            needSave = (newName != name)
        }
    }
    
    var name: String
    
    var newInfo: String{
        didSet{
            needSave = (newInfo != info)
        }
    }
    var info: String
    
    var newAvatar: UIImage{
        didSet{
            needSave = (CoreProfileModel.imageToBase64ImageString(image: avatar) != CoreProfileModel.imageToBase64ImageString(image: newAvatar))
        }
    }
    
    var avatar: UIImage
    
    var needSave: Bool
    

    
    init(model: CoreProfile) {
        self.model = model
        self.name = model.name ?? ""
        self.newName = model.name ?? ""
        self.info = model.info ?? ""
        self.newInfo = model.info ?? ""
        
        if let img = model.avatar{
            self.avatar = CoreProfileModel.base64ImageStringToUIImage(base64String: img)
            self.newAvatar = CoreProfileModel.base64ImageStringToUIImage(base64String: img)
        }else{
            self.avatar = UIImage.init(named: "EmptyAvatar") ?? UIImage()
            self.newAvatar = UIImage.init(named: "EmptyAvatar") ?? UIImage()
            self.model.avatar = CoreProfileModel.imageToBase64ImageString(image:UIImage.init(named: "EmptyAvatar") ?? UIImage())
        }
        
        self.needSave = false
    }
    
    
    
    static func base64ImageStringToUIImage(base64String:String)->UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    static func imageToBase64ImageString(image:UIImage)->String{
        let jpegCompressionQuality: CGFloat = 1
        return (UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString())!
    }
    
}
