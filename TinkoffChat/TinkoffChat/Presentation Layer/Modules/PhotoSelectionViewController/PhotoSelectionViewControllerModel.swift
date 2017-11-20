//
//  PhotoSelectionViewControllerModel.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol ImageModelProtocol{
    var row:Int {get set}
    var url:URL {get set}
    var image:UIImage {get set}
    
    var urlImage:UIImage? {get set}
    var model:IPhotoSelectionViewControllerModel? {get set}
    var imageLoaded:Bool {get set}
    //var taskCreated:Bool {get set}
    func loadImage()
}

class ImageModel : ImageModelProtocol{
    
    var row: Int
    
    var imageLoaded:Bool
    
    var url: URL
    
    var image: UIImage{
        get{
            if imageLoaded {
                return urlImage ?? UIImage()
            } else{
                if(urlImage == nil){
                    urlImage = UIImage.init(named: "Photo") ?? UIImage()
                    loadImage()
                }
                return urlImage ?? UIImage()
            }
        }
        
        set{
            
        }
    }

    var urlImage:UIImage?
    var model: IPhotoSelectionViewControllerModel?
    
    init(row: Int,url: URL,model: IPhotoSelectionViewControllerModel?) {
        self.row = row
        self.url = url
        self.urlImage = nil
        self.model = model
        self.imageLoaded = false
    }
    
    func loadImage() {
        DispatchQueue.global(qos: .background).async {
            var i = arc4random_uniform(10)
            sleep(i)
            self.urlImage = UIImage.init(named: "wide") ?? UIImage()
            
            let cropped = self.cropImage(image: self.urlImage ?? UIImage())
           self.urlImage = cropped
//            let scaled=cropped.resizeImageWith(newSize: CGSize(width: cellSize, height: cellSize))
            
            
            self.model?.imageLoaded(row: self.row)
        }
    }
    
    func cropImage(image: UIImage) -> UIImage? {
        let cgImage :CGImage! = image.cgImage
        
        var rect:CGRect
        
        if(image.size.width>image.size.height){
            //shirokaya
            rect = CGRect(x: (image.size.width-image.size.height)/2, y: 0, width: image.size.height, height: image.size.height)
        }else{
            //uzkaya
            rect = CGRect(x: 0, y: (image.size.height-image.size.width)/2, width: image.size.width, height: image.size.width)
        }
        
        return image.crop(rect: rect)
        
    }
    
}

protocol PhotoSelectionViewControllerModelDelegate{
    func imageLoaded(row:Int)
    func imageListLoaded()
}

protocol IPhotoSelectionViewControllerModel{
    var images:[ImageModelProtocol] {get set}
    var delegate: PhotoSelectionViewControllerModelDelegate? {get set}
    func imageLoaded(row:Int)
    func getImageList()
}

class PhotoSelectionViewControllerModel:IPhotoSelectionViewControllerModel{
    var delegate: PhotoSelectionViewControllerModelDelegate?
    
    var images: [ImageModelProtocol] = []
    
    func imageLoaded(row: Int) {
        delegate?.imageLoaded(row: row)
    }
    
    func getImageList(){
        images = []
        for i in 0...50{
            let url = URL(fileURLWithPath: "")
            var im = ImageModel(row: i, url: url, model: self)
            images.append(im)
        }
        
        
        let requestConfig = RequestsFactory.ImageListRequests.newImageListConfig()
        
        
        RequestSender().send(config: requestConfig) { (result: Result<ImageList>) in
            
            switch result {
            case .Success(let apps):
                completionHandler(apps, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }}
        
        delegate?.imageListLoaded()
    }
    
    init() {
        
    }
    
    
}

