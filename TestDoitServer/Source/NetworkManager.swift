//
//  PBNetworkManager.swift
//  Prostoy
//
//  Created by ASH on 3/23/17.
//  Copyright © 2017 lexin. All rights reserved.
//

import UIKit

class NetworkManager: NSObject, URLSessionDelegate {
    static let sharedInstance = NetworkManager()
    
    static let defaultConfiguration = URLSessionConfiguration.default
    static let ephemeralConfiguration = URLSessionConfiguration.ephemeral
    static let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "ru.prostoy.networking.background")
    
    let defaultSession = URLSession(configuration: defaultConfiguration, delegate: nil, delegateQueue: nil)
    let ephemeralSession = URLSession(configuration: ephemeralConfiguration, delegate: nil, delegateQueue: nil)
    let backgroundSession = URLSession(configuration: backgroundConfiguration, delegate: nil, delegateQueue: nil)
}
