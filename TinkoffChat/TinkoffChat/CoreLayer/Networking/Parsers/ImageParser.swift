//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 21.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ImageParser: Parser<NetworkImageModel> {
    
    override func parse(data: Data) -> NetworkImageModel? {
        
        if let image = UIImage(data: data) {
            return NetworkImageModel(image: image)
        }
        
        return nil
    }
}
