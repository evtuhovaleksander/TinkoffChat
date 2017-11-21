//
//  NetworkManager.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 21.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

struct ListImageModel{
    let url:String
}

struct NetworkImageModel{
    let image:UIImage
}

protocol NetworkManagerDelegate{
    func recievedList(urls:[String])
    func recievedImage(image:UIImage, forID:Int)
}

protocol INetworkManager{
    var requestSender:RequestSender {get set}
    var delegate : NetworkManagerDelegate? {get set}
    
    
    func getImageList()
    func getImage(forUrl:String,id:Int)
}



class NetworkManager:INetworkManager{
    var requestSender = RequestSender()
    var delegate : NetworkManagerDelegate?
    
    init(delegate : NetworkManagerDelegate){
        self.delegate = delegate
        self.requestSender = rootAssembly.requestSender
    }
    
    func getImageList(){
        let config = RequestsFactory.NetworkRequests.listImagesConfig()
        requestSender.send(config: config, completionHandler: {(result: Result<[ListImageModel]>) in
            switch result {
            case .success(let apps):
                var array=[String]()
                for i in apps{
                    array.append(i.url)
                }
                self.delegate?.recievedList(urls: array)
            case .error(let error):
                print(error)
            }
        })
    }
    
    func getImage(forUrl:String,id:Int){
        let config = RequestsFactory.NetworkRequests.imageConfig(url: forUrl)
        requestSender.send(config: config, completionHandler: {(result: Result<NetworkImageModel>) in
            switch result {
            case .success(let apps):
                self.delegate?.recievedImage(image: apps.image, forID: id)
            case .error(let error):
                print(error)
            }
        })
    }
    
}
