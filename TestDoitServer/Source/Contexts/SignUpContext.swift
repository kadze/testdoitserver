//
//  LoginContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class SignUpContext : NetworkContext {
    var dataTask: URLSessionDataTask?
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    override var httpMethod: String {
        get {
            return HTTPMethod.post
        }
        
        set {}
    }
    
    override func execute() {
        guard let requestBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options:[]) else {
            return
        }
        
        var request = self.request()
        request.httpBody = requestBody
        
        dataTask?.cancel()
        
        showNetworkActivityIndicator()
        
        dataTask = urlSession().dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                self.handleConnectionError(error: error)
            }
            
            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                if status == 400 {
                    print("incorrect request data")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                    }
                    
                    return
                } else if status == 201 {
                    print("user successfully created")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                        if let data = data {
                            self.handleResponseData(data: data)
                        }
                    }
                } else {
                    print("unknown status")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                    }
                }
            }
        })
        
        if let dataTask = dataTask {
            dataTask.resume()
        } else {
            hideNetworkActividyIndicator()
        }
    }

    override func cancel() {
        dataTask?.cancel()
    }

    override func urlStringForRequest() -> String {
        return "/create"
    }
    
    override func dictionaryForRequest() -> Dictionary<String, Any> {
        if let email = user.email,
            let password = user.password,
            let image = user.image {
            var result = ["email" : email,
                          "password" : password,
                          "avatar" : image] as [String : Any]
            if let userName = user.userName {
                result["username"] = userName
            }
            
            return result
        } else {
            return [:]
        }
    }
    
    //MARK:-
    //MARK: Private
    
    private func handleResponseData(data: Data) {
        //logging
        if let answer = String(data: data, encoding: .utf8) {
            print(answer)
        }
        //
    }
}
