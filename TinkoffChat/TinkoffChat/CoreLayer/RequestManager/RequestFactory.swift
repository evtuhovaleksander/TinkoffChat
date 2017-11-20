//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct ImageListRequests {
        
        static func newImageListConfig() -> RequestConfig<ImageList> {
            return RequestConfig<ImageList>(request:ImageListRequest(), parser: ImageListParser())
        }}}
