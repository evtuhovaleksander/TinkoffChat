//
//  JSONManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 23/10/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation


class jsonManager{
    
    static func dictTojson(jsonObject: [String: Any])->Data{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
    
    static func jsonToDictionary(data:Data) -> [String: String] {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? [String: String])!
            } catch {
                print(error.localizedDescription)
            }
        return [:]
    }
    
    static func generateMessageID()->String{
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    static func makeMessage(string:String)->Data{
        let message = ["eventType": "TextMessage",
        "messageId": generateMessageID(),
        "text": string]
        
        return dictTojson(jsonObject: message)
    }
    static func readMessage(data:Data)->String{
        return jsonToDictionary(data: data)["text"]!
    }
    
}
