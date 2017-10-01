//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var makePhotoButton: UIButton!

    var picker:UIImagePickerController?=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncName()
        picker!.delegate = self
        
        
//      setup corner radius
        photoImageView.layer.cornerRadius = 50
        makePhotoButton.layer.cornerRadius = 50
        let offsetConstant = CGFloat(20)
        makePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(offsetConstant, offsetConstant, offsetConstant, offsetConstant)
        photoImageView.clipsToBounds = true
        makePhotoButton.clipsToBounds = true
//      setup data
        nameLabel.text = "Alex Dark"
        infoLabel.text = "Hello! I'm Alex Dark, and you can be my best friend!"
//      setup button
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.cornerRadius = CGFloat(10)
        editProfileButton.clipsToBounds = true
        
//      попытка распечатать свойсво кнопки в методе инит - приведет к ошибке
//      так как в методе инит самой кнопки пока еще не существует
//      кнопка будет создана во viewDidLoad
//      поэтому тут мы можем смотреть на свойства кнопки
//      тут ее размер будет равен тому который был в сториборде
//      так как ее просто создали и присвоили размер
//      адаптивная верстка происходит на этапе layoutSubviews
//      тоесть констрейнты будут применяться  позже
//      поэтому итоговый размер кнопки надо смотреть в методе viewDidLayoutSubviews
        print(editProfileButton.frame.size)
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printFuncName()
//      теперь ко всем элементам уже применены констрейнты
//      размеры элементов изменены
//      теперь мы можем посмотреть конечный размер кнопки на экране телефона
        print(editProfileButton.frame.size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printFuncName()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printFuncName()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printFuncName()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printFuncName()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printFuncName()
    }

    func printFuncName(name: String = #function) {
        print(name)
    }

    @IBAction func editAction(_ sender: Any) {
       print("edit button pressed")
    }
    
    @IBAction func getProfileImage(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let saveAction = UIAlertAction(title: "Galery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func openGallary()
    {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = image
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
