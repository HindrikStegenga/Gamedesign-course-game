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
    
    var matrix: simd_float4x4 = matrix_identity_float4x4
    var color: simd_float4 = [1,1,1,1]
}

extension DefaultUniformBuffer : FloatArrayConvertible {
    var floatArray: [Float] {
        get {
            var result = [matrix[0,0], matrix[1,0], matrix[2,0], matrix[3,0],
                          matrix[0,1], matrix[1,1], matrix[2,1], matrix[3,1],
                          matrix[0,2], matrix[1,2], matrix[2,2], matrix[3,2],
                          matrix[0,3], matrix[1,3], matrix[2,3], matrix[3,3]
                          ]
            result.append(contentsOf: [color.x, color.y, color.z, color.w])

            return result
        }
    }
}
