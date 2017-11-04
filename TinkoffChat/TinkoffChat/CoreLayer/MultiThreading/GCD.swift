////
////  GCD.swift
////  TinkoffChat
////
////  Created by Aleksander Evtuhov on 31/10/2017.
////  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
////
//
//import Foundation
//
//
//
//class GCDTaskManager :TaskManager, ProfileService {
//
//
//    var delegate:TaskManagerDelegate?
//
//
//    func saveProfile(profile:Profile) {
//        delegate?.startAnimate()
//        let queue = DispatchQueue.global(qos: .userInitiated)
//
//        queue.async() {
//            if let result = self.saveProfileService(profile: profile){
//                DispatchQueue.main.async() {
//                    self.delegate?.showErrorAlert(string: result,gcdMode: true)
//                }
//            }else{
//                DispatchQueue.main.async() {
//                    self.delegate?.stopAnimate()
//                    self.delegate?.showSucsessAlert()
//                }
//            }
//
//        }
//    }
//
//    func readProfile() {
//        delegate?.startAnimate()
//        let queue = DispatchQueue.global(qos: .userInitiated)
//        queue.async() {
//            let profile = self.getProfileService()
//            DispatchQueue.main.async() {
//                self.delegate?.receiveProfile(profile: profile)
//                self.delegate?.stopAnimate()
//            }
//        }
//    }
//

//}

