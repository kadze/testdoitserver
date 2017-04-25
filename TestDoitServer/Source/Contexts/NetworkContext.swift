////
////  NetworkContext.swift
////
////
////  Created by ASH on 3/20/17.
////  
////
//

import Foundation
import UIKit
import MobileCoreServices

protocol NetworkContextDelegate {
    func requestDictionary() -> Dictionary<String, Any>
}

@objc class NetworkContext: NSObject {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    //MARK:-
    //MARK: Initialization
    
    override init() {
        super.init()
        requestDictionary = dictionaryForRequest()
    }
    
    //MARK:-
    //MARK: Properties
    
    var requestDictionary: Dictionary<String, Any> = [:]
    var requestTimeInterval: TimeInterval = 120
    
    var url: URL {
        get {
            if let result = URL(string: urlString.appending(urlStringForRequest())) {
                return result
            }
            
            return URL(string:"")!
        }
    }
    
    let urlString = "http://api.doitserver.in.ua"
    
    //MARK:-
    //MARK: Public
    
    func execute() {
        
    }
    
    func cancel() {
        
    }
    
    func urlSession() -> URLSession {
        return NetworkManager.sharedInstance.defaultSession
    }
    
    func urlStringForRequest() -> String {
        return ""
    }
    
    func dictionaryForRequest() -> Dictionary<String, Any> {
        return [:]
    }
    
    func request() -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: requestTimeInterval)
        request.httpMethod = httpMethod().rawValue
        
        return request
    }
    
    func completeRequestDictionary() {
        completeRequestDictionaryWithToken()
    }
    
    func completeRequestDictionaryWithToken() {
        
    }
    
    func showNetworkActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideNetworkActividyIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func handleConnectionError(error: Error?) {
        DispatchQueue.main.async {
            print(error.debugDescription)
            let alertController = UIAlertController(title: "Connection error", message: "problems with internet connection", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            UIAlertController.viewControllerForPresentingAlertNotAlertController()?.present(alertController, animated: true, completion: nil)

        }
    }
    
    func httpMethod() -> HTTPMethod {
        return HTTPMethod.post
    }
    
    //multipart request
    
    func multipartURLRequest(with request: URLRequest,
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
    
    func multipartRequestBody(with parameters: [String: String]?, filePathKey: String, url: URL, image: UIImage, boundary: String)
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
    
    func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        
        return "application/octet-stream";
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func unsuccessOperationAlert() {
        let alertController = UIAlertController(title: "O_o", message: "operation was not completed successfully", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        UIAlertController.viewControllerForPresentingAlert()?.present(alertController, animated: true, completion: nil)
    }
}
