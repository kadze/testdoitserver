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
    let appDelegate: AppDelegate  //singleton property for testing purposes
    
    init(user: User, appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate) {
        self.appDelegate = appDelegate
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
                DispatchQueue.main.async {
                    self.hideNetworkActividyIndicator()
                    if status == 200 {
                        print("user successfully logged in")
                        if let data = data {
                            self.handleResponseData(data: data)
                        }
                    } else  {
                        if status == 400 {
                            print("incorrect request data")
                        } else {
                            print("unknown status")
                        }
                        
                        self.unsuccessOperationAlert()
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
                appDelegate.user = user
                if let successHandler = successHandler {
                    successHandler()
                }
            }
        } catch  {
            print("Error reading response data Json: \(error)")
        }
    }
}
