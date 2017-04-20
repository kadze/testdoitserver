//
//  LoginViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/19/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    struct Constants {
        static let loginTitle = "Log in"
        static let singupTitle = "Sign up"
    }
    
    enum Mode {
        case login
        case signUp
    }
    
    @IBOutlet var sendButton: UIButton?
    @IBOutlet var modeSwithButton: UIButton?
    @IBOutlet var chooseImageButton: UIButton?
    @IBOutlet var usernameTextfield: UITextField?
    @IBOutlet var emailTextfield: UITextField?
    @IBOutlet var passwordTextfield: UITextField?
    
    var mode = Mode.login {
        didSet {
            self.changeAppearanceForCurrentMode()
        }
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let button = chooseImageButton {
            button.layer.cornerRadius = button.frame.size.height / 2
        }
        
        changeAppearanceForCurrentMode()
    }
    
    //MARK: Actions
    
    @IBAction func onModeSwitchButton(_ sender: UIButton) {
        mode = (mode == .login) ? .signUp : .login;
    }

    //MARK: Private
    
    private func changeAppearanceForCurrentMode() {
        chooseImageButton?.isHidden = !(mode == .signUp)
        usernameTextfield?.isHidden = !(mode == .signUp)
        switch mode {
        case .login:
            sendButton?.setTitle(Constants.loginTitle, for: .normal)
            modeSwithButton?.setTitle(Constants.singupTitle, for: .normal)
        case .signUp:
            sendButton?.setTitle(Constants.singupTitle, for: .normal)
            modeSwithButton?.setTitle(Constants.loginTitle, for: .normal)
        }
    }

}
