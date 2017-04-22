//
//  ImageUploadModel.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit

struct ImageUploadModel {
    var image: UIImage? {
        didSet {
            if let imageSetHandler = imageSetHandler {
                imageSetHandler(image)
            }
        }
    }
    
    var imageFileURL: URL?
    var latitude: Float?
    var longiture: Float?
    var imageDescription: String?
    var hashtag: String?
    var imageSetHandler:((UIImage?) -> Void)?
    var uploadSuccessHandler:(() -> Void)?
    
    var uploadingContext: PictureUploadContext? {
        didSet {
            uploadingContext?.execute()
        }
    }
    
    mutating func upload() {
        let context = PictureUploadContext()
        context.successHandler = uploadSuccessHandler
        
//        uploadingContext = context
    }
}
