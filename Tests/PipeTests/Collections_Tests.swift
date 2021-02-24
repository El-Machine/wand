//
//  CollectionsTests.swift
//  SampleTests
//
//  Created by Alex Kozin on 08.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

//import XCTest
//
//class Collections_Tests: XCTestCase {
//
//    func testArrayRange() throws {
//        let array = [Bool](repeating: false, count: 42)
//        
//        let range: Range<Int> = array|
//        XCTAssertTrue(range.first == 0)
//        XCTAssertTrue(range.last == array.count - 1)
//    }
//    
//    func testArrayIndexPath() throws {
//        let array = [Bool](repeating: false, count: 42)
//        
//        let paths: [IndexPath] = array|
//        XCTAssertTrue(paths.first?.row == 0)
//        XCTAssertTrue(paths.last?.row == array.count - 1)
//    }
//    
//    func testRangeIndexPath() throws {
//        let range = 0..<42
//        
//        let paths: [IndexPath] = range|
//        XCTAssertTrue(paths.first?.row == 0)
//        XCTAssertTrue(paths.last?.row == range.last)
//    }
//    
//    func testRangeInt() throws {
//        let range = 0..<42
//
//        let randomInt: Int = range|
//        XCTAssertTrue(randomInt >= range.first!)
//        XCTAssertTrue(randomInt <= range.last!)
//    }
//
//}
