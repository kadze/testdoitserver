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
                let alert = UIAlertController(title: "Fill required fields", message: "image, email and password are required fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                UIAlertController.viewControllerForPresentingAlert()?.present(alert, animated: true, completion: nil)
                
                return
        }
        
        var parameters = [APIParameters.email : email,
                          APIParameters.password : password]
        
        if let username = user.userName {
            parameters[APIParameters.username] = username
        }
        
        request = multipartURLRequest(with: request,
                                      parameters: parameters,
                                      filePathKey: APIParameters.avatar,
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
                DispatchQueue.main.async {
                    self.hideNetworkActividyIndicator()
                    if status == 400 {
                        self.showIncorrectRequestDescription(with: data)
                        
                        return
                    } else if status == 201 {
                        print("user successfully created")
                        if let data = data {
                            self.handleResponseData(data: data)
                        }
                    } else {
                        print("unknown status")
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
    
    private func showIncorrectRequestDescription(with data: Data?) {
        print("incorrect request data")
        if let data = data,
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let fields = dataDictionary?[APIResponseDataKeys.children] as? [String : Any]
        {
            var errorsDescription = ""
            for fieldKey in [APIResponseDataKeys.username, APIResponseDataKeys.email, APIResponseDataKeys.password, APIResponseDataKeys.avatar] {
                if let fieldInfo = fields[fieldKey] as? [String : Any],
                    let errors = fieldInfo[APIResponseDataKeys.errors] as? [String] {
                    for errorDescription in errors {
                        errorsDescription += "\(errorDescription) "
                    }
                    
                }
            }
            
            self.showAlert(with: "incorrect request data", message: errorsDescription)
        }
    }
}
