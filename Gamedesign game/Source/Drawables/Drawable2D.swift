//
//  Drawable2D.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 07/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Metal
import simd

class Drawable2D {
    
    var position: simd_float2
    var rotation: simd_float1
    
    let vertex_func_name: String = "default_vertex_func"
    let fragment_func_name: String = "default_fragment_func"
    
    let vertex_buffer_source: FloatArrayConvertible
    let index_buffer_source: [UInt16]
    var uniform_buffer_source: FloatArrayConvertible
    
    init(position:(x: Float, y: Float), rotation: Float, vertices: FloatArrayConvertible, indices: [UInt16], uniform: FloatArrayConvertible) {
        self.position = float2(position.x, position.y)
        self.vertex_buffer_source = vertices
        self.index_buffer_source = indices
        self.rotation = rotation
        self.uniform_buffer_source = uniform
    }
}
