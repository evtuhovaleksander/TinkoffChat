//
//  ProfileViewControllerAssembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ProfileViewControllerAssembler {
    static func createProfileViewControllerAssembler()->ProfileViewController{
        let model = ProfileViewControllerModel()
        let controller = ProfileViewController(model: model)
        model.delegate = controller
        return controller
    }
}
