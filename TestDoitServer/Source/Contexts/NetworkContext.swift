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

protocol NetworkContextDelegate {
    func requestDictionary() -> Dictionary<String, Any>
}

@objc class NetworkContext: NSObject {
    
    struct HTTPMethod {
        static let get = "GET"
        static let post = "POST"
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
    var httpMethod = HTTPMethod.get //just default value
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
        request.httpMethod = httpMethod
        
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
}
