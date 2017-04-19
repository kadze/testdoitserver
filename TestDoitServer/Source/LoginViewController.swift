//
//  LoginViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/19/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
}
