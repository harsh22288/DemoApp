//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by  Harsh Saxena on 15/05/19.
//  Copyright © 2019  Harsh Saxena. All rights reserved.
//

import XCTest
@testable import DemoApp

class DemoAppTests: XCTestCase {
    
    var vc: ViewController!
   
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "main") as? ViewController
        let _ = vc.view
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
    
    func testHasATableView() {
        XCTAssertNotNil(vc.tableView)
    }
    
    
    func testfindSearchCorrect() { // bound to be correct
        
        XCTAssert(true)
        let text = "Republic"
        vc.filterSearchController(searchBar: text)
        XCTAssert(vc.filterArray.count > 0)
    }
    
    func testfindSearchWrong() {  // bound to fail
        let text = "Harsh"
        vc.filterSearchController(searchBar: text)
        XCTAssert(vc.filterArray.count > 0)
    }
    
    

}
