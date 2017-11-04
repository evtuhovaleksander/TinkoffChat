//
//  ManagedObjectModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 04/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import CoreData

private let managedObjectModelName = "Storage"
private var _managedObjectModel : NSManagedObjectModel?
private var managedObjectModel : NSManagedObjectModel? {
    get{
        if _managedObjectModel == nil{
            guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension : "momd") else{
                return nil
            }
            
            _managedObjectModel = NSManagedObjectModel(contentsOf:modelURL)
        }
        
        return _managedObjectModel
    }
}
