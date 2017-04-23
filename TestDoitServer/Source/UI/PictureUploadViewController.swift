//
//  PictureUploadViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import CoreLocation

class PictureUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    let statusBarHeight: CGFloat = 20
    let navigationBarHeight: CGFloat = 44
    
    @IBOutlet var chooseImageButton: UIButton?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var descriptionTextField: UITextField?
    @IBOutlet var tagTextField: UITextField?
    @IBOutlet var topImageViewConstraint: NSLayoutConstraint?
    @IBOutlet var topButtonConstraint: NSLayoutConstraint?
    
    var topConstraintConstant: CGFloat?
    
    lazy var pictureUploadMoldel: PictureUploadModel = {
        var model = PictureUploadModel()
        model.imageSetHandler = {[unowned self] (image: UIImage?) in
            if let image = image {
                self.chooseImageButton?.setTitle(nil, for: .normal)
                self.imageView?.image = image
            } else {
                if let title = self.chooseImageButtonTile {
                    self.chooseImageButton?.setTitle(title, for: .normal)
                }
            }
        }
        
        return model
    }()
    
    var chooseImageButtonTile: String?
    var imageURL: URL?
    var image: UIImage?
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        return picker
    }()
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(PictureUploadViewController.uploadImage))
        
        chooseImageButtonTile = chooseImageButton?.title(for: .normal)
        
        if topConstraintConstant == nil {
            topConstraintConstant = topImageViewConstraint?.constant
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeForKeyboardNotifications()
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerReferenceURL] as? URL
        {
            pictureUploadMoldel.image = pickedImage
            pictureUploadMoldel.imageFileURL = url
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK:- Actions
    
    @IBAction func onChooseImageButton(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImage() {
        guard let _ = pictureUploadMoldel.image else {
            return
        }
        
        pictureUploadMoldel.hashtag = tagTextField?.text
        pictureUploadMoldel.imageDescription = descriptionTextField?.text
        pictureUploadMoldel.uploadSuccessHandler = {[unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        pictureUploadMoldel.upload()
    }
    
    //MARK:- Keyboard Handling
    
    private func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let field = tagTextField,
//            let constraint1 = topImageViewConstraint,
//            let constraint2 = topButtonConstraint,
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        {
            let fieldBottomY = field.frame.maxY
            let keyboardTopY = keyboardRect.minY
            let delta = keyboardTopY - fieldBottomY - statusBarHeight - navigationBarHeight
            if delta < 0 {
                UIView.animate(withDuration: duration) { [unowned self] in
                    self.topImageViewConstraint?.constant += delta
                    self.topButtonConstraint?.constant += delta
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        if let constraint = centerYConstraint {
//            if let userInfo = notification.userInfo,
//                let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
//            {
//                UIView.animate(withDuration: duration, animations: {
//                    constraint.constant = 0
//                    self.view.layoutIfNeeded()
//                })
//            }
//        }
        if let constraint1 = topImageViewConstraint,
            let constraint2 = topButtonConstraint,
            let constant = topConstraintConstant
        {
            constraint1.constant = constant
            constraint2.constant = constant
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func unsubscribeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
}
