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
        imageView?.image = model?.image
        weatherLabel?.text = model?.weather
        addressLabel?.text = model?.address
    }
}
