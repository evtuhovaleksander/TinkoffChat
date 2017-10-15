//
//  GCDTaskManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 15/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import UIKit

protocol TaskManager {
    func saveProfile(controller:ProfileViewController)
    func readProfile(controller:ProfileViewController)
}

class AlertManager{
    func showSucsessAlert(controller:UIViewController){
        let optionMenu = UIAlertController(title: "Даные сохранены", message: nil, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async() {
                let profileController = controller as! ProfileViewController
                profileController.loadDataFromProfile()
            }
            optionMenu.dismiss(animated: true, completion: nil)
        })
        
        optionMenu.addAction(okAction)
        controller.present(optionMenu, animated: true, completion: nil)
    }
    
    func showErrorAlert(error:String, controller:UIViewController, gcd:Bool){
        let optionMenu = UIAlertController(title: "Ошибка", message: error, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async() {
                let profileController = controller as! ProfileViewController
                profileController.activityStopAnimate()
                GCDTaskManager().readProfile(controller: controller as! ProfileViewController)
            }
            optionMenu.dismiss(animated: true, completion: nil)
            
        })
        
        let againAction = UIAlertAction(title: "Повторить", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if(gcd){
                GCDTaskManager().saveProfile(controller: controller as! ProfileViewController)
            }
            else{
                
            }
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(againAction)
        controller.present(optionMenu, animated: true, completion: nil)
    }
}


class GCDTaskManager : AlertManager, TaskManager {
    func saveProfile(controller:ProfileViewController) {
        controller.activityStartAnimate()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async() {
            //let result = controller.profile.saveProfile()
            //sleep(5)
            if let result = controller.profile.saveProfile(){
                DispatchQueue.main.async() {
                    self.showErrorAlert(error: result, controller: controller, gcd: true)
                }
            }else{
                DispatchQueue.main.async() {
                    controller.activityStopAnimate()
                    self.showSucsessAlert(controller: controller)
                }
            }
            
        }
    }
    
    func readProfile(controller:ProfileViewController) {
        controller.activity.startAnimating()
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async() {
            let profile = Profile.getProfile()
            //sleep(5)
                DispatchQueue.main.async() {
                    controller.profile = profile
                    controller.loadDataFromProfile()
                    controller.activity.stopAnimating()
                }
        }
    }
    
    
}
    
    
    
    
//    func todo(){
//    let queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
//    // submit a task to the queue for background execution
//    dispatch_async(queue) {
//    let enhancedImage = self.applyImageFilter(image) // expensive operation taking a few seconds
//    // update UI on the main queue
//    dispatch_async(dispatch_get_main_queue()) {
//    self.imageView.image = enhancedImage
//    UIView.animateWithDuration(0.3, animations: {
//    self.imageView.alpha = 1
//    }) { completed in
//    // add code to happen next here
//    }
//    }
//        }}

