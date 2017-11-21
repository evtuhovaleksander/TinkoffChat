//
//  PhotoSelectionViewControllerAssembler.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class PhotoSelectionViewControllerAssembler{
    static func getController(delegate:IPhotoSelectionViewControllerDelegate)->PhotoSelectionViewController{
        let model = PhotoSelectionViewControllerModel()
        let networkManager = NetworkManager(delegate: model)
        model.manager = networkManager
        let controller = PhotoSelectionViewController(model:model)
        model.delegate=controller
        controller.delegate = delegate
        return controller
    }
    
    
    
}
