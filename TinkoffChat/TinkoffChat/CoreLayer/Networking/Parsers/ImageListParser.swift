//
//  ListOfPictures.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

class ImageListParser: Parser<[ListImageModel]> {
    override func parse(data: Data) -> [ListImageModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String: AnyObject]] else {
                return nil
            }
            var urls: [ListImageModel] = []
            
            for hit in hits {
                if let url = hit["webformatURL"] as? String {
                    urls.append(ListImageModel(url: url))
                }
            }
            
            return urls
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
