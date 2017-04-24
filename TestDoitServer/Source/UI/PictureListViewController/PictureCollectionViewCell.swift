//
//  PictureCollectionViewCell.swift
//  TestDoitServer
//
//  Created by ASH on 4/23/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var weatherLabel: UILabel?
    @IBOutlet var addressLabel: UILabel?
    
    var model: ImageCollectionItem? {
        didSet {
            fillWithModel()
        }
    }
    
    func fillWithModel() {
        guard let imageView = imageView,
            let model = model else {
                return
        }
        
        if let image = model.image {
            imageView.image = image
        } else {
            model.imageSetHandler = {image in
                imageView.image = image
            }
            
            model.loadSmallImage()
        }
        
        weatherLabel?.text = model.weather
        addressLabel?.text = model.address
    }
    
    override func prepareForReuse() {
        weatherLabel?.text = nil
        addressLabel?.text = nil
        imageView?.image = nil
    }
}
