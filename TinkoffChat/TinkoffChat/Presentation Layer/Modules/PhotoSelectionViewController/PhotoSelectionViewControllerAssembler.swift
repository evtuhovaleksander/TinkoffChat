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
        let controller = PhotoSelectionViewController(model:model)
        model.delegate=controller
        controller.delegate = delegate
        return controller
    }
    
    
    
}
