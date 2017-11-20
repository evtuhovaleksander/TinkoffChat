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
        assertionFailure("❌ Should use a subclass of AppleRSSRequest ")
        return ""
    }
   
    private var baseUrl: String = "https://itunes.apple.com/us/rss/"

    private var requestFormat: String = "json"
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + command + requestFormat
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init() {
    }
}
