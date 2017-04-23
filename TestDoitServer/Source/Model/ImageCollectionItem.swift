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
    var image: UIImage?
    var address: String {
        get {
            if let latitude = latitude,
                let longitude = longitude {
                return "\(latitude); \(longitude)"
            }
            
            return "Unknown address"
        }
    }
    
    var weather: String?
    var smallImagePath: String?
    var bigImagePath: String?
    var longitude: String?
    var latitude: String?
}
