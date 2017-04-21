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
        }
    }
    
    func httpMethod() -> HTTPMethod {
        return HTTPMethod.post
    }
    
    //multipart request
    
//    func multipartURLRequest(with request: URLRequest,
//                             parameters: [String: String]?,
//                             filePathKey: String,
//                             paths: [String]) -> URLRequest
//    {
//        var resultRequest = request
//        let boundary = generateBoundaryString()
//        resultRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        resultRequest.httpBody = try? multipartRequestBody(with: parameters, filePathKey: filePathKey, paths: paths, boundary: boundary)
//        
//        return resultRequest
//    }
//    
//    func multipartRequestBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String)
//        throws -> Data
//    {
//        var body = Data()
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.append("\(value)\r\n")
//            }
//        }
//        
//        for path in paths {
//            let url = URL(fileURLWithPath: path)
//            let filename = url.lastPathComponent
//            let data = try Data(contentsOf: url)
//            let mimetype = mimeType(for: path)
//            
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
//            body.append("Content-Type: \(mimetype)\r\n\r\n")
//            body.append(data)
//            body.append("\r\n")
//        }
//        
//        body.append("--\(boundary)--\r\n")
//        
//        return body
//    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
//    func mimeType(for path: String) -> String {
//        let url = NSURL(fileURLWithPath: path)
//        let pathExtension = url.pathExtension
//        
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        
//        return "application/octet-stream";
//    }
}
