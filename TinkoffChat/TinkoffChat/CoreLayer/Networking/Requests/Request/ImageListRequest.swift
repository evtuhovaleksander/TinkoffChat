//
//  ListOfImagesRequest.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ImageListRequest: IRequest {
    fileprivate var command: String {
        return ""
    }
    
    var limitString: String {
        return "&per_page=\(limit)"
    }
    
    var secretKeyString: String {
        return "?key=\(secretKey)"
    }
    
    var base: String = "https://pixabay.com/api/"
    let secretKey = "7093037-873cea2ce2fa9851c7e05a01f"
    var limit: Int = 100
    
    // MARK: - IRequest
    var urlRequest: URLRequest? {

        let urlString: String = base + secretKeyString + command + limitString
        
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
}

