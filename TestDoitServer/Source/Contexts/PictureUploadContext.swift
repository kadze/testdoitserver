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
    var successHandler: (() -> ())?
    let appDelegate: AppDelegate  //singleton property for testing purposes
    let model: PictureUploadModel
    
    //initialization with default singleton for testing purposes
    init(model: PictureUploadModel, appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate) {
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
                if status == 400 {
                    print("incorrect request data")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                    }
                    
                    return
                } else if status == 403 {
                    print("invalid access token")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                    }
                    
                    return
                }
                
                else if status == 201 {
                    print("image successfully created")
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
        if let successHandler = successHandler {
            successHandler()
        }
    }
}
