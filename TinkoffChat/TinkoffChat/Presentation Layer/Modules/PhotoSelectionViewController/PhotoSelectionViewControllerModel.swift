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
    var url:String {get set}
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
    
    var url: String
    
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
    
    init(row: Int,url: String,model: IPhotoSelectionViewControllerModel?) {
        self.row = row
        self.url = url
        self.urlImage = nil
        self.model = model
        self.imageLoaded = false
    }
    
    func loadImage() {
        self.model?.imageLoaded(row: self.row)
        self.model?.manager?.getImage(forUrl: self.url, id: self.row)
//        DispatchQueue.global(qos: .background).async {
//            var i = arc4random_uniform(10)
//            sleep(i)
//            self.urlImage = UIImage.init(named: "wide") ?? UIImage()
//
//            let cropped = self.cropImage(image: self.urlImage ?? UIImage())
//           self.urlImage = cropped
////            let scaled=cropped.resizeImageWith(newSize: CGSize(width: cellSize, height: cellSize))
//
//
//            self.model?.imageLoaded(row: self.row)
        }
    }
    

    


protocol PhotoSelectionViewControllerModelDelegate{
    func imageLoaded(row:Int)
    func imageListLoaded()
}

protocol IPhotoSelectionViewControllerModel{
    var images:[ImageModelProtocol] {get set}
    var delegate: PhotoSelectionViewControllerModelDelegate? {get set}
    
    var manager:NetworkManager? {get set}
    
    func imageLoaded(row:Int)
    func getImageList()
}

class PhotoSelectionViewControllerModel:IPhotoSelectionViewControllerModel,NetworkManagerDelegate{

    
    func recievedList(urls: [String]) {
        images = []
        for i in 0..<urls.count{
            let url = urls[i]
            let im = ImageModel(row: i, url: url, model: self)
            images.append(im)
        }
        delegate?.imageListLoaded()
    }
    
    func recievedImage(image: UIImage, forID: Int) {
        
        self.images[forID].urlImage = image
        
        let cropped = self.cropImage(image: image)
       
        
        self.images[forID].urlImage = cropped
        imageLoaded(row: forID)
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
    
    var manager: NetworkManager?
    var delegate: PhotoSelectionViewControllerModelDelegate?
    
    var images: [ImageModelProtocol] = []
    
    func imageLoaded(row: Int) {
        delegate?.imageLoaded(row: row)
    }
    
    func getImageList(){
        manager?.getImageList()
    }
    
    init() {
        
    }
    
    
}

