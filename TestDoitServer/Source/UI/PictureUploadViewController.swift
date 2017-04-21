//
//  PictureUploadViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var chooseImageButton: UIButton?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var descriptionTextField: UITextField?
    @IBOutlet var tagTextField: UITextField?
    
    var chooseImageButtonTile: String?
    var imageURL: URL?
    var image: UIImage? {
        didSet {
            if let image = image {
                chooseImageButton?.setTitle(nil, for: .normal)
                imageView?.image = image
            } else {
                if let title = chooseImageButtonTile {
                    chooseImageButton?.setTitle(title, for: .normal)
                }
            }
        }
    }
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        return picker
    }()
    
    var uploadingContext: PictureUploadContext? {
        didSet {
            uploadingContext?.execute()
        }
    }
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(PictureUploadViewController.uploadImage))
        
        chooseImageButtonTile = chooseImageButton?.title(for: .normal)
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerReferenceURL] as? URL
        {
            image = pickedImage
            imageURL = url
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func onChooseImageButton(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImage() {
        let context = PictureUploadContext()
        context.successHandler = {[unowned self] in
            self.dismiss(animated: true, completion: nil)
        }
        
//        uploadingContext = context
    }
}
