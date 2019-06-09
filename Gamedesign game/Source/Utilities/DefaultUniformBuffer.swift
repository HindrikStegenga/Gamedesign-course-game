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
    var color: simd_float4 = [1,1,1,1]
}

extension DefaultUniformBuffer : FloatArrayConvertible {
    var floatArray: [Float] {
        get {
            var result = matrix.m
            result.append(contentsOf: [color.x, color.y, color.z, color.w])

            return result
        }
    }
}
