//
//  LoginViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/19/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
    
    var user: User
    
    var mode = Mode.login {
        didSet {
            self.changeAppearanceForCurrentMode()
        }
    }
    
    var loginContext: LoginContext? {
        didSet {
            loginContext?.execute()
        }
    }
    
    var signUpContext: SignUpContext? {
        didSet {
            signUpContext?.execute()
        }
    }
    
    //MARK: Initializations and Deallocations
    
    init(_ user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @IBAction  func onSendButton(_ sender: UIButton) {
        user.email = emailTextfield?.text;
        user.password = passwordTextfield?.text;
        switch mode {
        case .signUp:
            user.userName = usernameTextfield?.text;
            signUpContext = SignUpContext(user: user)
        case .login:
            loginContext = LoginContext(user: user)
        }
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
