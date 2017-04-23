//
//  PictureDownloadContext.swift
//  TestDoitServer
//
//  Created by ASH on 4/20/17.
//  Copyright © 2017 SAP. All rights reserved.
//

import UIKit

class PictureDownloadContext {
    let url: URL
    var dataTask: URLSessionDataTask?
    var completionHandler: ((UIImage?) -> ())?
    var image: UIImage?
    
    init(url: URL, completionHandler: ((UIImage?) -> ())?) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    func execute() {
        
        dataTask?.cancel()
        
        showNetworkActivityIndicator()

        let session = NetworkManager.sharedInstance.defaultSession
        dataTask = session.dataTask(with: url, completionHandler: {[unowned self] (data, response, error) in
            if let error = error {
                print("error downloading image from url: \(self.url) : \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.hideNetworkActividyIndicator()
                if let data = data {
                    self.handleResponseData(data: data)
                }
            }
        })
        
        if let dataTask = dataTask {
            dataTask.resume()
        } else {
            hideNetworkActividyIndicator()
        }
    }
    
    //MARK:-
    //MARK: Private
    
    private func handleResponseData(data: Data) {
        //logging
        if let answer = String(data: data, encoding: .utf8) {
            print(answer)
        }
        
        image = UIImage(data: data)
        if let completionHandler = completionHandler {
            completionHandler(image)
        }
    }
    
    func showNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideNetworkActividyIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
