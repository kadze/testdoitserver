//
//  LoginViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/19/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        return picker
    }()
    
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
    
    //MARK:- Initializations and Deallocations
    
    init(_ user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let button = chooseImageButton {
            button.layer.cornerRadius = button.frame.size.height / 2
        }
        
        changeAppearanceForCurrentMode()
        present(UINavigationController(rootViewController: PictureListViewController(user)), animated: true, completion: nil)
        
        //WARNING: develop code
        emailTextfield?.text = "a@gmail.com"
        passwordTextfield?.text = "123456"
    }
    
    //MARK: Actions
    
    @IBAction func onModeSwitchButton(_ sender: UIButton) {
        mode = (mode == .login) ? .signUp : .login;
    }
    
    @IBAction  func onSendButton(_ sender: UIButton) {
        user.email = emailTextfield?.text;
        user.password = passwordTextfield?.text;
        
        let successHandler = {[unowned self] in
            let navigationController = UINavigationController(rootViewController: PictureListViewController(self.user))
            self.present(navigationController, animated: true, completion: nil)
        }
        
        switch mode {
        case .signUp:
            user.userName = usernameTextfield?.text;
            let context = SignUpContext(user: user)
            context.successHandler = successHandler
            signUpContext = context
        case .login:
            let context = LoginContext(user: user)
            context.successHandler = successHandler
            loginContext = context
        }
    }
    
    @IBAction func onChooseImageButton(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerReferenceURL] as? URL
        {
            user.image = image
            user.imageURL = url
            chooseImageButton?.setBackgroundImage(image, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Private
    
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
    
    private func presentPictureListController() {
        let navigationController = UINavigationController(rootViewController: PictureListViewController(self.user))
        self.present(navigationController, animated: true, completion: nil)
    }
}
