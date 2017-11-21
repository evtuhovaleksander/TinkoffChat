//
//  PhotoSelectionViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 19.11.2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

protocol IPhotoSelectionViewControllerDelegate{
    func userSelectedPicture(image:UIImage)
    func userCanceled()
}

class PhotoSelectionViewController: UIViewController, UICollectionViewDataSource,PhotoSelectionViewControllerModelDelegate {

    var model:IPhotoSelectionViewControllerModel
    var delegate:IPhotoSelectionViewControllerDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    init(model:IPhotoSelectionViewControllerModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       return nil
    }
    
    var cellSize = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "PhotoSelectionCell", bundle: nil), forCellWithReuseIdentifier: "PhotoSelectionCell" )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let totalSpace = UIScreen.main.bounds.size.width
        let size = totalSpace/3.1
        cellSize = Double(size)
        let space = (totalSpace - size*3)/4
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = CGSize(width: size, height: size);
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        
        collectionView.reloadData()
        activity.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activity.startAnimating()
        model.getImageList()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectionCell", for: indexPath) as! PhotoSelectionCell)
        print(indexPath.row)
        var im:UIImage = model.images[indexPath.row].image

//        im = cropImage(image: im)!

        im=im.resizeImageWith(newSize: CGSize(width: cellSize, height: cellSize))
        
        cell.image.image = im
        return cell
        
        
        
    }
    
 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func cropImage(image: UIImage) -> UIImage? {
//        let cgImage :CGImage! = image.cgImage
//
//        var rect:CGRect
//
//        if(image.size.width>image.size.height){
//            //shirokaya
//            rect = CGRect(x: (image.size.width-image.size.height)/2, y: 0, width: image.size.height, height: image.size.height)
//        }else{
//            //uzkaya
//            rect = CGRect(x: 0, y: (image.size.height-image.size.width)/2, width: image.size.width, height: image.size.width)
//        }
//
//        return image.crop(rect: rect)
//
//    }
    
    

    

    
    
    func imageLoaded(row: Int) {
        DispatchQueue.main.async {
            let ip = IndexPath(row: row, section: 0)
            self.collectionView.reloadItems(at: [ip])
        }
    }
    
    func imageListLoaded() {
        DispatchQueue.main.async {
            self.activity.stopAnimating()
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let image = model.images[index].image
        delegate?.userSelectedPicture(image: image)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoSelectionViewController : UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let totalSpace = self.view.window?.frame.size.width
//                let size = totalSpace!/3.3
//                return CGSize(width: size, height: size);
//    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {

        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    
}
