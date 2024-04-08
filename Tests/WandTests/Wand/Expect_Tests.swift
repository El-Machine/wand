//
//  Event_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 29.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation
import CoreMotion

import Wand
import XCTest

class Expect_T_Tests: XCTestCase {

    func test_Every() throws {
        //Insert 'count' times
        let count: Int = .any(in: 1...22)

        let e = expectation()
        e.expectedFulfillmentCount = count

        var last: Vector?

        //Wait for 'count' Vectors
        weak var wand: Wand!
        wand = |.every { (vector: Vector) in
            //Is equal?
            if vector == last {
                e.fulfill()
            }
        }

        //Put for 'count' Vectors
        var i = 0
        (0..<count).forEach { _ in
            let vector = Vector.any
            last = vector

            wand.add(vector)

            print(count)
            i = i+1
        }

        waitForExpectations(timeout: .default)

        wand.close()
        //TODO: Fix
        //XCTAssertNil(wand)
    }

    func test_One() throws {
        let e = expectation()

        let vector = Vector.any

        weak var wand: Wand!
        wand = |.one { (vector: Vector) in
            e.fulfill()
        }

        wand.add(vector)

        waitForExpectations()
        XCTAssertNil(wand)
    }

    func test_While() throws {

        func put() {
            DispatchQueue.main.async {
                wand.add(Vector.any)
            }
        }

        let e = expectation()

        weak var wand: Wand!
        wand = |.while { (vector: Vector) in

            if vector.id == 2 {
                e.fulfill()
                return false
            } else {
                put()
                return true
            }

        }

        put()

        waitForExpectations()
        XCTAssertNil(wand)
    }


}


fileprivate struct Vector: Equatable, Any_ {

    let id: Int

    let x, y, z: Float
    var t: TimeInterval


    static var any: Vector {
        .init(id: .any(in: 0...4), x: .any, y: .any, z: .any, t: .any)
    }
}

extension Vector: AskingWithout {

    static func wand<T>(_ wand: Wand, asks: Ask<T>) {

        _ = wand.answer(the: asks)

    }

}
