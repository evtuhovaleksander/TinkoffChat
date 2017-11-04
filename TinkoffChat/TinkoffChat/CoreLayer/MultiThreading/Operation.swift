////
////  Operation.swift
////  TinkoffChat
////
////  Created by Aleksander Evtuhov on 31/10/2017.
////  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
////
//
//import UIKit
//
//class OperationTaskManager : TaskManager, ProfileService  {
//
//    
//    
//    let operationQueue = OperationQueue()
//    var delegate:TaskManagerDelegate?
//    
//    func saveProfile(profile:Profile) {
//        delegate?.startAnimate()
//        let saveOperation = SaveProfileOperation(profile: profile)
//        saveOperation.completionBlock = {
//            if let result = saveOperation.result {
//                DispatchQueue.main.async() {
//                    self.delegate?.showErrorAlert(string: result,gcdMode: false)
//                }
//            } else {
//                DispatchQueue.main.async() {
//                    self.delegate?.stopAnimate()
//                    self.delegate?.showSucsessAlert()
//                }
//            }
//        }
//        operationQueue.addOperation(saveOperation)
//    }
//    
//    func readProfile() {
//        delegate?.startAnimate()
//        let readOperation = ReadProfileOperation()
//        readOperation.completionBlock = {
//            let profile = readOperation.profile ?? self.getEmptyProfileService()
//            DispatchQueue.main.async() {
//                self.delegate?.receiveProfile(profile: profile)
//                self.delegate?.stopAnimate()
//            }
//        }
//        operationQueue.addOperation(readOperation)
//    }
//}
//
//
//class AsyncOperation: Operation {
//    
//    // Определяем перечисление enum State со свойством keyPath
//    enum State: String {
//        case ready, executing, finished
//        
//        fileprivate var keyPath: String {
//            return "is" + rawValue.capitalized
//        }
//    }
//    
//    // Помещаем в subclass свойство state типа State
//    var state = State.ready {
//        willSet {
//            willChangeValue(forKey: newValue.keyPath)
//            willChangeValue(forKey: state.keyPath)
//        }
//        didSet {
//            didChangeValue(forKey: oldValue.keyPath)
//            didChangeValue(forKey: state.keyPath)
//        }
//    }
//}
//
//extension AsyncOperation {
//    // Переопределения для Operation
//    override var isReady: Bool {
//        return super.isReady && state == .ready
//    }
//    
//    override var isExecuting: Bool {
//        return state == .executing
//    }
//    
//    override var isFinished: Bool {
//        return state == .finished
//    }
//    
//    override var isAsynchronous: Bool {
//        return true
//    }
//    
//    override func start() {
//        if isCancelled {
//            state = .finished
//            return
//        }
//        main()
//        state = .executing
//    }
//    
//    override func cancel() {
//        state = .finished
//    }
//    
//}
//
//class ReadProfileOperation: AsyncOperation, ProfileService {
//    var profile:Profile?
//    
//    override func main() {
//        profile = getProfileService()
//        sleep(4)
//        self.state = .finished
//    }
//}
//
//class SaveProfileOperation: AsyncOperation, ProfileService {
//    var result:String?
//    var profile:Profile
//    
//    init(profile:Profile) {
//        self.profile = profile
//        super.init()
//    }
//    override func main() {
//        result = saveProfileService(profile: profile)//saveProfileService()
//        sleep(4)
//        self.state = .finished
//    }
//}

