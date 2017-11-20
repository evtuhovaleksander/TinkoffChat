//
//  ListOfPictures.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import Foundation

struct ImageList {
    let urls: [String] = []
}
class ImageListParser: Parser<[ImageList]> {
    func parse(data: Data) -> ImageList? {
        return ImageList()
    }
}
