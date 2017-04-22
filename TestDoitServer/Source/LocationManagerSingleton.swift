//
//  LocationManagerSingleton.swift
//  TestDoitServer
//
//  Created by ASH on 4/22/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import CoreLocation

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
        if authorizaionStatus == .notDetermined {
            
        } else if (authorizaionStatus == .denied || authorizaionStatus == .restricted) {
            return
        }
        
        switch authorizaionStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            //alert that denied before (hipster example)
            return
        default:
            _ = 0
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            //maybe alert not enabled
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
}
