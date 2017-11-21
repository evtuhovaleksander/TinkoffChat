//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 21.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit



class ImageRequest: IRequest {
    
    var url: String
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        return nil
    }

    init(url: String) {
        self.url = url
    }
    
}
