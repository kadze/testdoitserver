//
//  DoitServerAPI.swift
//  TestDoitServer
//
//  Created by ASH on 9/28/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import Foundation
import Moya

enum DoitServerAPI {
    case login(email: String, password: String)
}

extension DoitServerAPI : TargetType {
    var baseURL: URL {
        return URL(string: "http://api.doitserver.in.ua")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
//        case .settingsFor(let cameraId):
//            return "/cameras/\(cameraId)/settings"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email" : email, "password" : password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-type": "application/json", "Accept" : "application/json"]
        }
    }
    
}
