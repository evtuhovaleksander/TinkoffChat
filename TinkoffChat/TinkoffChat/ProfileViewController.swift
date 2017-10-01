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

    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncName()
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
        let optionalButton = sender as? UIButton
        //force unwrap
        let button = optionalButton!
        //if unwrapping
        if let button2 = optionalButton {
            //code to do
        }
        //use guard
        guard let button3 = optionalButton else {
            return
        }
        //some code to do when button exists
        //
        //default value
        let button4: UIButton = optionalButton ?? UIButton()
        
    }
}
