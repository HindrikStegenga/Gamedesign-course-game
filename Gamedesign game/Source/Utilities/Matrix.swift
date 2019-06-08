//
//  Matrix.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 08/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import simd

struct Matrix {
    var m: [Float]
    
    init() {
        m = [1, 0, 0, 0,
             0, 1, 0, 0,
             0, 0, 1, 0,
             0, 0, 0, 1
        ]
    }
    
    @discardableResult
    mutating func setScale(_ scale: simd_float3) -> Matrix {
        
        m[0] = scale.x
        m[5] = scale.y
        m[10] = scale.z
        m[15] = 1.0
        
        return self
    }
    
    @discardableResult
    mutating func setPosition(_ translation: simd_float3) -> Matrix {
        
        m[12] = translation.x
        m[13] = translation.y
        m[14] = translation.z
        
        return self
    }
    
    @discardableResult
    mutating func setRotation(_ rotation: simd_float3) -> Matrix {
        
        m[0] = cos(rotation.y) * cos(rotation.z)
        m[4] = cos(rotation.z) * sin(rotation.x) * sin(rotation.y) - cos(rotation.x) * sin(rotation.z)
        m[8] = cos(rotation.x) * cos(rotation.z) * sin(rotation.y) + sin(rotation.x) * sin(rotation.z)
        m[1] = cos(rotation.y) * sin(rotation.z)
        m[5] = cos(rotation.x) * cos(rotation.z) + sin(rotation.x) * sin(rotation.y) * sin(rotation.z)
        m[9] = -cos(rotation.z) * sin(rotation.x) + cos(rotation.x) * sin(rotation.y) * sin(rotation.z)
        m[2] = -sin(rotation.y)
        m[6] = cos(rotation.y) * sin(rotation.x)
        m[10] = cos(rotation.x) * cos(rotation.y)
        m[15] = 1.0

        return self
    }
}
