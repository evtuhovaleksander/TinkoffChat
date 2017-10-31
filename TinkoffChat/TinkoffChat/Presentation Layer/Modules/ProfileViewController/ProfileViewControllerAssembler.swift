//
//  ProfileViewControllerAssembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 31/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ProfileViewControllerAssembler : ProfileService {
    static func createProfileViewControllerAssembler()->ProfileViewController{
        let profile = ProfileViewControllerAssembler().getEmptyProfileService()
        let model = ProfileViewControllerModel(profile: profile)
        let controller = ProfileViewController(model: model)
        model.delegate = controller
        model.setupManagersDelegates(delegate: model)
        return controller
    }
}
