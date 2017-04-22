//
//  LoginContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpContext : NetworkContext {
    var dataTask: URLSessionDataTask?
    var user: User
    var successHandler: (() -> ())?
    var loginContext:LoginContext? {
        didSet {
            loginContext?.execute()
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    override func execute() {
        var request = self.request()
        
        guard let email = user.email,
            let password = user.password,
            let fileURL = user.imageURL,
            let image = user.image else {
                return
        }
        
        var parameters = ["email" : email,
                          "password" : password]
        
        if let username = user.userName {
            parameters["username"] = username
        }
        
        request = multipartURLRequest(with: request,
                                      parameters: parameters,
                                      filePathKey: "avatar",
                                      fileURL: fileURL,
                                      image: image)
        
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
    
    //MARK:-
    //MARK: Private
    
    private func handleResponseData(data: Data) {
        //logging
        if let answer = String(data: data, encoding: .utf8) {
            print(answer)
        }
        //
        let context = LoginContext(user: user)
        context.successHandler = successHandler
        loginContext = context
    }
}
