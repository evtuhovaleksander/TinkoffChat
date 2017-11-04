//
//  PersistentStore.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 04/11/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation
import CoreData

private var storeURL : URL {
    get{
        let documentsDirURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirURL.appendingPathComponent("Store.sqlite")
        return url
    }
}
