//
//  Drawable.swift
//  Gamedesign game
//
//  Created by Hindrik Stegenga on 06/06/2019.
//  Copyright © 2019 Hindrik Stegenga. All rights reserved.
//

import Foundation
import MetalKit


protocol Drawable {
    
    var vertex_func_name: String {get}
    var fragment_func_name: String {get}
    
    var vertex_buffer_source: [Float] {get}
    var index_buffer_source: [UInt16] {get}
    
    var vertex_buffer: MTLBuffer! {get set}
    var index_buffer: MTLBuffer! {get set}
    
    var vertex_func: MTLFunction! {get set}
    var fragment_func: MTLFunction! {get set}
    
    var render_pipeline_state: MTLRenderPipelineState! {get set}
    
}

extension Drawable {
    
    func create_vertex_buffer(device: MTLDevice) -> MTLBuffer? {
        return device.makeBuffer(bytes: vertex_buffer_source, length: sizeof(vertex_buffer_source), options: [])
    }
    
    func create_index_buffer(device: MTLDevice) -> MTLBuffer? {
        return device.makeBuffer(bytes: index_buffer_source, length: sizeof(index_buffer_source), options: [])
    }
    
    func create_render_pipeline_state(device: MTLDevice) -> MTLRenderPipelineState? {
        let pplDescriptor = MTLRenderPipelineDescriptor()
        pplDescriptor.vertexFunction = vertex_func
        pplDescriptor.fragmentFunction = fragment_func
        
        pplDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        return try? device.makeRenderPipelineState(descriptor: pplDescriptor)
    }
    
    func create_vertex_func(library: MTLLibrary) -> MTLFunction? {
        return library.makeFunction(name: vertex_func_name)
    }
    
    func create_fragment_func(library: MTLLibrary) -> MTLFunction? {
        return library.makeFunction(name: fragment_func_name)
    }
    
    mutating func render_drawable(device: MTLDevice, library: MTLLibrary, commandEncoder: MTLRenderCommandEncoder) {
        
        if vertex_buffer == nil {
            vertex_buffer = create_vertex_buffer(device: device)
            guard vertex_buffer != nil else {
                fatalError("Cannot create vertex_buffer.")
            }
        }
        
        if index_buffer == nil {
            index_buffer = create_index_buffer(device: device)
            guard index_buffer != nil else {
                fatalError("Cannot create index_buffer.")
            }
        }
        
        if vertex_func == nil {
            vertex_func = create_vertex_func(library: library)
            guard vertex_func != nil else {
                fatalError("Cannot create vertex_func.")
            }
        }
        
        if fragment_func == nil {
            fragment_func = create_fragment_func(library: library)
            guard fragment_func != nil else {
                fatalError("Cannot create fragment_func.")
            }
        }
        
        if render_pipeline_state == nil {
            render_pipeline_state = create_render_pipeline_state(device: device)
            guard render_pipeline_state != nil else {
                fatalError("Cannot create render pipeline state.")
            }
        }
        
        commandEncoder.setRenderPipelineState(render_pipeline_state)
        commandEncoder.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangleStrip, indexCount: index_buffer_source.count, indexType: .uint16, indexBuffer: index_buffer, indexBufferOffset: 0)
    }
}
