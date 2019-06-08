//
// Created by Hindrik Stegenga on 2019-06-08.
// Copyright (c) 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation

protocol FloatArrayConvertible {
    var floatArray: [Float] {get}
}

extension Array : FloatArrayConvertible where Element == Float  {
    var floatArray: [Float] {
        get {
            return self
        }
    }
}