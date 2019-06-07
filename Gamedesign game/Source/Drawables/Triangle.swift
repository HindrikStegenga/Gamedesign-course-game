//
//  Triangle.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import Metal

class Triangle : Drawable {
    var vertex_func_name: String = "default_vertex_func"
    var fragment_func_name: String = "default_fragment_func"
    
    var vertex_buffer: MTLBuffer! = nil
    var index_buffer: MTLBuffer! = nil
    var vertex_func: MTLFunction!
    var fragment_func: MTLFunction!
    var render_pipeline_state: MTLRenderPipelineState!
    
    var vertex_buffer_source: [Float] {
        get {
            return [
                -1.0, -1.0, 0.0, 1.0,
                1.0, -1.0, 0.0, 1.0,
                0.0, 1.0, 0.0, 1.0
            ]
        }
    }
    
    var index_buffer_source: [UInt16] {
        get {
            return [0,1,2,3]
        }
    }
}
