//
//  Alert.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

//import UIKit

//class AlertManager{
//    func showSucsessAlert(controller:UIViewController){
//        let optionMenu = UIAlertController(title: "Даные сохранены", message: nil, preferredStyle: .actionSheet)
//        
//        let okAction = UIAlertAction(title: "ОК", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            DispatchQueue.main.async() {
//                let profileController = controller as! ProfileViewController
//                profileController.loadDataFromProfile()
//            }
//            optionMenu.dismiss(animated: true, completion: nil)
//        })
//        
//        optionMenu.addAction(okAction)
//        controller.present(optionMenu, animated: true, completion: nil)
//    }
//    
//    func showErrorAlert(error:String, controller:UIViewController, operationTaskManager:OperationTaskManager?){
//        let optionMenu = UIAlertController(title: "Ошибка", message: error, preferredStyle: .actionSheet)
//        
//        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            DispatchQueue.main.async() {
//                let profileController = controller as! ProfileViewController
//                profileController.activityStopAnimate()
//                GCDTaskManager().readProfile(controller: controller as! ProfileViewController)
//            }
//            optionMenu.dismiss(animated: true, completion: nil)
//            
//        })
//        
//        let againAction = UIAlertAction(title: "Повторить", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            if let manager = operationTaskManager {
//                manager.saveProfile(controller: controller as! ProfileViewController)
//            }
//            else{
//                GCDTaskManager().saveProfile(controller: controller as! ProfileViewController)
//            }
//        })
//        
//        optionMenu.addAction(cancelAction)
//        optionMenu.addAction(againAction)
//        controller.present(optionMenu, animated: true, completion: nil)
//    }
//}

