//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var gcdButton: UIButton!
    
    @IBOutlet weak var operationButton: UIButton!
    
    
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var makePhotoButton: UIButton!

    var picker:UIImagePickerController?=UIImagePickerController()
    
    var profile:Profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        настраиваем пикер
        picker!.delegate = self
        
//      setup corner radius
        photoImageView.layer.cornerRadius = 50
        makePhotoButton.layer.cornerRadius = 50
        let offsetConstant = CGFloat(20)
        makePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(offsetConstant, offsetConstant, offsetConstant, offsetConstant)
        photoImageView.clipsToBounds = true
        makePhotoButton.clipsToBounds = true
        
        
//      setup data
        //self.profile.avatar = self.photoImageView.image!
        //saveProfile()
        
//      setup UI
        setupButton(button: gcdButton)
        setupButton(button: operationButton)
        setupView(view: infoTextView)
    }
    
    func setupButton(button : UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = CGFloat(10)
        button.clipsToBounds = true
    }
    
    func setupView(view : UIView){
        view.layer.cornerRadius = CGFloat(10)
        view.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printFuncName()
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

    
    @IBAction func getProfileImage(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Выбери источник картинки", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Камера", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        
        let saveAction = UIAlertAction(title: "Галерея", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
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
            let alert = UIAlertController(title: "Нет камеры", message: "На этом устройстве нет камеры", preferredStyle: .alert)
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
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func testProfile(){
        
        profile.needSave = true
        
        //if(profile.needSave){
        profile.name = "mame"
        profile.info = "info"
        profile.avatar = UIImage.init(named: "Photo")!
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
            
            let data = NSKeyedArchiver.archivedData(withRootObject: profile)
            
            do {
                try data.write(to: fileURL)
            } catch {
                print("Couldn't write file")
            }
        
        
        if let d1:Data = try? Data(contentsOf: fileURL) {
        //let d1:Data = Data(contentsOf: fileURL)
        let d2 = NSKeyedUnarchiver.unarchiveObject(with: d1)
            let d3 = d2 as! Profile

        
            loadDataFromProfile()}
        
    }
    
    func loadDataFromProfile(){
        photoImageView.image = profile.avatar
        nameTextField.text = profile.name
        infoTextView.text = profile.info
    }
}


protocol ProfileProtocol : class{
    var name:String {get set}
    var info:String {get set}
    var avatar:UIImage {get set}
    var needSave:Bool {get set}
}

class Profile : NSObject, NSCoding, ProfileProtocol{
    
    var name: String{
        willSet{
            if(newValue != name){
                needSave = true
            }
        }
    }
    
    var info: String{
        willSet{
            if(newValue != info){
                needSave = true
            }
        }
    }
    
    var avatar: UIImage{
        willSet{
            if(newValue != avatar){
                needSave = true
            }
        }
    }
    
    var needSave: Bool
    
    override init() {
        name = ""
        info = ""
        avatar = UIImage.init(named: "EmptyAvatar")!
        needSave = true
    }
    
    init(name: String, info: String, avatar : UIImage, needSave : Bool) {
        self.name = name
        self.info = info
        self.avatar = avatar
        self.needSave = needSave
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: aDecoder.decodeObject(forKey: "name") as! String,
            info: aDecoder.decodeObject(forKey: "info") as! String,
            avatar: Profile.base64ImageStringToUIImage(base64String: aDecoder.decodeObject(forKey: "avatar") as! String),
            needSave: false
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(avatarToBase64ImageString(), forKey: "avatar")
    }
    
    static func base64ImageStringToUIImage(base64String:String)->UIImage{
        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        return UIImage(data: dataDecoded)!
    }
    
    func avatarToBase64ImageString()->String{
        let jpegCompressionQuality: CGFloat = 1
        return (UIImageJPEGRepresentation(avatar, jpegCompressionQuality)?.base64EncodedString())!
    }
    
    func loadProfile(){
        
    }
    
    func saveProfile(){
        
    }
}


//    func test(){
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
//
//        let jpegCompressionQuality: CGFloat = 0.9 // Set this to whatever suits your purpose
//        guard let base64String = UIImageJPEGRepresentation(self.profile.avatar, jpegCompressionQuality)?.base64EncodedString() else {
//            return
//        }
//
//        print(base64String)
//
//
//        let dataDecoded : Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
//        let decodedimage = UIImage(data: dataDecoded)
//    }

//    func saveGame(notification: NSNotification) {
//        let saveData = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: saveData)
//
//        archiver.encode(player.name, forKey: "name")
//        archiver.encode(player.score, forKey: "score")
//        archiver.finishEncoding()
//
//        let saveLocation = saveFileLocation()
//        _ = saveData.write(to: saveLocation, atomically: true)
//    }
//    func loadGame() {
//        let saveLocation = saveFileLocation()
//        if let saveData = try? Data(contentsOf: saveLocation) {
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: saveData)
//            player.name = unarchiver.decodeObject(forKey: "name") as! String
//            player.score = unarchiver.decodeInteger(forKey: "score")
//            unarchiver.finishDecoding()
//        }
//    }
