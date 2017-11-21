//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct NetworkRequests {
        
        static func listImagesConfig() -> RequestConfig<[ListImageModel]> {
            return RequestConfig<[ListImageModel]>(request:ImageListRequest(), parser: ImageListParser())
        }
        
        static func imageConfig(url: String) -> RequestConfig<NetworkImageModel> {
            return RequestConfig<NetworkImageModel>(request:ImageRequest(url:url), parser: ImageParser())
        }
        
      
    }
    
}
