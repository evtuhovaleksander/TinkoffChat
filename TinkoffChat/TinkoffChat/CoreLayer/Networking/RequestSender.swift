//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation


protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
struct RequestConfig<T> {
    let request: IRequest
    let parser: Parser<T>
}

enum Result<T> {
    case success(T)
    case error(String)
}


protocol IRequestSender {
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
}

class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void) {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error.localizedDescription))
                return
            }
            guard let data = data,
                let parsedModel: T = config.parser.parse(data: data) else {
                    completionHandler(Result.error("recieved data can't be parsed"))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
