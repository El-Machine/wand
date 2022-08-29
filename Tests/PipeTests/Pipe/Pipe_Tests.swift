//
//  Pipe_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 03.05.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation.CLLocation

import Pipe
import XCTest

class Pipe_Tests: XCTestCase {

    weak var pipe: Pipeline?

    func test_put() throws {
        let pipe = Pipeline()
        self.pipe = pipe

        let struct_ = CLLocationCoordinate2D.any
        pipe.put(struct_)

        let custom_struct = Custom(foo: .any)
        pipe.put(custom_struct)

        let class_ = pipe.put(CLLocation.any)


        let custom_class = CustomClass()
        custom_class.foo = .any
        pipe.put(custom_class)

        // piped equals original
        let piped_struct: CLLocationCoordinate2D = try XCTUnwrap(pipe.get())
        XCTAssertTrue(struct_.latitude == piped_struct.latitude &&
                      struct_.longitude == piped_struct.longitude)

        let piped_custom_struct: Custom = try XCTUnwrap(pipe.get())
        XCTAssertTrue(custom_struct.foo == piped_custom_struct.foo)

        XCTAssertEqual(class_, pipe.get())

        let piped_custom_class: CustomClass = try XCTUnwrap(pipe.get())
        XCTAssertIdentical(custom_class, piped_custom_class)

        pipe.close()
    }

    func test_putPipable() throws {
        let pipe = Pipeline()
        self.pipe = pipe

        let original = CLLocation(latitude: (-90...90)|,
                                  longitude: (-180...180)|)
        pipe.put(original)

        // piped equals original
        let piped: CLLocation = try XCTUnwrap(pipe.get())
        XCTAssertEqual(original, piped)

        // pipe is same
        XCTAssertTrue(pipe === piped.pipe)
        XCTAssertTrue(original.pipe === piped.pipe)

        pipe.close()
    }

    func test_closed() throws {
        XCTAssertNil(pipe)
    }


    private struct Custom {
        var foo: Int
    }

    private class CustomClass {
        var foo: Int?
    }

}
