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

    @IBOutlet var imageView: UIImageView?
    
    var images: [UIImage]?
    let gifFrameDelay: TimeInterval = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageView = imageView,
            let images = images
        {
            
            //this is an easier way to show animated images
            /*
            imageView.animationImages = images
            imageView.animationDuration = TimeInterval(images.count) * 0.3
            imageView.startAnimating()
            */
            
            //this is the way by the technical task
            
            generateGIF(with: images, frameDelay: gifFrameDelay, callback: { (url, error) in
                if let url = url {
                    let gif = UIImage.gif(url: url.absoluteString)
                    imageView.image = gif
                }
            })
        }
    }
    
    //method by the task
    //the method returns a link to the GIF image consisting of the last 5 uploaded images;
    
    func generateGIF(with images: [UIImage], loopCount: Int = 0, frameDelay: Double, callback: (URL?, NSError?) -> ()) {
        let gifFileName = "animated.gif"
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: loopCount]]
        let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDelay]]
        
        let documentsDirectory = NSTemporaryDirectory()
        let cfurl = CFURLCreateWithFileSystemPath(nil, documentsDirectory as CFString, .cfurlposixPathStyle, true)
        guard let url = CFURLCreateCopyAppendingPathComponent(nil, cfurl, gifFileName as CFString, false) else {return}
        
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
