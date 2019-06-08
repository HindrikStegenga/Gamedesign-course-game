//
//  Vertex.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 07/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import simd

struct Vertex {
    var values: [Float] = [
        0.0, 0.0, 0.0, 0.0, //position
        0.0,0.0, //texture_coord
        0.0,0.0 //padding
        ]
    
    var position: vector_float4 {
        get {
            return [
                values[0],
                values[1],
                values[2],
                values[3],
            ]
        } set {
            values[0] = newValue.x
            values[1] = newValue.y
            values[2] = newValue.z
            values[3] = newValue.w
        }
    }
    
    var texture_coord: vector_float2 {
        get {
            return [values[4], values[5]];
        } set {
            values[4] = newValue.x
            values[5] = newValue.y
        }
    }
    
    init(position: vector_float4, texture_coord: vector_float2) {
        self.position = position
        self.texture_coord = texture_coord
    }
}

extension Vertex: FloatArrayConvertible {
    var floatArray: [Float] {
        get { return values }
    }
}