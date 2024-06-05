///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) .LICENSE
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Created by Alex Kozin
/// 2020 El Machine

import Foundation

/// Nil
/// Expressible
extension Wand: ExpressibleByNilLiteral {

    @inline(__always)
    convenience
    public
    init(nilLiteral: ()) {
        self.init()
    }

}

/// Array
/// Expressible
extension Wand: ExpressibleByArrayLiteral {

    @inline(__always)
    convenience
    public
    init(arrayLiteral array: Any...) {
        self.init()
        save(sequence: array)
    }

    @inline(__always)
    convenience
    public
    init(array: [Any]) {
        self.init()
        save(sequence: array)
    }

}

/// Float
/// Expressible
extension Wand: ExpressibleByFloatLiteral {

    @inline(__always)
    convenience
    public
    init(floatLiteral value: Float) {
        self.init()
        context[FloatLiteralType.self|] = value
    }

}

/// String
/// Expressible
extension Wand: ExpressibleByStringLiteral {

    @inline(__always)
    convenience
    public
    init(stringLiteral value: String) {
        self.init()
        context[StringLiteralType.self|] = value
    }

}

/// Bool
/// Expressible
extension Wand: ExpressibleByBooleanLiteral {

    @inline(__always)
    convenience
    public
    init(booleanLiteral value: Bool) {
        self.init()
        context[BooleanLiteralType.self|] = value
    }

}

/// Int
/// Expressible
extension Wand: ExpressibleByIntegerLiteral {

    @inline(__always)
    convenience
    public
    init(integerLiteral value: Int) {
        self.init()
        context[IntegerLiteralType.self|] = value
    }

}

/// Dictionary
/// Expressible
extension Wand: ExpressibleByDictionaryLiteral {

    @inline(__always)
    convenience
    public
    init(dictionaryLiteral elements: (String, Any)...) {
        self.init()

        elements.forEach { (key, object) in
            Wand[object] = self
            context[key] = object
        }
    }

    @inline(__always)
    convenience
    public
    init(dictionary: [String: Any]) {
        self.init()

        dictionary.forEach { (key, object) in
            Wand[object] = self
            context[key] = object
        }
    }

}

/// StringInterpolation
/// Expressible
extension Wand: ExpressibleByStringInterpolation {

    @inline(__always)
    convenience
    public
    init(stringInterpolation: StringInterpolation) {
        self.init()
        context[StringInterpolation.self|] = stringInterpolation
    }

}

/// UnicodeScalar
/// Expressible
extension Wand: ExpressibleByUnicodeScalarLiteral {

    @inline(__always)
    convenience
    public
    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init()
        context[UnicodeScalarLiteralType.self|] = value
    }

}

/// ExtendedGraphemeCluster
/// Expressible
extension Wand: ExpressibleByExtendedGraphemeClusterLiteral {

    @inline(__always)
    convenience
    public
    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init()
        context[ExtendedGraphemeClusterLiteralType.self|] = value
    }

}
