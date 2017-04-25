//
//  TempViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/25/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    var images: [UIImage]?
    @IBOutlet var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageView = imageView,
            let images = images
        {
            imageView.animationImages = images
            imageView.animationDuration = TimeInterval(images.count) * 0.3
            imageView.startAnimating()
        }
    }
}
