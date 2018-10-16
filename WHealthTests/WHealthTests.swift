//
//  WHealthTests.swift
//  WHealthTests
//
//  Created by Jovito Royeca on 12.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import XCTest
import PromiseKit
@testable import WHealth

class WHealthTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadRemoteData() {
        let expectation = self.expectation(description: "testLoadRemoteData")
        let webService = WebServiceAPI()
        
        firstly {
            webService.fetchTopics()
        }.then { (topics: [[String: Any]]) in
            CoreDataAPI.sharedInstance.save(topics)
        }.done {
            print("Done loading local data.")
            expectation.fulfill()
        }.catch { error in
            print("\(error)")
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testLoadLocalData() {
        let expectation = self.expectation(description: "testLoadLocalData")
        let webService = WebServiceAPI()
        
        firstly {
            webService.loadTopics()
        }.then { (topics: [[String: Any]]) in
            CoreDataAPI.sharedInstance.save(topics)
        }.done {
            print("Done loading local data.")
            expectation.fulfill()
        }.catch { error in
            print("\(error)")
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }

//    func testTopicsModel() {
//        let viewModel = TopicsViewModel()
//
//        viewModel.fetchData()
//        XCTAssert(!viewModel.isEmpty())
//
//        for i in 0...viewModel.numberOfSections() - 1{
//            print("section \(i) : row \(viewModel.numberOfRows(inSection: i))")
//        }
//    }
}
