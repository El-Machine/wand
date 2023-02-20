//
//  Event_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 29.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation
import CoreMotion

import Pipe
import XCTest

class Expect_T_Tests: XCTestCase {

    func test_Every() throws {
        //Insert 'count' times
        let count: Int = .any(in: 1...42)

        let e = expectation()
        e.expectedFulfillmentCount = count

        var last: Vector!

        //Wait for 'count' Vectors
        weak var pipe: Pipeline!
        pipe = |.every { (vector: Vector) in
            //Is equal?
            if vector == last {
                e.fulfill()
            }
        }

        //Put for 'count' Vectors
        (0..<count).forEach { _ in
            let vector = Vector.any
            last = vector

            pipe.put(vector)
        }

        waitForExpectations(timeout: .default)

        pipe.close()
        XCTAssertNil(pipe)
    }

    func test_One() throws {
        let e = expectation()

        let vector = Vector.any

        weak var pipe: Pipeline!
        pipe = |.one { (vector: Vector) in
            e.fulfill()
        }

        pipe.put(vector)

        waitForExpectations()
        XCTAssertNil(pipe)
    }

    func test_While() throws {

        func put() {
            DispatchQueue.main.async {
                pipe.put(Vector.any)
            }
        }

        let e = expectation()

        weak var pipe: Pipeline!
        pipe = |.while { (vector: Vector) in

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
        XCTAssertNil(pipe)
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

    static func ask<T>(_ ask: Ask<T>, from pipe:Pipeline) {

        if pipe.ask(for: ask) {
            //Strong reference to pipe
            ask.cleaner = {
                print(pipe.description)
            }
        }

    }

}
