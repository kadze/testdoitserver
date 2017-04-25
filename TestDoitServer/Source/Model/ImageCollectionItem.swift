//
//  ImageCollectionItem.swift
//  TestDoitServer
//
//  Created by ASH on 4/23/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionItem {
    var image: UIImage? {
        didSet {
            if let handler = imageSetHandler {
                handler(image)
            }
        }
    }
    
    var imageSetHandler: ((UIImage?) -> ())?
    
    var address: String?
    var weather: String?
    var smallImagePath: String?
    var bigImagePath: String?
    var longitude: String?
    var latitude: String?
    
    var smallImageLoadingContext: PictureDownloadContext? {
        didSet {
            smallImageLoadingContext?.execute()
        }
    }
    
    //MARK:- Public
    
    func loadSmallImage() {
        if let smallImagePath = smallImagePath,
            let url = URL(string: smallImagePath) {
            smallImageLoadingContext = PictureDownloadContext(url: url, completionHandler: {[unowned self] (image) in
                self.image = image
            })
        }
    }
}
