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

extension Float {
    
    public static func remap (_ value: Float, _ from1: Float, _ to1: Float, _ from2: Float, _ to2: Float) -> Float {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }
    
}
