//
//  DefaultUniformBuffer.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Metal
import simd

class DefaultUniformBuffer {
    
    var matrix: Matrix = Matrix()
}

extension DefaultUniformBuffer : FloatArrayConvertible {
    var floatArray: [Float] {
        get {
            return matrix.m
        }
    }
}
