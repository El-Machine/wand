///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) LICENSE file
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///

import Foundation

/// Nil
/// Expressible
extension Wand: ExpressibleByNilLiteral {

    public
    convenience init(nilLiteral: ()) {
        self.init()
    }

}

/// Array
/// Expressible
extension Wand: ExpressibleByArrayLiteral {

    public convenience init(arrayLiteral array: Any...) {
        self.init()
        save(sequence: array)
    }

    public convenience init(array: [Any]) {
        self.init()
        save(sequence: array)
    }

}

/// Float
/// Expressible
extension Wand: ExpressibleByFloatLiteral {

    public
    convenience init(floatLiteral value: Float) {
        self.init()

        context[FloatLiteralType.self|] = value
    }

}

/// String
/// Expressible
extension Wand: ExpressibleByStringLiteral {

    public
    convenience
    init(stringLiteral value: String) {
        self.init()

        context[StringLiteralType.self|] = value
    }

}

/// Bool
/// Expressible
extension Wand: ExpressibleByBooleanLiteral {

    public
    convenience
    init(booleanLiteral value: Bool) {
        self.init()

        context[BooleanLiteralType.self|] = value
    }

}

/// Int
/// Expressible
extension Wand: ExpressibleByIntegerLiteral {

    public
    convenience
    init(integerLiteral value: Int) {
        self.init()

        context[IntegerLiteralType.self|] = value
    }

}

/// Dictionary
/// Expressible
extension Wand: ExpressibleByDictionaryLiteral {

    public
    convenience init(dictionaryLiteral elements: (String, Any)...) {
        self.init()

        elements.forEach { (key, object) in
            Wand[object] = self
            context[key] = object
        }
    }

    public
    convenience init(dictionary: [String: Any]) {
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

    public
    convenience
    init(stringInterpolation value: StringInterpolation) {
        self.init()

        context[StringInterpolation.self|] = value
    }

}

/// UnicodeScalar
/// Expressible
extension Wand: ExpressibleByUnicodeScalarLiteral {

    public
    convenience
    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init()

        context[UnicodeScalarLiteralType.self|] = value
    }

}

/// ExtendedGraphemeCluster
/// Expressible
extension Wand: ExpressibleByExtendedGraphemeClusterLiteral {

    public
    convenience
    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init()

        context[ExtendedGraphemeClusterLiteralType.self|] = value
    }

}
