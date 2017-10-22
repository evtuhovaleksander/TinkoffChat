//
//  NotificationRouter.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 22/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let refreshDialog = Notification.Name("refreshDialog")
    //static let refreshDialogStatus = Notification.Name("refreshDialogStatus")
    static let refreshDialogs = Notification.Name("refreshDialogs")
}

//NotificationCenter.default.post(name: .signUpCallback, object: nil)

//func signUpCallback(_ notification: NSNotification){
//    APIHelper.logInRequest(person: person)
//}

//NotificationCenter.default.addObserver(self, selector: #selector(signUpCallback), name: .signUpCallback, object: nil)
