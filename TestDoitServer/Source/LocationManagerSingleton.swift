//
//  LocationManagerSingleton.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

protocol LocationManagerSingletonStructDelegate {
    mutating func locationManagerSingleton(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]);
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error);
}

class LocationManagerSingleton : NSObject, CLLocationManagerDelegate {
    static let sharedInstance: LocationManagerSingleton = LocationManagerSingleton()
    let locationManager = CLLocationManager()
    var structDelegate: LocationManagerSingletonStructDelegate?  //only struct to avoid reference cycle
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func updateLocation() {
        let authorizaionStatus = CLLocationManager.authorizationStatus()
        
        switch authorizaionStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showAlertWithDeniedLocationAccess()
            
            return
        default:
            _ = 0
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            //
        }
    }
    
    //MARK:- CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        structDelegate?.locationManagerSingleton(manager, didUpdateLocations: locations);
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        structDelegate?.locationManager(manager, didFailWithError: error)
        /*If a location fix cannot be determined in a timely manner, the location manager calls the delegate’s locationManager(_:didFailWithError:) method instead and reports a locationUnknown error*/
    }
    
    func showAlertWithDeniedLocationAccess() {
        let alertController = UIAlertController(
            title: "Location Access Disabled",
            message: "In order to be able to get your current location, please open this app's settings and set location access to 'While in use'.",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        alertController.addAction(openAction)
        UIAlertController.viewControllerForPresentingAlert()?.present(alertController, animated: true, completion: nil)
    }
}
