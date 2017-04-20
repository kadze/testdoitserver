//
//  Data.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
