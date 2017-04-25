//
//  GifViewController.swift
//  TestDoitServer
//
//  Created by ASH on 4/25/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

import CoreGraphics
import ImageIO
import MobileCoreServices

class GifViewController: UIViewController {

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
    
    //method by the task
    //the method returns a link to the GIF image consisting of the last 5 uploaded images;
    
    func generateGIF(with images: [UIImage], loopCount: Int = 0, frameDelay: Double, callback: (URL?, NSError?) -> ()) {
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
        
        let documentsDirectory = NSTemporaryDirectory()
        let cfurl = CFURLCreateWithFileSystemPath(nil, documentsDirectory as CFString, .cfurlposixPathStyle, true)
        guard let url = CFURLCreateCopyAppendingPathComponent(nil, cfurl, "animated.gif" as CFString, false) else {return}
        
        let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
        
        CGImageDestinationSetProperties(destination!, fileProperties as CFDictionary)
        
        for i in 0..<images.count {
            CGImageDestinationAddImage(destination!, images[i].cgImage!, frameProperties as CFDictionary)
        }
        
        if CGImageDestinationFinalize(destination!) {
            callback(url as URL,nil)
        } else {
            callback(nil, NSError(domain: "createGIF", code: 0, userInfo: nil))
        }
    }
}
