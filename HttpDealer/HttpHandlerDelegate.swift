//
//  HttpHandlerDelegate.swift
//  HttpTester
//
//  Created by Alexey Kozlov on 03/01/2020.
//  Copyright © 2020 Alexey Kozlov. All rights reserved.
//

import Foundation

public protocol HttpHandlerDelegate : AnyObject {
    func didFailWithError(_ error: Error)
    func didRecieveData(_ stringData: String)
    func didFinishRedirects(_ redirectArray: [URL])
}

public extension HttpHandlerDelegate {
    func didFinishRedirects(_ redirectArray: [URL]) {}
}
