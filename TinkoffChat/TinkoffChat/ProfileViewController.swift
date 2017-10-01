//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var makePhotoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncName()
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

    @IBAction func editAction(_ sender: Any) {
       
    }
}
