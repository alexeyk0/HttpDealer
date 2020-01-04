//
//  HttpDealerTests.swift
//  HttpDealerTests
//
//  Created by Alexey Kozlov on 04/01/2020.
//  Copyright © 2020 Alexey Kozlov. All rights reserved.
//

import XCTest
@testable import HttpDealer

class HttpDealerTests: XCTestCase, HttpHandlerDelegate {
    func didFailWithError(_ error: Error) {
    
    }
    
    func didRecieveData(_ stringData: String) {
        dataExpectation.fulfill()
    }
    
    
    var httpHandler: HttpHandler!
    private var dataExpectation: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        httpHandler = HttpHandler(maxNumberOfRedirects: 0, httpHandlerDelegate: self)
    }

    func testInit() {
        XCTAssertEqual(httpHandler.maxNumberOfRedirects, 0, "Wrong initialization")
    }

    func testAsynchronousData() {
        dataExpectation = expectation(description: "data")
        httpHandler.maxNumberOfRedirects = 4
        httpHandler.getDataFromUrl(url: URL(string: "http://www.mocky.io/v2/5e0af46b3300007e1120a7ef")!)
        waitForExpectations(timeout: 5)

    }
}
