//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var downConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var gcdButton: UIButton!
    
    @IBOutlet weak var operationButton: UIButton!
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var makePhotoButton: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    
    var profile:Profile = Profile.getEmptyProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        set delegates
        picker!.delegate = self
        nameTextField.delegate = self
        infoTextView.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: self.keyboardWillShow)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: self.keyboardWillHide)


        
//      setup corner radius
        photoImageView.layer.cornerRadius = 50
        makePhotoButton.layer.cornerRadius = 50
        let offsetConstant = CGFloat(20)
        makePhotoButton.imageEdgeInsets = UIEdgeInsetsMake(offsetConstant, offsetConstant, offsetConstant, offsetConstant)
        photoImageView.clipsToBounds = true
        makePhotoButton.clipsToBounds = true
        
        activity.hidesWhenStopped = true
        
//      setup data
        loadDataFromProfile()
        //setSaveButtonsAvalibleState()
        //self.profile.avatar = self.photoImageView.image!
        //saveProfile()
        
//      setup UI
        setupButton(button: gcdButton)
        setupButton(button: operationButton)
        setupView(view: infoTextView, radius: 10)
        setupView(view: activity, radius: Float(activity.bounds.size.width/2.0))
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GCDTaskManager().readProfile(controller: self)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification: Notification) -> Void {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            downConstraint.constant = keyboardHeight
            
            scrollView.contentOffset.y = 300
        }
    }
    
    func keyboardWillHide(notification: Notification) -> Void {
            downConstraint.constant = 0
    }
    
    func setupButton(button : UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = CGFloat(10)
        button.clipsToBounds = true
    }
    
    func setupView(view : UIView,radius : Float){
        view.layer.cornerRadius = CGFloat(radius)
        view.clipsToBounds = true
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
        profile.newAvatar = image
        loadDataFromProfile()
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadDataFromProfile(){
        photoImageView.image = profile.avatar
        nameTextField.text = profile.name
        infoTextView.text = profile.info
        setSaveButtonsAvalibleState()
    }
    
    func setSaveButtonsAvalibleState(){
        if(profile.needSave){
            gcdButton.isEnabled = true
            operationButton.isEnabled = true
            gcdButton.backgroundColor = .green
            operationButton.backgroundColor = .green
        }
        else{
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
            gcdButton.backgroundColor = .red
            operationButton.backgroundColor = .red
        }
    }
    

    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        textField.resignFirstResponder()
//        return true
//    }
    
    

    
    
    @IBAction func nameChanged(_ sender: Any) {
        profile.newName = nameTextField.text!
        setSaveButtonsAvalibleState()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        profile.newInfo = infoTextView.text!
        setSaveButtonsAvalibleState()
    }
    
    
    
    @IBAction func gcdSaveAction(_ sender: Any) {
        GCDTaskManager().saveProfile(controller: self)
        //profile.saveProfile()
        //profile = Profile.getProfile()
        //loadDataFromProfile()
    }
    
    @IBAction func operationSaveAction(_ sender: Any) {
        profile.saveProfile()
        profile = Profile.getProfile()
        loadDataFromProfile()
    }
    
    func activityStartAnimate(){
        activity.isHidden=false
        activity.startAnimating()
        activity.hidesWhenStopped = true
    }
    func activityStopAnimate(){
        activity.isHidden=true
        activity.hidesWhenStopped = true
        activity.stopAnimating()
    }
    
}


protocol ProfileProtocol : class{
    var name:String {get set}
    var info:String {get set}
    var avatar:UIImage {get set}
    var needSave:Bool {get set}
}

class Profile : NSObject, NSCoding, ProfileProtocol{
    
    var newName: String{
        didSet{
           needSave = (newName != name)
        }
    }
    
    var name: String
    
    var newInfo: String{
        didSet{
            needSave = (newInfo != info)
        }
    }
    var info: String
    
    var newAvatar: UIImage{
        didSet{
                needSave = (newAvatar != avatar)
        }
    }
    
    var avatar: UIImage
    
    var needSave: Bool
    
    public static func getProfile()->Profile{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
        if let simpleData:Data = try? Data(contentsOf: fileURL) {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: simpleData)
            if let profile = decodedData as? Profile{
                return profile
            }
        }
        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
    }
    
    static func getEmptyProfile()->Profile{
        return Profile(name: "",info: "",avatar: UIImage.init(named: "EmptyAvatar")!,needSave: false)
    }
    
    init(name: String, info: String, avatar : UIImage, needSave : Bool) {
        self.name = name
        self.newName = name
        self.info = info
        self.newInfo = info
        self.avatar = avatar
        self.newAvatar = avatar
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
    
    func saveProfile()->String?{
        self.needSave = false
        
        avatar = newAvatar
        name = newName
        info = newInfo
        
        
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf"){
            do {
                let data = NSKeyedArchiver.archivedData(withRootObject: self)
                try data.write(to: fileURL)
                if( Int(arc4random_uniform(2))==1){
                    return nil
                    
                }else{
                    return "generated error"
                    
                }
            } catch let error {
                print(error.localizedDescription)
                return error.localizedDescription
            }
        }
        
        
        return "can't get path"
    }
}


//    func testProfile(){
//
//        profile.needSave = true
//
//        //if(profile.needSave){
//        profile.name = "mame"
//        profile.info = "info"
//        profile.avatar = UIImage.init(named: "Photo")!
//            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("profile.prf")
//
//            let data = NSKeyedArchiver.archivedData(withRootObject: profile)
//
//            do {
//                try data.write(to: fileURL)
//            } catch {
//                print("Couldn't write file")
//            }
//        if let d1:Data = try? Data(contentsOf: fileURL) {
//        //let d1:Data = Data(contentsOf: fileURL)
//        let d2 = NSKeyedUnarchiver.unarchiveObject(with: d1)
//            let d3 = d2 as! Profile
//            loadDataFromProfile()}
//    }


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
