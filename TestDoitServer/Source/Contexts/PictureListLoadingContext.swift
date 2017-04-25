//
//  PictureListLoadingContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureListLoadingContext : NetworkContext {
    var dataTask: URLSessionDataTask?
    var user: User
    var successLoadHandler: (() -> ())?
    let appDelegate: AppDelegate  //singleton property for testing purposes
    weak var imageCollection: ImageCollection?
    
    init(imageCollection: ImageCollection, appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate, completionHandler: (() -> ())?) {
        self.imageCollection = imageCollection
        self.appDelegate = appDelegate
        self.user = appDelegate.user
        successLoadHandler = completionHandler
        super.init()
    }
    
    override func execute() {
        var request = self.request()
        request.setValue(user.token, forHTTPHeaderField: "token")
        
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
                        print("successfully done")
                        if let data = data {
                            self.handleResponseData(data: data)
                        }
                    } else {
                        if status == 403 {
                            print("invalid access token")
                            if let data = data,
                                let answer = String(data: data, encoding: .utf8) {
                                print(answer)
                            }
                        } else {
                            print("unknown status")
                            if let data = data,
                                let answer = String(data: data, encoding: .utf8) {
                                print(answer)
                            }
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
        return "/all"
    }
    
    override func httpMethod() -> HTTPMethod {
        return HTTPMethod.get
    }
    
    //MARK:-
    //MARK: Private
    
    private func handleResponseData(data: Data) {
        //logging
        if let answer = String(data: data, encoding: .utf8) {
            print(answer)
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                imageCollection?.items.removeAll()
                if let images = json["images"] as? [[String:Any]] {
                    for image in images {
                        let imageItem = ImageCollectionItem()
                        
                        if let imagePath = image["smallImagePath"] as? String {
                            imageItem.smallImagePath = imagePath
                        }
                        
                        if let imagePath = image["bigImagePath"] as? String {
                            imageItem.bigImagePath = imagePath
                        }
                        
                        if let parameters = image["parameters"] as? [String:Any] {
                            if let address = parameters["address"] as? String {
                                imageItem.address = address
                            }
                            
                            if let weather = parameters["weather"] as? String {
                                imageItem.weather = weather
                            }
                        }
                        
                        imageCollection?.items.append(imageItem)
                    }
                }
            
                if let handler = successLoadHandler {
                    handler()
                }
            }
        } catch  {
            print("Error reading response data Json: \(error)")
        }
    }
}
