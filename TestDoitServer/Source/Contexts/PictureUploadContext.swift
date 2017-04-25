//
//  LoginContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit
import MobileCoreServices

class PictureUploadContext : NetworkContext {
    var dataTask: URLSessionDataTask?
    var user: User?
    var completionHandler: ((Bool) -> Void)?
    let appDelegate: AppDelegate  //singleton property for testing purposes
    let model: PictureUploadModel
    
    //initialization with default singleton for testing purposes
    init(model: PictureUploadModel, appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate, completionHandler: ((Bool) -> Void)?) {
        self.completionHandler = completionHandler
        self.appDelegate = appDelegate
        self.model = model
        user = appDelegate.user
    }
    
    override func execute() {
        var request = self.request()
        
        guard let fileURL = model.imageFileURL,
            let token = user?.token,
            let longitude = model.longitude,
            let latitude = model.latitude,
            let image = model.image else {
                return
        }
        
        request.setValue(token, forHTTPHeaderField: "token")
        var parameters: [String : String] = ["latitude" : "\(latitude)",
                          "longitude" : "\(longitude)"]
        
        if let imageDescription = model.imageDescription {
            if imageDescription.characters.count > 0 {
                parameters["description"] = imageDescription
            }
        }
        
        if let tag = model.hashtag {
            if tag.characters.count > 0 {
                parameters["hashtag"] = tag
            }
        }
        
        request = multipartURLRequest(with: request,
                                      parameters: parameters,
                                      filePathKey: "image",
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
                    if status == 201 {
                        print("image successfully created")
                        if let data = data {
                            self.handleResponseData(data: data)
                            if let completionHandler = self.completionHandler {
                                completionHandler(true)
                            }
                        }
                    } else {
                        if status == 400 {
                            self.showIncorrectRequestDescription(with: data)
                        } else if status == 403 {
                            print("invalid access token")
                            self.unsuccessOperationAlert()
                        } else {
                            print("unknown status")
                            self.unsuccessOperationAlert()
                        }
                        
                        if let data = data,
                            let answer = String(data: data, encoding: .utf8) {
                            print(answer)
                        }
                        
                        if let completionHandler = self.completionHandler {
                            completionHandler(false)
                        }
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
        return "/image"
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
    
    private func showIncorrectRequestDescription(with data: Data?) {
        print("incorrect request data")
        if let data = data,
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let fields = dataDictionary?["children"] as? [String : Any]
        {
            var errorsDescription = ""
            for fieldKey in ["image", "hashtag", "latitude", "longitude"] {
                if let fieldInfo = fields[fieldKey] as? [String : Any],
                    let errors = fieldInfo["errors"] as? [String] {
                    for errorDescription in errors {
                        errorsDescription += "\(errorDescription) "
                    }
                    
                }
            }
            
            self.showAlert(with: "incorrect request data", message: errorsDescription)
        }
    }
}
