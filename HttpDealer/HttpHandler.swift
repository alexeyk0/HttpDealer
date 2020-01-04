//
//  HttpHandler.swift
//  HttpTester
//
//  Created by Alexey Kozlov on 02/01/2020.
//  Copyright © 2020 Alexey Kozlov. All rights reserved.
//

import Foundation

public class HttpHandler:NSObject {

    private let opQueue = OperationQueue()
    private var session:URLSession?
    
    public weak var delegate: HttpHandlerDelegate?
    
    public var maxNumberOfRedirects : Int
    private var currentNumberOfRedirects : Int = 0
    private var redirectArray : [URL] = []
    
    public init(maxNumberOfRedirects : Int, httpHandlerDelegate : HttpHandlerDelegate) {
        self.delegate = httpHandlerDelegate
        self.maxNumberOfRedirects = maxNumberOfRedirects
        opQueue.maxConcurrentOperationCount = 1
    }

    public func getDataFromUrl(url: URL) {
        self.resetSession()
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = nil
        
        self.session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: self.opQueue)
        
        let request = URLRequest(url: url)
        if let task = self.session?.dataTask(with: request) {
            task.resume()
        }
    }
    
    private func resetSession() {
        self.currentNumberOfRedirects = 0
        self.redirectArray.removeAll()
        self.session?.finishTasksAndInvalidate()
    }
    
    private func travis() {
        
    }
    
    deinit {
        self.session?.finishTasksAndInvalidate()
    }
}

extension HttpHandler : URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Void) {
        if let url = request.url {
            redirectArray.append(url)
        }
      
        if let task = self.session?.dataTask(with: request), currentNumberOfRedirects < maxNumberOfRedirects {
            currentNumberOfRedirects = currentNumberOfRedirects + 1
            task.resume()
        }
        else {
            self.delegate?.didFailWithError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Too many redirects"]))
            task.cancel()
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.delegate?.didFailWithError(error)
        }
        else {
            self.delegate?.didFinishRedirects(self.redirectArray)
        }
    }

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let responseText = String(data: data, encoding: .utf8) {
            self.delegate?.didRecieveData(responseText)
        }
    }
}

