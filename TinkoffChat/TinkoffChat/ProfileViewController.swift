//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Aleksander Evtuhov on 20/09/2017.
//  Copyright © 2017 Aleksander Evtuhov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        printFuncName()
        //view.backgroundColor = .green
        // Do any additional setup after loading the view, typically from a nib.
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
}
