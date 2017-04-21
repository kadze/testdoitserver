//
//  LoginContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class LoginContext : NetworkContext {
    var dataTask: URLSessionDataTask?
    var user: User
    var successHandler: (() -> ())?
    
    init(user: User) {
        self.user = user
    }
    
    override func execute() {
        guard let requestBody = try? JSONSerialization.data(withJSONObject: requestDictionary, options:[]) else {
            return
        }
        
        var request = self.request()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
                } else if status == 200 {
                    print("user successfully logged in")
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
        return "/login"
    }
    
    override func dictionaryForRequest() -> Dictionary<String, Any> {
        if let email = user.email,
            let password = user.password {
            return ["email" : email,
                    "password" : password]
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
            
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject] ,
                let token = json["token"] as? String
            {
                user.token = token
                if let successHandler = successHandler {
                    successHandler()
                }
            }
        } catch  {
            print("Error reading response data Json: \(error)")
        }
    }
}
