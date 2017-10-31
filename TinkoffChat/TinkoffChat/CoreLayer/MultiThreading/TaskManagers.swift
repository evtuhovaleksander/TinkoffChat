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
    func saveProfile(profile:Profile)
    func readProfile()
}

protocol TaskManagerDelegate{
    func startAnimate()
    func stopAnimate()
    func showErrorAlert(string:String,gcdMode:Bool)
    func showSucsessAlert()
    func receiveProfile(profile:Profile)
}

