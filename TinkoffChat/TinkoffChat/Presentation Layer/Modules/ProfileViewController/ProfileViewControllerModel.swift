//
//  ProfileViewControllerModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol ProfileProtocol : class{
    var name:String {get set}
    var info:String {get set}
    var avatar:UIImage {get set}
    var needSave:Bool {get set}
}


protocol ProfileViewControllerModelDelegate : TaskManagerDelegate {
    func update()
}

protocol IProfileViewControllerModel{
    var profile:Profile {get set}
    var gcdManager:TaskManager {get set}
    var operationManager:TaskManager {get set}
    var delegate:ProfileViewControllerModelDelegate? {get set}
    func setupManagersDelegates(delegate:TaskManagerDelegate)
    func gcdSave()
    func operationSave()
}

class ProfileViewControllerModel : IProfileViewControllerModel,TaskManagerDelegate{
    
    func startAnimate() {
        delegate?.startAnimate()
    }
    
    func stopAnimate() {
        delegate?.stopAnimate()
    }
    
    func showErrorAlert(string: String, gcdMode: Bool) {
        delegate?.showErrorAlert(string: string, gcdMode: gcdMode)
    }
    
    func showSucsessAlert() {
        delegate?.showSucsessAlert()
    }
    
    func receiveProfile(profile: Profile) {
        self.profile = profile
        delegate?.update()
    }
    
  
    var profile:Profile
    var gcdManager:TaskManager
    var operationManager:TaskManager
    
    var delegate:ProfileViewControllerModelDelegate?
    
    init(profile:Profile) {
        self.profile = profile
        self.gcdManager = GCDTaskManager()
        self.operationManager = OperationTaskManager()
    }
    func setupManagersDelegates(delegate:TaskManagerDelegate){
        self.gcdManager.delegate = delegate
        self.operationManager.delegate = delegate
    }
    
    
    func gcdSave(){
        gcdManager.saveProfile(profile: profile)
    }
    
    func operationSave(){
        operationManager.saveProfile(profile: profile)
    }
}




class Profile : NSObject, NSCoding, ProfileProtocol{
    
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
            needSave = (imageToBase64ImageString(image: avatar) != imageToBase64ImageString(image: newAvatar))
        }
    }
    
    var avatar: UIImage
    
    var needSave: Bool
    

    
    init(name: String, info: String, avatar : UIImage, needSave : Bool) {
        self.name = name
        self.newName = name
        self.info = info
        self.newInfo = info
        self.avatar = avatar
        self.newAvatar = avatar
        self.needSave = needSave
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: aDecoder.decodeObject(forKey: "name") as! String,
            info: aDecoder.decodeObject(forKey: "info") as! String,
            avatar: Profile.base64ImageStringToUIImage(base64String: aDecoder.decodeObject(forKey: "avatar") as! String),
            needSave: false
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(imageToBase64ImageString(image: avatar), forKey: "avatar")
    }
    
    static func base64ImageStringToUIImage(base64String:String)->UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    func imageToBase64ImageString(image:UIImage)->String{
        let jpegCompressionQuality: CGFloat = 1
        return (UIImageJPEGRepresentation(image, jpegCompressionQuality)?.base64EncodedString())!
    }
    
}
