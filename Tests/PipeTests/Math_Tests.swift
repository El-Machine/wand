//
//  Math_Tests.swift
//  SampleTests
//
//  Created by Alex Kozin on 08.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import XCTest

class Math_Tests: XCTestCase {

    func testBoolNumeric() throws {
        let intTrue: Double = true|
        let intFalse: Int = false|
        
        XCTAssertTrue(intTrue == 1)
        XCTAssertTrue(intFalse == 0)
    }
    
    func testIntIndexSet() throws {
        let int = 42
        
        let indexSet: IndexSet = int|
        XCTAssertTrue(indexSet.first == 0)
        XCTAssertTrue(indexSet.last == int)
    }
    
    func testIntIndexPath() throws {
        let int = 42
        
        let indexPath: IndexPath = int|
        XCTAssertTrue(indexPath.row == int)
    }
    
    func testIntIndexPathArray() throws {
        let int = 42
        
        let paths: [IndexPath] = int|
        XCTAssertTrue(paths.first?.row == int)
    }

}
