//
//  ImageUploadModel.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct ImageUploadModel {
    var image: UIImage? {
        didSet {
            if let imageSetHandler = imageSetHandler {
                imageSetHandler(image)
            }
        }
    }
    
    var imageFileURL: URL? {
        didSet {
            readImageCoordinates()
        }
    }
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
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
    
    mutating func readImageCoordinates() {
        guard let assetUrl = imageFileURL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil).firstObject else {
                return
        }
        
        if let location = asset.location {
            let coordinate = location.coordinate
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        }
    }
}
 
