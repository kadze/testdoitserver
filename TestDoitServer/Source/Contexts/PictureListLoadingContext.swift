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
        
        ///////
//        let image = #imageLiteral(resourceName: "doll")
//        let item = ImageCollectionItem(image: image, address: "address 1", weather: "weather 1")
//        for _ in 1...3 {
//            imageCollection?.items.append(item)
//        }
//        
//        if let handler = successLoadHandler {
//            handler()
//        }
        
        ///////
        
        showNetworkActivityIndicator()

        dataTask = urlSession().dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                self.handleConnectionError(error: error)
            }
            
            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                if status == 403 {
                    print("invalid access token")
                    DispatchQueue.main.async {
                        self.hideNetworkActividyIndicator()
                    }
                    
                    return
                } else if status == 200 {
                    print("successfully done")
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
                let imageItem = ImageCollectionItem()
                
                if let images = json["images"] as? [[String:Any]] {
                    for image in images {
                        if let imagePath = image["smallImagePath"] as? String {
                            imageItem.smallImagePath = imagePath
                        }
                        
                        if let imagePath = image["bigImagePath"] as? String {
                            imageItem.bigImagePath = imagePath
                        }
                        
                        if let parameters = image["parameters"] as? [String:Any] {
                            if let latitude = parameters["latitude"] as? Float,
                                let longitude = parameters["longitude"] as? Float
                            {
                                imageItem.latitude = "\(latitude)"
                                imageItem.longitude = "\(longitude)"
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
