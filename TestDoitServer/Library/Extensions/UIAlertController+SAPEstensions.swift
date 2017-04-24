//
//  UIAlertController+SAPEstensions.swift
//  TestDoitServer
//
//  Created by ASH on 4/24/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func viewControllerForPresentingAlert() -> UIViewController? {
        var controller = UIApplication.shared.keyWindow?.rootViewController
        while controller != nil, controller?.presentedViewController != nil {
            controller = controller?.presentedViewController
        }
        
        return controller
    }
}
