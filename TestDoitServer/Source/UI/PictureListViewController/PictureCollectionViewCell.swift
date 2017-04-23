//
//  PictureCollectionViewCell.swift
//  TestDoitServer
//
//  Created by ASH on 4/23/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    var model: ImageCollectionItem? {
        didSet {
            fillWithModel()
        }
    }
    
    func fillWithModel() {
        
    }

}
