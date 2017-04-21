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
    
    //initialization with default singleton for testing purposes
    init(appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate) {
        self.appDelegate = appDelegate
        user = appDelegate.user
    }
    
    override func execute() {
        var request = self.request()
        
        let fileURL = URL(string: "")!
        let parameters:[String : String]? = nil
        let image = UIImage()
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
        
    }
    
    private func multipartURLRequest(with request: URLRequest,
                             parameters: [String: String]?,
                             filePathKey: String,
                             fileURL: URL,
                             image: UIImage) -> URLRequest
    {
        var resultRequest = request
        let boundary = generateBoundaryString()
        resultRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        resultRequest.httpBody = multipartRequestBody(with: parameters, filePathKey: filePathKey, url: fileURL, image: image, boundary: boundary)
        
        return resultRequest
    }
    
    private func multipartRequestBody(with parameters: [String: String]?, filePathKey: String, url: URL, image: UIImage, boundary: String)
        -> Data
    {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        let filename = url.lastPathComponent
        let mimetype = mimeType(for: url)
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        if let data = UIImageJPEGRepresentation(image, 1) {
            body.append(data)
        }
        
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    private func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        
        return "application/octet-stream";
    }
}
