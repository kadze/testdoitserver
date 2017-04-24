//
//  PictureUploadModel.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct PictureUploadModel : LocationManagerSingletonStructDelegate {
    var image: UIImage? {
        didSet {
            if let imageSetHandler = imageSetHandler {
                imageSetHandler(image)
            }
        }
    }
    
    var locationManager = LocationManagerSingleton.sharedInstance
    
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
//    var uploadSuccessHandler:(() -> Void)?
    var uploadCompletionHandler:((Bool) -> Void)?
    
    var uploadingContext: PictureUploadContext? {
        didSet {
            oldValue?.cancel()
            uploadingContext?.execute()
        }
    }
    
    //MARK:- LocationManagerSingletonStructDelegate
    
    mutating func locationManagerSingleton(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            latitude = coordinate.latitude
            longitude = coordinate.longitude
            
            uploadWithContext()
        } else {
            //alert can't get it
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let _ = 1
        /*If a location fix cannot be determined in a timely manner, the location manager calls the delegate’s locationManager(_:didFailWithError:) method instead and reports a locationUnknown error*/
    }
    
    //MARK:- Public
    
    mutating func upload() {
        if longitude != nil, latitude != nil
        {
            uploadWithContext()
        } else {
            locationManager.structDelegate = self
            locationManager.updateLocation()
        }
    }
    
    //MARK:- Private

    private mutating func readImageCoordinates() {
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
    
    private mutating func uploadWithContext() {
        let context = PictureUploadContext(model:self, completionHandler: uploadCompletionHandler)
//        context.successHandler = uploadSuccessHandler
        
        uploadingContext = context
    }
}
