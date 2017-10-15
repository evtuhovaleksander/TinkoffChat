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
    
    func showErrorAlert(error:String, controller:UIViewController, operationTaskManager:OperationTaskManager?){
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
            if let manager = operationTaskManager {
                manager.saveProfile(controller: controller as! ProfileViewController)
            }
            else{
                GCDTaskManager().saveProfile(controller: controller as! ProfileViewController)
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
                    self.showErrorAlert(error: result, controller: controller, operationTaskManager: nil)
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
    
class OperationTaskManager : AlertManager, TaskManager {
    
    let operationQueue = OperationQueue()
    
    func saveProfile(controller:ProfileViewController) {
        controller.activityStartAnimate()
        let saveOperation = SaveProfileOperation(profile: controller.profile)
        saveOperation.completionBlock = {
            if let result = saveOperation.result {
                DispatchQueue.main.async() {
                    self.showErrorAlert(error: result, controller: controller, operationTaskManager: self)
                }
            } else {
                DispatchQueue.main.async() {
                    controller.activityStopAnimate()
                    self.showSucsessAlert(controller: controller)
                }
            }
            
        }
        operationQueue.addOperation(saveOperation)

    }
    
    func readProfile(controller:ProfileViewController) {
        controller.activityStartAnimate()
        let readOperation = ReadProfileOperation()
        readOperation.completionBlock = {
            let profile = readOperation.profile!
            DispatchQueue.main.async() {
                controller.profile = profile
                controller.loadDataFromProfile()
                controller.activity.stopAnimating()
            }
            
        }
        operationQueue.addOperation(readOperation)
    }

}
    
    
class AsyncOperation: Operation {
    
    // Определяем перечисление enum State со свойством keyPath
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // Помещаем в subclass свойство state типа State
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    // Переопределения для Operation
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
    
}

class ReadProfileOperation: AsyncOperation {
    var profile:Profile?
    
    override func main() {
        profile = Profile.getProfile()
        sleep(4)
        self.state = .finished
    }
}

class SaveProfileOperation: AsyncOperation {
    var result:String?
    var profile:Profile
    
    init(profile:Profile) {
        self.profile = profile
        super.init()
    }
    override func main() {
        result = profile.saveProfile()
        sleep(4)
        self.state = .finished
    }
}
